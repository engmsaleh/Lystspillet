//
//  LSCategoryTableViewController.m
//  Lystspillet
//
//  Created by Philip Nielsen on 21/11/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import "LSCategoryTableViewController.h"
#import "LSCategoryTableViewCell.h"
#import "LSAppDelegate.h"
#import "LSCardCollectionViewController.h"
#import "LSMoreInfoViewController.h"
#import "SplitViewBarButtonItemPresenter.h"
#import "LSCategoryViewController.h"
#import "UITextView+Resize.h"
#import "NSString+StringThatFits.h"

@interface LSCategoryTableViewController ()

@property (nonatomic, strong) Category *selectedCategory;
@property (nonatomic) BOOL categorySelected;
@property (nonatomic, strong) UIPopoverController *masterPopover;

@end

@implementation LSCategoryTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib  // always try to be the split view's delegate
{
    [super awakeFromNib];
    _splitViewController.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    _categories = @[@"Følelser", @"At være sig selv", @"Krop", @"Sex", @"Lyst", @"Seksuel mangfoldighed",
//    @"Passe på sig selv og hinanden", @"Den seksuelle kultur", @"Seksuelle rettigheder",
//    @"Respekt", @"Kærester", @"Overgreb", @"Opvarmning"];
    
    LSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    LSCategoryViewController *categoryViewController = [[[self.splitViewController.viewControllers lastObject] viewControllers] objectAtIndex:0];
    self.delegate = categoryViewController;
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    UIView *topview = [[UIView alloc] initWithFrame:CGRectMake(0,-480,320,480)];
    UIImageView *shadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableViewBackground.png"]];
    [shadowView setFrame:CGRectMake(0, 0, 320, 480)];
    [topview addSubview:shadowView];
    [self.tableView addSubview:topview];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,1300,320,480)];
    UIImageView *bottomShadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableViewBackgroundBottom.png"]];
    [bottomShadowView setFrame:CGRectMake(0, 0, 320, 480)];
    [bottomView addSubview:bottomShadowView];
    [self.tableView addSubview:bottomView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
//        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
//        
//        if ([self.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
//            [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}

-(NSData *)getImageBinary:(NSString *)fileName
{
    NSString *root = [[NSBundle mainBundle] bundlePath];
    NSString *filePath = [[NSString alloc] initWithString:[root stringByAppendingString:[@"/"stringByAppendingString:fileName]]];
    
    NSLog(@"%@",filePath);
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:[root stringByAppendingString:[@"/"stringByAppendingString:fileName]]];
    NSData *imgData = UIImagePNGRepresentation(img);
    
    return imgData;
}

-(NSString *)getPath:(NSString *)fileName
{
    NSString *root = [[NSBundle mainBundle] bundlePath];
    
    NSURL *imageURL = [[NSURL alloc] initFileURLWithPath:[root stringByAppendingString:[@"/" stringByAppendingString:fileName]]];
    
    [imageURL absoluteURL];
    NSString *path= [imageURL absoluteString];
    NSLog(@"%@",path);
    return path;
}

- (void)insertNewObject:(NSString *)fileName
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    [newManagedObject setValue:fileName forKey:@"imageName"];
    [newManagedObject setValue:[self getPath:fileName] forKey:@"imageUrl"];
    [newManagedObject setValue:[self getImageBinary:fileName] forKey:@"image"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"More Info"]) {
        UINavigationController *rootViewController = segue.destinationViewController;
        LSMoreInfoViewController *destinationController = [rootViewController.viewControllers objectAtIndex:0];
        
        [destinationController setCategory:self.selectedCategory];
        
    } else if ([segue.identifier isEqualToString:@"Card Collection"]) {
        
//        LSCardCollectionViewController *controller = segue.destinationViewController;
//        
//        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
//        Category *category = [self.fetchedResultsController objectAtIndexPath:path];
//        controller.managedObjectContext = self.managedObjectContext;
//        [controller didSelectCategory:category.title withCategory:category];
    } else if ([segue.identifier isEqualToString:@"Category"]) {
        LSCategoryViewController *controller = segue.destinationViewController;
        controller.category = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    }
}

- (IBAction)infoButtonTapped:(UIButton *)sender withEvent: (UIEvent *) event
{
    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint: [[[event touchesForView: sender] anyObject] locationInView: self.tableView]];
    
    if (!indexPath) return;
    
    [self.tableView.delegate tableView: self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}

- (void)hideMasterViewController
{
    _categorySelected = YES;

    if (_masterPopover) {
        [_masterPopover dismissPopoverAnimated:YES];
    }
    
//    [_splitViewController.view setNeedsLayout];
//    _splitViewController.delegate = nil;
//    _splitViewController.delegate = self;
//    [_splitViewController willRotateToInterfaceOrientation:self.interfaceOrientation duration:1];
}

#pragma mark - Split view controller delegate

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter
{
    
    UINavigationController *navigationController = [self.splitViewController.viewControllers lastObject];
    id detailVC = navigationController.viewControllers[0];
    
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) {
        detailVC = nil;
    }
    return detailVC;
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return YES;///*[self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;*/_categorySelected;
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = self.navigationItem.title;
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
    
    _masterPopover = pc;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return _categories.count;
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (LSCategoryTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Category Cell";
    LSCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Category *category = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableViewCellBackground.png"]];
    
    [cell.categoryTitle setFont:[UIFont fontWithName:@"Helsinki" size:cell.categoryTitle.font.pointSize]];
    
    CGPoint originalOrigin = cell.categoryDescription.frame.origin;
    
    cell.categoryImage.image = [UIImage imageNamed:category.imageName];
    cell.categoryTitle.text = category.title;
    cell.categoryDescription.text = category.littleDescription;
    
    [cell.categoryDescription sizeToFit];
    
    [cell.categoryDescription setFrame:CGRectMake(originalOrigin.x, originalOrigin.y, cell.categoryDescription.frame.size.width, cell.categoryDescription.frame.size.height)];
    
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor colorWithRed:100/255.0 green:191/255.0 blue:176/255.0 alpha:1.0]];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        Category *category = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        [self.delegate didSelectCategory:category.title withCategory:category];
        [self hideMasterViewController];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    Category *categoty = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    self.selectedCategory = categoty;
    
    [self performSegueWithIdentifier:@"More Info" sender:self];
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sorting" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Category"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}



@end