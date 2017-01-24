//
//  NSString+Utils.h
//  PagarMachine
//
//  Created by Paula Vasconcelos Gueiros on 20/1/17.
//  Copyright © 2016 paulinhavgueiros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Utils)

#pragma mark - Currency Mask

/*!
 * @discussion Method that adds a currency mask to a string when a new character is added
 * @param string The original string
 * @param character The character being inserted to the current string
 * @param maxLength The maximum permitted length to the resulting string
 * @return The resulting string, masked for currency
 */
+ (NSString *)maskedCurrencyString:(NSString *)string addingChar:(NSString *)character withMaxLength:(NSInteger)maxLength;

/*!
 * @discussion Method that adds a currency mask to a string when the last character is removed
 * @param string The original string
 * @return The resulting string, masked for currency
 */
+ (NSString *)maskedCurrencyStringByRemovingLastCharWithString:(NSString *)string;

/*!
 * @discussion Method that removes the currency mask from a string
 * @param string The original, masked string
 * @return The plain string
 */
+ (NSString *)plainStringFromString:(NSString *)string;

@end
