//
//  Card.h
//  Lystspillet
//
//  Created by Philip Nielsen on 30/12/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category;

@interface Card : NSManagedObject

@property (nonatomic, retain) NSString * frontText;
@property (nonatomic, retain) NSString * frontImageName;
@property (nonatomic, retain) NSString * cardType;
@property (nonatomic, retain) NSString * detailedQuestion;
@property (nonatomic, retain) NSString * quizQuestion;
@property (nonatomic, retain) NSString * quizAnswer;
@property (nonatomic, retain) NSString * didYouKnowThat;
@property (nonatomic, retain) NSString * moreInfo;
@property (nonatomic, retain) NSString * cardReference;
@property (nonatomic, retain) Category *category;

@end
