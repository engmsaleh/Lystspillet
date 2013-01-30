//
//  LSAppDelegate.h
//  Lystspillet
//
//  Created by Philip Nielsen on 21/11/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSCategoryViewController.h"

@interface LSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) LSCategoryViewController *categoryViewController;

- (NSURL *)applicationDocumentsDirectory;

- (BOOL)openURL:(NSURL*)url;

@end
