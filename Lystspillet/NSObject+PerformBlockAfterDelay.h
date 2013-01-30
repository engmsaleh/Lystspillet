//
//  NSObject+PerformBlockAfterDelay.h
//  Lystspillet
//
//  Created by Philip Nielsen on 14/01/13.
//  Copyright (c) 2013 Philip Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PerformBlockAfterDelay)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

@end
