//
//  UIColor+Utils.h
//  Solidario
//
//  Created by Marcelo Sampaio on 7/8/15.
//  Copyright (c) 2015 Marcelo Sampaio. All rights reserved.
//

#import <UIKit/UIKit.h>

//A Default color has a number that corresponds to a tag of a view in Colors.nib
typedef enum DefaultColor {
    DefaultColorMain = 101,
    DefaultColorNavigationBar = 102,
    DefaultColorMainBackground = 103,
    DefaultColorMenuDarkBackground = 104,
    DefaultColorMenuLightBackground = 105,
    DefaultColorMainText = 106,
    DefaultColorLoginTableSeparator = 107,
    DefaultColorMenuText = 108,
    DefaultColorSearchResultGoalText = 109,
    DefaultColorSearchResultGoalValue = 110,
    DefaultColorAboutDescriptionBackground = 111,
    DefaultColorTextDarkGray = 112,
    DefaultColorTextLightGray = 113,
    DefaultColorIntroSelectedPageDot = 114,
    DefaultColorBannerShadow = 115,
    DefaultColorBannerShadowTop = 116
} DefaultColor;

@interface UIColor(Utils)


#pragma mark - Default Colors

+ (UIColor *)defaultColor:(DefaultColor)type;


@end
