//
//  ResultsViewController.m
//  PagarMachine
//
//  Created by Paula Vasconcelos Gueiros on 22/1/17.
//  Copyright © 2017 Paula Vasconcelos Gueiros. All rights reserved.
//

#import "ResultsViewController.h"

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

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    [self.loadingDot1 setHidden:YES];
    [self.loadingDot2 setHidden:YES];
    [self.loadingDot3 setHidden:YES];
    
    self.currentDotState = DotStateAllHidden;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(onTimerEvent:) userInfo:nil repeats:YES];
}


#pragma mark - NSNotification Selector Methods

- (void)menuButtonPressed:(NSNotification *)notification {
    if ([self isViewLoaded] && self.view.window) {
        // dismiss until first view controller
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
