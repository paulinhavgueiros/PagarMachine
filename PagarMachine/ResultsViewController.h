//
//  ResultsViewController.h
//  PagarMachine
//
//  Created by Paula Vasconcelos Gueiros on 22/1/17.
//  Copyright © 2017 Paula Vasconcelos Gueiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsViewController : UIViewController

/*!
 * @brief the operation selected by the user
 */
@property (nonatomic) NSInteger selectedOperationNumber;

/*!
 * @brief the value defined by the user, in cents
 */
@property (nonatomic) NSInteger selectedValueInCents;

/*!
 * @brief whether the operation corresponds to the combined operation (authorize and capture) or not
 */
@property (nonatomic) BOOL isOperationCombined;

/*!
 * @brief the password entered by the user
 */
@property (strong, nonatomic) NSString *inputPassword;

@end
