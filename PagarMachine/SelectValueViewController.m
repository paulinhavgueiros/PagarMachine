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

@interface SelectValueViewController ()

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end


@implementation SelectValueViewController

static const NSInteger maxValueLabelTextLength = 12;

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {

    // setup notification observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuButtonPressed:) name:@"menuButtonPressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(numberButtonPressed:) name:@"numberButtonPressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(correctButtonPressed:) name:@"correctButtonPressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmButtonPressed:) name:@"confirmButtonPressed" object:nil];
}


#pragma mark - NSNotification Selector Methods

- (void)menuButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)numberButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        if ([self.valueLabel.text length] < maxValueLabelTextLength) {
            if ([notification.object isKindOfClass:[UIButton class]]) {
                // fetch text number from selected button
                UIButton *selectedButton = (UIButton *)notification.object;
                NSString *number = selectedButton.titleLabel.text;
                
                self.valueLabel.text = [NSString maskedCurrencyString:self.valueLabel.text addingChar:number withMaxLength:maxValueLabelTextLength];
            }
        }
    }
}

- (void)correctButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        self.valueLabel.text = [NSString stringByRemovingLastCharWithString:self.valueLabel.text];
    }
}

- (void)confirmButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        if (![self.valueLabel.text isEqualToString:@"00,00"]) {
            [self performSegueWithIdentifier:@"modalToResults" sender:self];
        }
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"modalToResults"]) {
        ResultsViewController *resultsViewController = (ResultsViewController *)[segue destinationViewController];
        resultsViewController.selectedOperationNumber = self.selectedOperationNumber;
        resultsViewController.selectedValueInCents = [[NSString plainStringFromString:self.valueLabel.text] integerValue];
    }
}

@end
