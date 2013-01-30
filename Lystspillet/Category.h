//
//  Category.h
//  Lystspillet
//
//  Created by Philip Nielsen on 26/01/13.
//  Copyright (c) 2013 Philip Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Card;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSString * categoryColor;
@property (nonatomic, retain) NSString * frameImageName;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * littleDescription;
@property (nonatomic, retain) NSString * longDescription;
@property (nonatomic, retain) NSNumber * sorting;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *cards;
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addCardsObject:(Card *)value;
- (void)removeCardsObject:(Card *)value;
- (void)addCards:(NSSet *)values;
- (void)removeCards:(NSSet *)values;

@end
