//
//  ResultsViewController.h
//  PagarMachine
//
//  Created by Paula Vasconcelos Gueiros on 22/1/17.
//  Copyright © 2017 Paula Vasconcelos Gueiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsViewController : UIViewController

@property (nonatomic) NSInteger selectedOperationNumber;
@property (nonatomic) NSInteger selectedValueInCents;
@property (nonatomic) BOOL isOperationCombined;
@property (strong, nonatomic) NSString *inputPassword;

@end
