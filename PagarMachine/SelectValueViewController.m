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

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UIView *valueLabelView;
@property (weak, nonatomic) IBOutlet UIView *passwordLabelView;

@property (strong, nonatomic) NSMutableString *password;
@property (nonatomic) BOOL valueLabelSelected;

@end


@implementation SelectValueViewController

static const NSInteger maxValueLabelTextLength = 12;
static const NSInteger maxPasswordLabelTextLength = 4;

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

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

- (void)upButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        if (!self.valueLabelSelected) {
            self.valueLabelSelected = YES;
            [self updateUI];
        }
    }
}

- (void)downButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        if (self.valueLabelSelected) {
            self.valueLabelSelected = NO;
            [self updateUI];
        }
    }
}

- (void)menuButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

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

- (void)correctButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        if (self.valueLabelSelected) {
            self.valueLabel.text = [NSString stringByRemovingLastCharWithString:self.valueLabel.text];
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
        resultsViewController.selectedOperationNumber = self.selectedOperationNumber;
        resultsViewController.selectedValueInCents = [[NSString plainStringFromString:self.valueLabel.text] integerValue];
        resultsViewController.isOperationCombined = self.isOperationCombined;
        resultsViewController.inputPassword = self.password;
    }
}


#pragma mark - UI Helper Methods

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
