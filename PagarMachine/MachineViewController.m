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


@end


@implementation MachineViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
