//
//  NSObject+PerformBlockAfterDelay.m
//  Lystspillet
//
//  Created by Philip Nielsen on 14/01/13.
//  Copyright (c) 2013 Philip Nielsen. All rights reserved.
//

#import "NSObject+PerformBlockAfterDelay.h"

@implementation NSObject (PerformBlockAfterDelay)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    block = [block copy];
    [self performSelector:@selector(fireBlockAfterDelay:)
               withObject:block
               afterDelay:delay];
}

- (void)fireBlockAfterDelay:(void (^)(void))block {
    block();
}

@end
