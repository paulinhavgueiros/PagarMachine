//
//  UIView+Utils.m
//  Solidario
//
//  Created by Paula Vasconcelos Gueiros on 15/4/16.
//  Copyright © 2016 paulinhavgueiros. All rights reserved.
//

#import "UIView+Utils.h"
#import <objc/runtime.h>

static void *borderDWidthKey = &borderDWidthKey;
static void *borderDLengthKey = &borderDLengthKey;

@implementation UIView(Utils)

#pragma mark - Shape

- (void)setCornerRadius:(CGFloat)cornerRadius {
    [self.layer setCornerRadius:cornerRadius];
    [self.layer setMasksToBounds:(cornerRadius > 0)];
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}


#pragma mark - Border

- (void)setBorderColor:(UIColor *)borderColor {
    [self.layer setBorderColor:borderColor.CGColor];
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    [self.layer setBorderWidth:borderWidth];
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}


#pragma mark - Dashed Border

- (void)setBorderDWidth:(CGFloat)borderDWidth {
    objc_setAssociatedObject(self, borderDWidthKey, @(borderDWidth), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)borderDWidth {
    return [objc_getAssociatedObject(self, borderDWidthKey) floatValue];
}

- (void)setBorderDLength:(CGFloat)borderDLength {
    objc_setAssociatedObject(self, borderDLengthKey, @(borderDLength), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)borderDLength {
    return [objc_getAssociatedObject(self, borderDLengthKey) floatValue];
}

- (void)addDashedBorderWithSize:(CGSize)size {
    if (self.borderColor == nil || !self.borderDWidth || !self.borderDLength || !self.cornerRadius) {
        NSLog(@"Error: [Add dashed border] not enough properties set");
        return;
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    CGSize frameSize = size;
    
    CGRect shapeRect = CGRectMake(0.0f, 0.0f, frameSize.width, frameSize.height);
    [shapeLayer setBounds:shapeRect];
    [shapeLayer setPosition:CGPointMake(frameSize.width/2,frameSize.height/2)];
    
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:self.borderColor.CGColor];
    [shapeLayer setLineWidth:self.borderDWidth];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithFloat:self.borderDLength],
      [NSNumber numberWithInt:self.borderDWidth],
      nil]];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:shapeRect cornerRadius:self.cornerRadius];
    [shapeLayer setPath:path.CGPath];
    
    [self.layer addSublayer:shapeLayer];
}


#pragma mark - Shadow

- (void)setShadowColor:(UIColor *)shadowColor {
    [self setClipsToBounds:NO];
    [self.layer setShadowColor:shadowColor.CGColor];
}

- (UIColor *)shadowColor {
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    [self.layer setShadowOpacity:shadowOpacity];
}

- (CGFloat)shadowOpacity {
    return self.layer.shadowOpacity;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    [self.layer setShadowRadius:shadowRadius];
}

- (CGFloat)shadowRadius {
    return self.layer.shadowRadius;
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    [self.layer setShadowOffset:shadowOffset];
}

- (CGSize)shadowOffset {
    return self.layer.shadowOffset;
}

@end
