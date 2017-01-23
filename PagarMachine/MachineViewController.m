//
//  ViewController.m
//  PagarMachine
//
//  Created by Paula Vasconcelos Gueiros on 18/1/17.
//  Copyright © 2017 Paula Vasconcelos Gueiros. All rights reserved.
//

#import "MachineViewController.h"
#import "desafio.h"

@interface MachineViewController ()

/*!
 * @discussion Method that posts NSNotification to defaultCenter letting other view controllers know that the up arrow button was clicked
 * @param sender The button that was clicked (up button)
 */
- (IBAction)upButtonPressed:(id)sender;

/*!
 * @discussion Method that posts NSNotification to defaultCenter letting other view controllers know that the down arrow button was clicked
 * @param sender The button that was clicked (down button)
 */
- (IBAction)downButtonPressed:(id)sender;

/*!
 * @discussion Method that posts NSNotification to defaultCenter letting other view controllers know that the menu button was clicked
 * @param sender The button that was clicked (menu button)
 */
- (IBAction)menuButtonPressed:(id)sender;

/*!
 * @discussion Method that posts NSNotification to defaultCenter letting other view controllers know that one of the number buttons was clicked
 * @param sender Whichever button was clicked, among the number buttons
 */
- (IBAction)numberButtonPressed:(id)sender;

/*!
 * @discussion Method that posts NSNotification to defaultCenter letting other view controllers know that the correct value button was clicked
 * @param sender The button that was clicked (correct value button)
 */
- (IBAction)correctButtonPressed:(id)sender;

/*!
 * @discussion Method that posts NSNotification to defaultCenter letting other view controllers know that the confirm button was clicked
 * @param sender The button that was clicked (confirm button)
 */
- (IBAction)confirmButtonPressed:(id)sender;

@end


@implementation MachineViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - UIButton Actions

- (IBAction)upButtonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"upButtonPressed" object:nil];
}

- (IBAction)downButtonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"downButtonPressed" object:nil];
}

- (IBAction)menuButtonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuButtonPressed" object:nil];
}

- (IBAction)numberButtonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"numberButtonPressed" object:sender];
}

- (IBAction)correctButtonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"correctButtonPressed" object:nil];
}

- (IBAction)confirmButtonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"confirmButtonPressed" object:nil];
}

@end
