//
//  UIColor+Utils.m
//  PagarMachine
//
//  Created by Paula Vasconcelos Gueiros on 20/1/17.
//  Copyright © 2016 paulinhavgueiros. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor(Utils)


#pragma mark - Default Colors

+ (UIColor *)defaultColor:(DefaultColor)type {
    UIView *viewColors = [[NSBundle mainBundle] loadNibNamed:@"Colors" owner:nil options:nil].firstObject;
    UILabel *tagLabel;
    
    for (UILabel *label in viewColors.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            if (type == [label.text integerValue]) {
                tagLabel = label;
            }
        }
    }
    
    return tagLabel.backgroundColor;
}

@end
