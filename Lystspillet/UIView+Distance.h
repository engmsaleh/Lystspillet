//
//  UIView+Distance.h
//  Lystspillet
//
//  Created by Philip Nielsen on 30/12/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Distance)

- (void)allignToAboveView:(UIView *)view forDistance:(int)distance;

- (void)setHeight:(float)newHeight;

+ (void)printViewHierarchy:(UIView *)viewNode depth:(NSUInteger)depth;

@end
