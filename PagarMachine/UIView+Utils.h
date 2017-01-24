//
//  UIView+Utils.h
//  PagarMachine
//
//  Created by Paula Vasconcelos Gueiros on 20/1/17.
//  Copyright © 2016 paulinhavgueiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(Utils)

/*!
 * @brief the size of the rounded border
 */
@property (nonatomic) IBInspectable CGFloat cornerRadius;

/*!
 * @brief the view's border color
 */
@property (nonatomic) IBInspectable UIColor *borderColor;

/*!
 * @brief the view's border width
 */
@property (nonatomic) IBInspectable CGFloat borderWidth;

/*!
 * @brief the dashed width when view has a dashed border
 */
@property (nonatomic) IBInspectable CGFloat borderDWidth;

/*!
 * @brief the dashed length when view has a dashed border
 */
@property (nonatomic) IBInspectable CGFloat borderDLength;

/*!
 * @brief the view's shadow color
 */
@property (nonatomic) IBInspectable UIColor *shadowColor;

/*!
 * @brief the view's shadow opacity
 */
@property (nonatomic) IBInspectable CGFloat shadowOpacity;

/*!
 * @brief the view's shadow radius
 */
@property (nonatomic) IBInspectable CGFloat shadowRadius;

/*!
 * @brief the view's shadow offset
 */
@property (nonatomic) IBInspectable CGSize shadowOffset;

#pragma mark - Dashed Border

/*!
 * @discussion Method that adds a dashed border to a view
 * @param size The size of the dash rectangles
 */
- (void)addDashedBorderWithSize:(CGSize)size;

@end










