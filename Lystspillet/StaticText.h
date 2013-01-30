//
//  StaticText.h
//  Lystspillet
//
//  Created by Philip Nielsen on 20/01/13.
//  Copyright (c) 2013 Philip Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StaticText : NSManagedObject

@property (nonatomic, retain) NSString * textKey;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * textDescription;
@property (nonatomic, retain) NSString * imageName;

@end
