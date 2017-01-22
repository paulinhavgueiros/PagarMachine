//
//  UIColor+Utils.h
//  PagarMachine
//
//  Created by Paula Vasconcelos Gueiros on 20/1/17.
//  Copyright © 2016 paulinhavgueiros. All rights reserved.
//

#import <UIKit/UIKit.h>

//A Default color has a number that corresponds to a tag of a view in Colors.nib
typedef enum DefaultColor {
    DefaultColorMainScreenBackground = 101,
    DefaultColorMenuItemSelectedBackground = 102,
    DefaultColorMenuItemDeselectedBackground = 103
} DefaultColor;

@interface UIColor(Utils)


#pragma mark - Default Colors

+ (UIColor *)defaultColor:(DefaultColor)type;


@end
