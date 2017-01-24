//
//  SelectValueViewController.h
//  PagarMachine
//
//  Created by Paula Vasconcelos Gueiros on 22/1/17.
//  Copyright © 2017 Paula Vasconcelos Gueiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectValueViewController : UIViewController

/*!
 * @brief the operation selected by the user
 */
@property (nonatomic) NSInteger selectedOperationNumber;

/*!
 * @brief whether the operation corresponds to the combined operation (authorize and capture) or not
 */
@property (nonatomic) BOOL isOperationCombined;

@end
