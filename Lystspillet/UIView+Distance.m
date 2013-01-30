//
//  UIView+Distance.m
//  Lystspillet
//
//  Created by Philip Nielsen on 30/12/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import "UIView+Distance.h"

@implementation UIView (Distance)

- (void)allignToAboveView:(UIView *)view forDistance:(int)distance
{
    int aboveY = view.frame.origin.y + view.frame.size.height;
    [self setFrame:CGRectMake(self.frame.origin.x, aboveY + distance, self.frame.size.width, self.frame.size.height)];
}

- (void)setHeight:(float)newHeight
{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, newHeight)];
}

+ (void)printViewHierarchy:(UIView *)viewNode depth:(NSUInteger)depth
{
    for (UIView *v in viewNode.subviews)
    {
        NSLog(@"%@%@", [@"" stringByPaddingToLength:depth withString:@"|-" startingAtIndex:0], [v description]);
        if ([v.subviews count])
            [self printViewHierarchy:v depth:(depth + 2)]; // + 2 to make the output look correct with the stringPadding
    }
}

@end
