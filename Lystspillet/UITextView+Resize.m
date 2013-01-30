//
//  UITextView+Resize.m
//  Lystspillet
//
//  Created by Philip Nielsen on 29/12/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import "UITextView+Resize.h"

@implementation UITextView (Resize)

#define kMaxFieldHeight 9999

- (BOOL)sizeFontToFitWithMinFontSize:(float)aMinFontSize andMaxFontSize:(float)aMaxFontSize
{
    float fudgeFactor = 16.0;
    float fontSize = aMaxFontSize;
    
    self.font = [self.font fontWithSize:fontSize];
    
    CGSize tallerSize = CGSizeMake(self.frame.size.width-fudgeFactor, kMaxFieldHeight);
    CGSize stringSize = [self.text sizeWithFont:self.font constrainedToSize:tallerSize lineBreakMode:NSLineBreakByWordWrapping];
    
    while (stringSize.height >= self.frame.size.height)
    {
        if (fontSize <= aMinFontSize) // it just won't fit
            return NO;
        
        fontSize -= 1.0;
        self.font = [self.font fontWithSize:fontSize];
        tallerSize = CGSizeMake(self.frame.size.width-fudgeFactor,kMaxFieldHeight);
        stringSize = [self.text sizeWithFont:self.font constrainedToSize:tallerSize lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return YES; 
}

- (void)sizeToFitForMaxHeight:(int)maxHeight
{
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width - 11, maxHeight - 11) lineBreakMode:NSLineBreakByWordWrapping];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height + 10)];
}

@end
