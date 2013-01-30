//
//  NSString+Contain.m
//  Lystspillet
//
//  Created by Philip Nielsen on 09/01/13.
//  Copyright (c) 2013 Philip Nielsen. All rights reserved.
//

#import "NSString+Contain.h"

@implementation NSString (Contain)

- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (BOOL)containsString:(NSString *)string {
    return [self containsString:string options:0];
}

@end
