//
//  CALayer+Utils.m
//  Solidario
//
//  Created by Paula Vasconcelos Gueiros on 18/3/16.
//  Copyright © 2016 paulinhavgueiros. All rights reserved.
//

#import "CALayer+Utils.h"

@implementation CALayer(Utils)

- (void)setBorderUIColor:(UIColor*)color {
    self.borderColor = color.CGColor;
}

- (UIColor*)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

@end