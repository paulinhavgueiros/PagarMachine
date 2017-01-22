//
//  NSArray+Utils.m
//  PagarMachine
//
//  Created by Paula Vasconcelos Gueiros on 20/1/17.
//  Copyright © 2016 paulinhavgueiros. All rights reserved.
//

#import "NSArray+Utils.h"

@implementation NSArray(Utils)

+ (NSArray *)loadPlistWithName:(NSString *)name {
    NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:@"plist"];
    return [NSArray arrayWithContentsOfURL:url];
}

@end
