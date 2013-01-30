//
//  UIColor+Hex.h
//  Lystspillet
//
//  Created by Philip Nielsen on 30/12/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHex:(UInt32)col;
+ (UIColor *)colorWithHexString:(NSString *)str;

@end
