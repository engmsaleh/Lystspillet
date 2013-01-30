//
//  LSAppDelegate.m
//  Lystspillet
//
//  Created by Philip Nielsen on 21/11/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import "LSAppDelegate.h"
#import "LSCategoryTableViewController.h"

@interface LSAppDelegate ()

@end

@implementation LSAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [self setAppearance];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) { // iPad
        
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *controller = (UINavigationController *)splitViewController.viewControllers[0];
        LSCategoryTableViewController *tableViewController = (LSCategoryTableViewController *)controller.viewControllers[0];
        tableViewController.managedObjectContext = self.managedObjectContext;
        
        splitViewController.delegate = tableViewController;
        tableViewController.splitViewController = splitViewController;
        
        UINavigationController *controller2 = splitViewController.viewControllers[1];
        self.categoryViewController = controller2.viewControllers[0];
        
        UIImageView *splash = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-Lanscape~ipad.png"]];
        [self.categoryViewController.view addSubview:splash];
        
//        NSLog(@"%@", [self.window.rootViewController class]);
        
        sleep(1.5);
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             splash.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [splash removeFromSuperview];
                         }];

        
    } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) { // iPhone
        
        UINavigationController *controller = (UINavigationController *)self.window.rootViewController;
        LSCategoryTableViewController *tableViewController = (LSCategoryTableViewController *)controller.viewControllers[0];
        tableViewController.managedObjectContext = self.managedObjectContext;
        
    }
    
        
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    else
        return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)openURL:(NSURL*)url
{
    NSLog(@"Open URL: %@", [url description]);
    _categoryViewController.browserURL = url;
    [_categoryViewController performSegueWithIdentifier:@"Custom Browser" sender:_categoryViewController];
    
    return YES;
}


#pragma mark - Customization

- (void)setAppearance
{
    // UINavigationBar --------------------------------------------------------------------------------------------------------------------
    
    UIImage *navBar = [UIImage imageNamed:@"NavBar2.png"];
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor/*colorWithRed:255/255.0 green:191/255.0 blue:1/255.0 alpha:1.0*/], UITextAttributeFont : [UIFont fontWithName:@"Helsinki" size:21.0], UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowColor : [UIColor darkGrayColor]}];
    [[UINavigationBar appearance] setBackgroundImage:navBar forBarMetrics:UIBarMetricsDefault];
    
    [[UIToolbar appearance] setBackgroundImage:navBar forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    
    // UIBarButtons -----------------------------------------------------------------------------------------------------------------------
    
    UIImage *buttonBackground = [[UIImage imageNamed:@"NavBarButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [[UIBarButtonItem appearance] setBackgroundImage:buttonBackground forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *buttonBackgroundPushed = [[UIImage imageNamed:@"NavBarButtonPushed"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [[UIBarButtonItem appearance] setBackgroundImage:buttonBackgroundPushed forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    // UIBarButtonBack --------------------------------------------------------------------------------------------------------------------
    
    UIImage *backButton = [[UIImage imageNamed:@"NavBarButtonBack"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 21, 5, 5)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *backButtonPushed = [[UIImage imageNamed:@"NavBarButtonBackPushed"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 21, 5, 5)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonPushed forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
        NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"CoreDataImport" ofType:@"sqlite"]];
        NSError* err = nil;
        
        if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeURL error:&err]) {
            NSLog(@"Oops, could copy preloaded data");
        }
    }
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         */
//        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
         /*
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         */
//        @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES};
        
        /*
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Migration

- (BOOL)migrateStore:(NSURL *)storeURL toVersionTwoStore:(NSURL *)dstStoreURL error:(NSError **)outError {
    
    // Try to get an inferred mapping model.
    NSMappingModel *mappingModel = [NSMappingModel inferredMappingModelForSourceModel:[self sourceModel]
                                      destinationModel:[self destinationModel] error:outError];
    
    // If Core Data cannot create an inferred mapping model, return NO.
    if (!mappingModel) {
        return NO;
    }
    
    // Create a migration manager to perform the migration.
    NSMigrationManager *manager = [[NSMigrationManager alloc] initWithSourceModel:[self sourceModel] destinationModel:[self destinationModel]];
    
    BOOL success = [manager migrateStoreFromURL:storeURL type:NSSQLiteStoreType
                                        options:nil withMappingModel:mappingModel toDestinationURL:dstStoreURL
                                destinationType:NSSQLiteStoreType destinationOptions:nil error:outError];
    
    return success;
}

- (NSManagedObjectModel *)sourceModel
{
    return nil;
}

- (NSManagedObjectModel *)destinationModel
{
    return nil;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
