//
//  ResultsViewController.m
//  PagarMachine
//
//  Created by Paula Vasconcelos Gueiros on 22/1/17.
//  Copyright © 2017 Paula Vasconcelos Gueiros. All rights reserved.
//

#import "ResultsViewController.h"
#import "desafio.h"

typedef enum {
    DotStateAllHidden = 0,
    DotStateFirstShown = 1,
    DotStateSecondShown = 2,
    DotStateThirdShown = 3
} DotState;

@interface ResultsViewController ()

@property (weak, nonatomic) IBOutlet UIView *loadingDot1;
@property (weak, nonatomic) IBOutlet UIView *loadingDot2;
@property (weak, nonatomic) IBOutlet UIView *loadingDot3;

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger currentDotState;
@property (nonatomic) BOOL operationFinalized;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHiddenConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableShownConstraint;

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self performOperation];
}

- (void)setup {
    [self.loadingDot1 setHidden:YES];
    [self.loadingDot2 setHidden:YES];
    [self.loadingDot3 setHidden:YES];
    
    self.operationFinalized = NO;
    
    self.currentDotState = DotStateAllHidden;

    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(onTimerEvent:) userInfo:nil repeats:YES];
    
    // setup notification observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuButtonPressed:) name:@"menuButtonPressed" object:nil];
}

- (void)performOperation {
//    int operation = 3;
//    unsigned char myString [15] = "MAKE10000000000";
//    unsigned char* tmpBuffer = &myString[0];
//    unsigned int length = 15;
//
//    pm_callback callback;
//    callback = callbackPagarMachine;
//    pm_register_callback(callback);
//
//    NSLog(@"Operação 3 (capturar) sendo executada para R$100.000,00");
//    pm_exec(operation, tmpBuffer, length);
}


#pragma mark - Callback from Operation

void callbackPagarMachine (int operation, unsigned char *data, unsigned int length) {
    
    NSLog(@"Código de retorno: %d", operation);
    if (data) {
        NSLog(@"\tRetorno: %s", data);
    }
    
    //se inicializacao
    //self.tableHiddenConstraint.priority = 500;
    //self.tableShownConstraint.priority = 900;
}


#pragma mark - NSNotification Selector Methods

- (void)menuButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        if (self.operationFinalized) {
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


#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}

@end
