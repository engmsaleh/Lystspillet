//
//  NSString+Contain.h
//  Lystspillet
//
//  Created by Philip Nielsen on 09/01/13.
//  Copyright (c) 2013 Philip Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Contain)

- (BOOL)containsString:(NSString *)string;
- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions) options;

@end
