//
//  LSCategoryTableViewController.h
//  Lystspillet
//
//  Created by Philip Nielsen on 21/11/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Category.h"

@protocol LSCategoryTableViewControllerDelegate <NSObject>

- (void)didSelectCategory:(NSString *)categoryName withCategory:(Category *)category;

@end

@interface LSCategoryTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISplitViewControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) id <LSCategoryTableViewControllerDelegate> delegate;

@property (nonatomic, strong) UISplitViewController *splitViewController;

@end
