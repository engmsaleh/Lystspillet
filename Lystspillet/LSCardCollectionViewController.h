//
//  LSCardViewController.h
//  Lystspillet
//
//  Created by Philip Nielsen on 23/11/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSCategoryTableViewController.h"
#import "Category.h"

@protocol LSCardCollectionViewPageControlDelegate <NSObject>

- (void)initializePageControlWithNumberOfPages:(int)numberOfPages;
- (void)didEndScrollingCollectionViewAtPage:(int)page;

@end

@interface LSCardCollectionViewController : UICollectionViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) Category *category;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) id <LSCardCollectionViewPageControlDelegate> pageControlDelegate;

- (NSString *)referenceNumberForShowingCard;

@end