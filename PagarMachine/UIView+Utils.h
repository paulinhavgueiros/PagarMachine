//
//  UIView+Utils.h
//  Solidario
//
//  Created by Paula Vasconcelos Gueiros on 15/4/16.
//  Copyright © 2016 paulinhavgueiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(Utils)

@property (nonatomic) IBInspectable CGFloat cornerRadius;

@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;

@property (nonatomic) IBInspectable CGFloat borderDWidth;
@property (nonatomic) IBInspectable CGFloat borderDLength;

@property (nonatomic) IBInspectable UIColor *shadowColor;
@property (nonatomic) IBInspectable CGFloat shadowOpacity;
@property (nonatomic) IBInspectable CGFloat shadowRadius;
@property (nonatomic) IBInspectable CGSize shadowOffset;

- (void)addDashedBorderWithSize:(CGSize)size;

@end
