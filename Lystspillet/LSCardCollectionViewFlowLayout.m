//
//  LSCardCollectionViewFlowLayout.m
//  Lystspillet
//
//  Created by Philip Nielsen on 27/11/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import "LSCardCollectionViewFlowLayout.h"

@implementation LSCardCollectionViewFlowLayout

- (id)init {
    self = [super init];
    if (self) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [self setItemSize:CGSizeMake(644, 644)];
        } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [self setItemSize:CGSizeMake(270, 270)];
        }
        
        [self setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [self setMinimumLineSpacing:20];
        [self setSectionInset:UIEdgeInsetsMake(0, 10, 0, 10)];
        
//        NSLog(@"Card size: %@", NSStringFromCGSize(self.itemSize));s
    }
    return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *newAttributes = [NSMutableArray arrayWithCapacity:attributes.count];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        if (attribute.frame.origin.x + attribute.frame.size.width <= self.collectionViewContentSize.width) {
            [newAttributes addObject:attribute];
        }
    }
    return newAttributes;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat targetX = proposedContentOffset.x + self.minimumInteritemSpacing + self.sectionInset.left;
//    NSLog(@"targetX = %f", targetX);
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    for(UICollectionViewLayoutAttributes *layoutAttributes in array) {
        
        if(layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            CGFloat itemX = layoutAttributes.frame.origin.x;
            
            if (ABS(itemX - targetX) < ABS(offsetAdjustment)) {
                offsetAdjustment = itemX - targetX;
            }
        }
    }
    
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end
