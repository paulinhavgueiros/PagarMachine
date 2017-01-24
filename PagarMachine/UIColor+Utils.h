//
//  UIColor+Utils.h
//  PagarMachine
//
//  Created by Paula Vasconcelos Gueiros on 20/1/17.
//  Copyright © 2016 paulinhavgueiros. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 * @typedef DefaultColor
 * @brief A list of colors, each of which has a number that corresponds to a tag of a view in Colors.nib
 */
typedef enum {
    /// Background color for card machine UI screen
    DefaultColorMainScreenBackground = 101,
    
    /// Background color for selected menu option in the menu screen
    DefaultColorMenuItemSelectedBackground = 102,
    
    /// Background color for deselected menu option in the menu screen
    DefaultColorMenuItemDeselectedBackground = 103,
    
    /// Background color for selected field in the value selection screen
    DefaultColorLabelSelectedBackground = 104,
    
    /// Background color for deselected field in the value selection screen
    DefaultColorLabelDeselectedBackground = 105
} DefaultColor;

@interface UIColor(Utils)


#pragma mark - Default Colors

/*!
 * @discussion Method that retrieves the color for a selected default color identifier
 * @param type The default color identifier
 * return A UIColor object for the retrieved color
 */
+ (UIColor *)defaultColor:(DefaultColor)type;


@end
