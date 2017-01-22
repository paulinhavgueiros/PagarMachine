//
//  NSString+Utils.h
//  PagarMachine
//
//  Created by Paula Vasconcelos Gueiros on 20/1/17.
//  Copyright © 2016 paulinhavgueiros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Utils)

+ (NSString *)maskedCurrencyString:(NSString *)string addingChar:(NSString *)charater withMaxLength:(NSInteger)maxLength;
+ (NSString *)stringByRemovingLastCharWithString:(NSString *)string;

@end
