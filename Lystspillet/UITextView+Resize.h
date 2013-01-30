//
//  UITextView+Resize.h
//  Lystspillet
//
//  Created by Philip Nielsen on 29/12/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Resize)

- (BOOL)sizeFontToFitWithMinFontSize:(float)aMinFontSize andMaxFontSize:(float)aMaxFontSize;

- (void)sizeToFitForMaxHeight:(int)maxHeight;

@end
