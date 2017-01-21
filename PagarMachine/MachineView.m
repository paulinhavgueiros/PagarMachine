//
//  MachineView.m
//  PagarMachine
//
//  Created by Paula Vasconcelos Gueiros on 21/1/17.
//  Copyright © 2017 Paula Vasconcelos Gueiros. All rights reserved.
//

#import "MachineView.h"

@implementation MachineView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])){
        UIView *machineView = [[[NSBundle mainBundle] loadNibNamed:@"MachineView"
                                                            owner:self
                                                          options:nil] objectAtIndex:0];
        machineView.frame = self.bounds;
        [self addSubview:machineView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)aRect {
    self = [super initWithFrame:aRect];
    
    if (self) {
        UIView *machineView = [[[NSBundle mainBundle] loadNibNamed:@"MachineView"
                                                             owner:self
                                                           options:nil] objectAtIndex:0];
        machineView.frame = self.bounds;
        [self addSubview:machineView];
        
    }
    return self;
}

@end
