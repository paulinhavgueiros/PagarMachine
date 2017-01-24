//
//  SelectValueViewController.m
//  PagarMachine
//
//  Created by Paula Vasconcelos Gueiros on 22/1/17.
//  Copyright © 2017 Paula Vasconcelos Gueiros. All rights reserved.
//

#import "SelectValueViewController.h"
#import "ResultsViewController.h"
#import "NSString+Utils.h"
#import "UIColor+Utils.h"

@interface SelectValueViewController ()

/*!
 * @brief the label showing selected amount for the operation to be performed on
 */
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

/*!
 * @brief the label showing the password used to confirm the operation
 */
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

/*!
 * @brief the view containing the value label
 */
@property (weak, nonatomic) IBOutlet UIView *valueLabelView;

/*!
 * @brief the view containing the password label
 */
@property (weak, nonatomic) IBOutlet UIView *passwordLabelView;

/*!
 * @brief the password entered by the user
 */
@property (strong, nonatomic) NSMutableString *password;

/*!
 * @brief whether or not the value label is selected
 */
@property (nonatomic) BOOL valueLabelSelected;

@end


@implementation SelectValueViewController

/*!
 * @brief the maximum size of the text in the value label
 */
static const NSInteger maxValueLabelTextLength = 12;

/*!
 * @brief the maximum size of the text in the password label
 */
static const NSInteger maxPasswordLabelTextLength = 4;

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

/*!
 * @discussion Method that sets up the user interface and performs any necessary view initialization
 */
- (void)setup {
    /// set value label selected for start state
    self.valueLabelSelected = YES;
    
    /// initialize password with empty string
    self.password = [NSMutableString stringWithFormat:@""];

    /// setup notification observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upButtonPressed:) name:@"upButtonPressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downButtonPressed:) name:@"downButtonPressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuButtonPressed:) name:@"menuButtonPressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(numberButtonPressed:) name:@"numberButtonPressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(correctButtonPressed:) name:@"correctButtonPressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmButtonPressed:) name:@"confirmButtonPressed" object:nil];
}


#pragma mark - NSNotification Selector Methods

/*!
 * @discussion Method executed when the machine's up button in pressed.  If possible, changes the selected input field to the option above the currect selected one.
 */
- (void)upButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        if (!self.valueLabelSelected) {
            self.valueLabelSelected = YES;
            [self updateUI];
        }
    }
}

/*!
 * @discussion Method executed when the machine's down button in pressed.  If possible, changes the selected input field to the option below the currect selected one.
 */
- (void)downButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        if (self.valueLabelSelected) {
            self.valueLabelSelected = NO;
            [self updateUI];
        }
    }
}

/*!
 * @discussion Method executed when the machine's mwnu button in pressed.  Returns the machine's UI to the menu screen.
 */
- (void)menuButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

/*!
 * @discussion Method executed when the any of the machine's number buttons are pressed.  If possible, adds the selected number to the current selected input field.
 */
- (void)numberButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        if ([notification.object isKindOfClass:[UIButton class]]) {
            /// fetch text number from selected button
            UIButton *selectedButton = (UIButton *)notification.object;
            NSString *number = selectedButton.titleLabel.text;
            
            if (self.valueLabelSelected) {
                if ([self.valueLabel.text length] < maxValueLabelTextLength) {
                    self.valueLabel.text = [NSString maskedCurrencyString:self.valueLabel.text addingChar:number withMaxLength:maxValueLabelTextLength];
                }
            } else {
                if ([self.passwordLabel.text length] < maxPasswordLabelTextLength) {
                    self.passwordLabel.text = [NSString stringWithFormat:@"%@*", self.passwordLabel.text];
                    self.password = [NSMutableString stringWithFormat:@"%@%@", self.password, number];
                }
            }
        }
    }
}

/*!
 * @discussion Method executed when the machine's correct button is pressed.  If possible, removes the last character in the current selected input field.
 */
- (void)correctButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        if (self.valueLabelSelected) {
            self.valueLabel.text = [NSString maskedCurrencyStringByRemovingLastCharWithString:self.valueLabel.text];
        } else {
            if ([self.passwordLabel.text length] > 0) {
                NSMutableString *passwordString = [self.passwordLabel.text mutableCopy];
                [passwordString deleteCharactersInRange:NSMakeRange([passwordString length] - 1, 1)];
                self.passwordLabel.text = passwordString;
                [self.password deleteCharactersInRange:NSMakeRange([self.password length] - 1, 1)];
            }
        }
    }
}

/*!
 * @discussion Method executed when the machine's confirm button is pressed.  If possible, changes the machine's UI to the next screen.
 */
- (void)confirmButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        if (![self.valueLabel.text isEqualToString:@"00,00"] && [self.passwordLabel.text length] > 0) {
            [self performSegueWithIdentifier:@"pushToResults" sender:self];
        }
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushToResults"]) {
        ResultsViewController *resultsViewController = (ResultsViewController *)[segue destinationViewController];
        
        /// setup new view controller with the selected user options
        
        resultsViewController.selectedOperationNumber = self.selectedOperationNumber;
        resultsViewController.selectedValueInCents = [[NSString plainStringFromString:self.valueLabel.text] integerValue];
        resultsViewController.isOperationCombined = self.isOperationCombined;
        resultsViewController.inputPassword = self.password;
    }
}


#pragma mark - UI Helper Methods

/*!
 * @discussion Method that updates the UI when the user changes the current selected input field using one of the machine arrows
 */
- (void)updateUI {
    if (self.valueLabelSelected) {
        [self.valueLabelView setBackgroundColor:[UIColor defaultColor:DefaultColorLabelSelectedBackground]];
        [self.passwordLabelView setBackgroundColor:[UIColor defaultColor:DefaultColorLabelDeselectedBackground]];
    } else {
        [self.valueLabelView setBackgroundColor:[UIColor defaultColor:DefaultColorLabelDeselectedBackground]];
        [self.passwordLabelView setBackgroundColor:[UIColor defaultColor:DefaultColorLabelSelectedBackground]];
    }
}

@end
