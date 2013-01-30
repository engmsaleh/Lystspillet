//
//  NSString+StringThatFits.h
//  Lystspillet
//
//  Created by Philip Nielsen on 21/01/13.
//  Copyright (c) 2013 Philip Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringThatFits)

- (NSString *)stringByDeletingWordsFromStringToFit:(CGRect)rect
                                         withInset:(CGFloat)inset
                                         usingFont:(UIFont *)font;

@end
