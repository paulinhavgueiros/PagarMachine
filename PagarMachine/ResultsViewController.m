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

/*!
 * @typedef DotState
 * @brief A list of states for the white dots used for animation while waiting for libdesafio response
 */
typedef enum {
    /// Initial state: all dots are hidden
    DotStateAllHidden = 0,
    
    /// Only first dot is shown
    DotStateFirstShown = 1,
    
    /// First and second dots are shown
    DotStateSecondShown = 2,
    
    /// All dots are shown
    DotStateThirdShown = 3
} DotState;

/*!
 * @typedef ReturnCode
 * @brief A list of return codes for user operations
 */
typedef enum {
    /// Operation was initialized
    ReturnCodeOperationInitialized = 0,
    
    /// Operation was finalized
    ReturnCodeOperationFinalized = 1,
    
    /// Authorization transaction was successful
    ReturnCodeOperationAuthorizationSuccessful = 2,
    
    /// Capture transaction was successful
    ReturnCodeOperationCaptureSuccessful = 3,
    
    /// Error in operation
    ReturnCodeOperationError = 5,
    
    /// Capture was reversed
    ReturnCodeOperationReversal = 6,
    
    /// Invalid parameter sent
    ReturnCodeOperationInvalidParameter = 7
} ReturnCode;

@interface ResultsViewController ()

/*!
 * @brief the view containing label with the operation result
 */
@property (weak, nonatomic) IBOutlet UIView *resultsSuperview;

/*!
 * @brief the label that shows the operation result
 */
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;

/*!
 * @brief the label showing a helper message to return to the menu
 */
@property (weak, nonatomic) IBOutlet UILabel *backToMenuLabel;

/*!
 * @brief the view containing label and animation for user feedback while waiting for response from libdesafio
 */
@property (weak, nonatomic) IBOutlet UIView *loadingSuperview;

/// views used for animation

@property (weak, nonatomic) IBOutlet UIView *loadingDot1;
@property (weak, nonatomic) IBOutlet UIView *loadingDot2;
@property (weak, nonatomic) IBOutlet UIView *loadingDot3;

/*!
 * @brief the timer object used for animation
 */
@property (strong, nonatomic) NSTimer *timer;

/*!
 * @brief the current animation dots state
 */
@property (nonatomic) NSInteger currentDotState;

/*!
 * @brief whether or not the password entered by user is correct
 */
@property (nonatomic) BOOL isPasswordCorrect;

/*!
 * @brief whether or not the operation has been finalized
 */
@property (nonatomic) BOOL isOperationFinalized;

@end


@implementation ResultsViewController

/*!
 * @brief pointer to this class
 */
id thisClass;

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
    /// check for password correctness
    [self checkPassword];
    if (self.isPasswordCorrect) {
        /// execute operation on secondary thread to prevent user interface from being blocked
        dispatch_queue_t callbackQueue = dispatch_queue_create("callbackQueue", NULL);
        dispatch_async(callbackQueue, ^{
            [self performOperation];
        });
    }
}

/*!
 * @discussion Method that sets up the user interface and performs any necessary view initialization
 */
- (void)setup {
    /// set pointer to current class for use in c methods
    thisClass = self;
    
    /// initialize bool object that recognizes operation finalization
    self.isOperationFinalized = NO;
    
    /// initiate animation for user feedback while loading
    [self.loadingDot1 setHidden:YES];
    [self.loadingDot2 setHidden:YES];
    [self.loadingDot3 setHidden:YES];
    self.currentDotState = DotStateAllHidden;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(onTimerEvent:) userInfo:nil repeats:YES];
    
    /// setup notification observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuButtonPressed:) name:@"menuButtonPressed" object:nil];
}

/*!
 * @discussion Method that checks if password entered by user is correct, according to defined macro kOperationPassword
 */
- (void)checkPassword {
    NSString *password = [[NSNumber numberWithInt:kOperationPassword] stringValue];
    self.isPasswordCorrect = [self.inputPassword isEqualToString:password];
    if (!self.isPasswordCorrect) {
        self.isOperationFinalized = YES;
    }
}

/*!
 * @discussion Performs user defined operation in libdesafio
 */
- (void)performOperation {
    /// sets up user options
    
    int operationNumber = (int)self.selectedOperationNumber;
    NSString *operationString = [NSString stringWithFormat:@"MAKE%ld", (long)((ResultsViewController *)thisClass).selectedValueInCents];
    unsigned char *operationChar = (unsigned char *) [operationString UTF8String];
    unsigned int operationCharLength = (int)[operationString length];

    /// registers callback
    
    pm_callback callback;
    callback = callbackPagarMachine;
    pm_register_callback(callback);

    /// executes operation
    pm_exec(operationNumber, operationChar, operationCharLength);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.isPasswordCorrect) {
        /// shows error message if passowrd is incorrect
        
        self.resultsLabel.text = @"Senha incorreta\nOperação finalizada";
        [self.resultsLabel setNumberOfLines:0];
        [self.resultsLabel sizeToFit];
        [self.backToMenuLabel setHidden:NO];
        
        [self.view bringSubviewToFront:self.resultsSuperview];
    }
}


#pragma mark - Callback from Operation

/*!
 * @discussion Function executed in response from libdesafio
 * @param operation The return code
 * @param data Aditional information on the return code
 * @param length The length of the data object
 */
void callbackPagarMachine (int operation, unsigned char *data, unsigned int length) {
    NSString *resultString = ((ResultsViewController *)thisClass).resultsLabel.text;
    
    switch (operation) {
        case ReturnCodeOperationFinalized:
            ((ResultsViewController *)thisClass).isOperationFinalized = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                /// on main queue (UI), show back to menu label
                [((ResultsViewController *)thisClass).backToMenuLabel setHidden:NO];
            });
            break;
            
        case ReturnCodeOperationAuthorizationSuccessful:
            if (!((ResultsViewController *)thisClass).isOperationCombined) {
                resultString = [NSString stringWithFormat:@"Autorização feita com sucesso\nCódigo: %s", data];
            } else {
                resultString = @"Autorização feita com sucesso\n";
            }
            setResultLabel(resultString);
            break;
            
        case ReturnCodeOperationCaptureSuccessful:
            resultString = [NSString stringWithFormat:@"%@Captura feita com sucesso\nCódigo: %s", resultString, data];
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

/*!
 * @discussion Sets result label content according to operation response
 * @param string The text to set to label
 */
void setResultLabel (NSString *string) {
    dispatch_async(dispatch_get_main_queue(), ^{
        ((ResultsViewController *)thisClass).resultsLabel.text = string;
        [((ResultsViewController *)thisClass).resultsLabel setNumberOfLines:0];
        [((ResultsViewController *)thisClass).resultsLabel sizeToFit];
        
        [((ResultsViewController *)thisClass).view bringSubviewToFront:((ResultsViewController *)thisClass).resultsSuperview];
    });
}


#pragma mark - NSNotification Selector Methods

/*!
 * @discussion Method executed when the machine's mwnu button in pressed.  Returns the machine's UI to the menu screen.
 */
- (void)menuButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        if (self.isOperationFinalized) {
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }
}


#pragma mark - Animation Methods

/*!
 * @discussion Method executed every 1 second.  Used to animate dots while waiting for operation response.
 * @param timer The timer object
 */
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
