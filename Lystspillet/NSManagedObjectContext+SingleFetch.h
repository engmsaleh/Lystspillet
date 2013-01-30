//
//  NSManagedObjectContext+SingleFetch.h
//  Lystspillet
//
//  Created by Philip Nielsen on 20/01/13.
//  Copyright (c) 2013 Philip Nielsen. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (SingleFetch)
- (NSArray *)fetchObjectsForEntityName:(NSString *)newEntityName
                       withPredicate:(id)stringOrPredicate, ...;
@end
