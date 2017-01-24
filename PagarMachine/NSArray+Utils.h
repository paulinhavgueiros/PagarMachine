//
//  NSArray+Utils.h
//  PagarMachine
//
//  Created by Paula Vasconcelos Gueiros on 20/1/17.
//  Copyright © 2016 paulinhavgueiros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(Utils)

#pragma mark - Property List

/*!
 * @discussion Method that loads content from a property list into an object
 * @param name The name of the .plist file
 * @return An array with the content of the property list
 */
+ (NSArray *)loadPlistWithName:(NSString*)name;

@end
