//
//  UIColor+Utils.m
//  Solidario
//
//  Created by Marcelo Sampaio on 7/8/15.
//  Copyright (c) 2015 Marcelo Sampaio. All rights reserved.
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
