//
//  NSString+Utils.m
//  PagarMachine
//
//  Created by Paula Vasconcelos Gueiros on 20/1/17.
//  Copyright © 2016 paulinhavgueiros. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString(Utils)

#pragma mark - Currency Mask

+ (NSString *)maskedCurrencyString:(NSString *)string addingChar:(NSString *)character withMaxLength:(NSInteger)maxLength {

    NSMutableString *newString = [NSMutableString stringWithString:string];
    
    if ([string length] == 5) {
        if ([newString characterAtIndex:0] == '0') {
            [newString replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
            newString = [NSMutableString stringWithString:[newString stringByReplacingOccurrencesOfString:@"," withString:@""]];
            [newString insertString:@"," atIndex:2];
        } else {
            newString = [NSMutableString stringWithString:[newString stringByReplacingOccurrencesOfString:@"," withString:@""]];
            [newString insertString:@"," atIndex:[newString length]-1];
        }
        
    } else if ([string length] > 5) {
        newString = [NSMutableString stringWithString:[newString stringByReplacingOccurrencesOfString:@"," withString:@""]];
        [newString insertString:@"," atIndex:[newString length]-1];
        
        newString = [NSMutableString stringWithString:[newString stringByReplacingOccurrencesOfString:@"." withString:@""]];
        int i = (int)[newString length] - 5;
        
        while (i > 0) {
            [newString insertString:@"." atIndex:i];
            i -= 3;
        }
    }
    
    return [newString stringByAppendingString:character];
}

+ (NSString *)maskedCurrencyStringByRemovingLastCharWithString:(NSString *)string {
    
    NSMutableString *newString = [NSMutableString stringWithString:string];
    
    if ([newString length] >= 6) {
        newString = [NSMutableString stringWithString:[newString stringByReplacingOccurrencesOfString:@"," withString:@""]];
        newString = [NSMutableString stringWithString:[newString stringByReplacingOccurrencesOfString:@"." withString:@""]];
        
        [newString insertString:@"," atIndex:[newString length] - 3];
        
        int i = (int)[newString length] - 7;
        while (i > 0) {
            [newString insertString:@"." atIndex:i];
            i -= 3;
        }
    } else {
        newString = [NSMutableString stringWithString:[newString stringByReplacingOccurrencesOfString:@"," withString:@""]];
        [newString insertString:@"0" atIndex:0];
        [newString insertString:@"," atIndex:2];
    }
    
    [newString deleteCharactersInRange:NSMakeRange([newString length] - 1, 1)];
    return newString;
}

+ (NSString *)plainStringFromString:(NSString *)string {
    NSMutableString *plain = [NSMutableString stringWithString:string];
    plain = [NSMutableString stringWithString:[plain stringByReplacingOccurrencesOfString:@"," withString:@""]];
    plain = [NSMutableString stringWithString:[plain stringByReplacingOccurrencesOfString:@"." withString:@""]];
    return plain;
}

@end
