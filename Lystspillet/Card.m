//
//  Card.m
//  Lystspillet
//
//  Created by Philip Nielsen on 30/12/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import "Card.h"
#import "Category.h"


@implementation Card

@dynamic frontText;
@dynamic frontImageName;
@dynamic cardType;
@dynamic detailedQuestion;
@dynamic quizQuestion;
@dynamic quizAnswer;
@dynamic didYouKnowThat;
@dynamic moreInfo;
@dynamic cardReference;
@dynamic category;

- (NSString *)description
{
    return [NSString stringWithFormat:@"Front text: \"%@\", Front image: \"%@\"", self.frontText, self.frontImageName];
}

@end
