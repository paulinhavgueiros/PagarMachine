//
//  ResultsViewController.m
//  PagarMachine
//
//  Created by Paula Vasconcelos Gueiros on 22/1/17.
//  Copyright © 2017 Paula Vasconcelos Gueiros. All rights reserved.
//

#import "ResultsViewController.h"
#import "Utils.h"
#import "desafio.h"

typedef enum {
    DotStateAllHidden = 0,
    DotStateFirstShown = 1,
    DotStateSecondShown = 2,
    DotStateThirdShown = 3
} DotState;

typedef enum {
    ReturnCodeOperationInitialized = 0,
    ReturnCodeOperationFinalized = 1,
    ReturnCodeOperationAuthorizationSuccessful = 2,
    ReturnCodeOperationCaptureSuccessful = 3,
    ReturnCodeOperationError = 5,
    ReturnCodeOperationReversal = 6,
    ReturnCodeOperationInvalidParameter = 7
} ReturnCode;

@interface ResultsViewController ()

@property (weak, nonatomic) IBOutlet UIView *resultsSuperview;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UILabel *backToMenuLabel;

@property (weak, nonatomic) IBOutlet UIView *loadingSuperview;

@property (weak, nonatomic) IBOutlet UIView *loadingDot1;
@property (weak, nonatomic) IBOutlet UIView *loadingDot2;
@property (weak, nonatomic) IBOutlet UIView *loadingDot3;

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger currentDotState;
@property (nonatomic) BOOL isPasswordCorrect;
@property (nonatomic) BOOL isOperationFinalized;

@end


@implementation ResultsViewController

id thisClass;

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self checkPassword];
    if (self.isPasswordCorrect) {
        dispatch_queue_t callbackQueue = dispatch_queue_create("callbackQueue", NULL);
        dispatch_async(callbackQueue, ^{
            [self performOperation];
        });
    }
}

- (void)setup {
    thisClass = self;
    
    [self.loadingDot1 setHidden:YES];
    [self.loadingDot2 setHidden:YES];
    [self.loadingDot3 setHidden:YES];
    
    self.isOperationFinalized = NO;
    
    self.currentDotState = DotStateAllHidden;

    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(onTimerEvent:) userInfo:nil repeats:YES];
    
    // setup notification observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuButtonPressed:) name:@"menuButtonPressed" object:nil];
}

- (void)checkPassword {
    NSString *password = [[NSNumber numberWithInt:kOperationPassword] stringValue];
    self.isPasswordCorrect = [self.inputPassword isEqualToString:password];
    if (!self.isPasswordCorrect) {
        self.isOperationFinalized = YES;
    }
}

- (void)performOperation {
    int operationNumber = (int)self.selectedOperationNumber;

    NSString *operationString = [NSString stringWithFormat:@"MAKE%ld", ((ResultsViewController *)thisClass).selectedValueInCents];
    unsigned char *operationChar = (unsigned char *) [operationString UTF8String];
    unsigned int operationCharLength = (int)[operationString length];

    pm_callback callback;
    callback = callbackPagarMachine;
    pm_register_callback(callback);

    pm_exec(operationNumber, operationChar, operationCharLength);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.isPasswordCorrect) {
        self.resultsLabel.text = @"Senha incorreta\nOperação finalizada";
        [self.resultsLabel setNumberOfLines:0];
        [self.resultsLabel sizeToFit];
        [self.backToMenuLabel setHidden:NO];
        
        [self.view bringSubviewToFront:self.resultsSuperview];
    }
}


#pragma mark - Callback from Operation

void callbackPagarMachine (int operation, unsigned char *data, unsigned int length) {
    NSString *resultString = ((ResultsViewController *)thisClass).resultsLabel.text;
    
    switch (operation) {
        case ReturnCodeOperationFinalized:
            ((ResultsViewController *)thisClass).isOperationFinalized = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [((ResultsViewController *)thisClass).backToMenuLabel setHidden:NO];
            });
            break;
            
        case ReturnCodeOperationAuthorizationSuccessful:
            if (!((ResultsViewController *)thisClass).isOperationCombined) {
                resultString = [NSString stringWithFormat:@"Autorização feita com sucesso\nCódigo:%s", data];
            } else {
                resultString = @"Autorização feita com sucesso\n";
            }
            setResultLabel(resultString);
            break;
            
        case ReturnCodeOperationCaptureSuccessful:
            resultString = [NSString stringWithFormat:@"%@Captura feita com sucesso\nCódigo:%s", resultString, data];
            setResultLabel(resultString);
            break;
            
        case ReturnCodeOperationError:
            resultString = @"Houve um erro na operação";
            setResultLabel(resultString);
            break;
            
        case ReturnCodeOperationReversal:
            resultString = @"Estorno: a captura foi revertida";
            setResultLabel(resultString);
            break;
            
        case ReturnCodeOperationInvalidParameter:
            resultString = @"Parâmetro inválido enviado";
            setResultLabel(resultString);
            break;
            
        default:
            break;
    }
}

void setResultLabel (NSString *string) {
    dispatch_async(dispatch_get_main_queue(), ^{
        ((ResultsViewController *)thisClass).resultsLabel.text = string;
        [((ResultsViewController *)thisClass).resultsLabel setNumberOfLines:0];
        [((ResultsViewController *)thisClass).resultsLabel sizeToFit];
        
        [((ResultsViewController *)thisClass).view bringSubviewToFront:((ResultsViewController *)thisClass).resultsSuperview];
    });
}


#pragma mark - NSNotification Selector Methods

- (void)menuButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        if (self.isOperationFinalized) {
            [self performSegueWithIdentifier:@"unwindFromResultsToMenu" sender:self];
        }
    }
}


#pragma mark - Animation Methods

- (void)onTimerEvent:(NSTimer*)timer {

    switch (self.currentDotState) {
        case DotStateAllHidden:
            self.loadingDot1.hidden = !self.loadingDot1.hidden;
            self.currentDotState++;
            break;
        case DotStateFirstShown:
            self.loadingDot2.hidden = !self.loadingDot2.hidden;
            self.currentDotState++;
            break;
        case DotStateSecondShown:
            self.loadingDot3.hidden = !self.loadingDot3.hidden;
            self.currentDotState++;
            break;
        case DotStateThirdShown:
            self.loadingDot1.hidden = YES;
            self.loadingDot2.hidden = YES;
            self.loadingDot3.hidden = YES;
            self.currentDotState = 0;
            break;
        default:
            break;
    }
}

@end
