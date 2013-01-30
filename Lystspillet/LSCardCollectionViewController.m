//
//  LSCardViewController.m
//  Lystspillet
//
//  Created by Philip Nielsen on 23/11/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import "LSCardCollectionViewController.h"
#import "LSCardCollectionViewFlowLayout.h"
#import "LSCardViewController.h"
#import "LSAppDelegate.h"
#import "LSCollectionViewCardCell.h"
#import "LSAboutViewController.h"
#import "LSAppDelegate.h"
#import "UITextView+Resize.h"
#import "UIView+Distance.h"
#import "NSString+Contain.h"
#import "UIColor+Hex.h"
#import "Card.h"

@interface LSCardCollectionViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) __block NSMutableArray *displayingPrimary;
@property (nonatomic, strong) NSMutableArray *cellAppearencesSet;
@property (nonatomic) int lastContentOffset;
@property (nonatomic) int currentCardIndex;

@end

@implementation LSCardCollectionViewController

#pragma mark - Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flowLayout = [[LSCardCollectionViewFlowLayout alloc] init];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        LSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;        
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
//    [NSFetchedResultsController deleteCacheWithName:@"Card"]; 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom

- (void)setCategory:(Category *)category
{
    // ManagedObjectContext set in ViewDidLoad on iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        LSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
    }
    
    if (_category) {
        LSCollectionViewCardCell *cell = (LSCollectionViewCardCell *)[self.collectionView cellForItemAtIndexPath:self.collectionView.indexPathsForVisibleItems[0]];
        [self turnCardFromView:cell.backView toView:cell.frontView withAnimationOptions:UIViewAnimationOptionShowHideTransitionViews forDuration:0.0 andCompletion:^(BOOL finished){}];
    }
    
    _category = category;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category = %@", _category];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    
    NSError *error;
//    [NSFetchedResultsController deleteCacheWithName:@"Card"];
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    [self.collectionView reloadData];
    if (_category) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        [_pageControlDelegate didEndScrollingCollectionViewAtPage:0];
    }

}

- (void)handleBackScrollViewTap:(UITapGestureRecognizer *)recognizer
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        NSArray *indexPathForVisibleItems = self.collectionView.indexPathsForVisibleItems;
        if (indexPathForVisibleItems.count == 1) {
            [self.collectionView.delegate collectionView:self.collectionView didSelectItemAtIndexPath:indexPathForVisibleItems[0]];
        }
    }
}

#pragma mark - Card Turner

- (void)turnCardFromView:(UIView *)fromView toView:(UIView *)toView withAnimationOptions:(UIViewAnimationOptions)options forDuration:(double)duration andCompletion:(void (^)(BOOL finished))completion
{
//    _displayingPrimary[_currentCardIndex] = [NSNumber numberWithBool:YES];
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:duration
                       options:options
                    completion:completion
     ];
}

#pragma mark - Collection View Delegate

- (LSCollectionViewCardCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LSCollectionViewCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Card Cell" forIndexPath:indexPath];
    
//    [UIView printViewHierarchy:cell depth:0];
    
//    NSLog(@"%@", cell.primaryContentView.hidden ? @"YES" : @"NO");
    
    Card *card = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
//    NSLog(@"Card: %@", card.description);

    // Front ***********************************************************************************************************************
    if (!card.frontText.length == 0 && card.frontImageName.length == 0) {
        
        [cell.frontFrame setImage:[UIImage imageNamed:card.category.frameImageName]];
        cell.frontImage.alpha = 0.0;
        cell.frontTextView.alpha = 1.0;
        cell.cardType.alpha = 1.0;
        
        cell.frontTextView.text = card.frontText;
        [cell.frontTextView setTextColor:[UIColor colorWithHexString:card.category.categoryColor]];
        cell.cardType.text = card.cardType;
        [cell.cardType setTextColor:[UIColor colorWithHexString:card.category.categoryColor]];
        
    } else if (card.frontText.length == 0 && !card.frontImageName.length == 0) {
        
        [cell.frontFrame setImage:[UIImage imageNamed:@"FrameWhite.png"]];
        cell.frontImage.alpha = 1.0;
        cell.frontTextView.alpha = 0.0;
        cell.cardType.alpha = 0.0;
        
        [cell.frontImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"COLOURBOX%@", [card.frontImageName stringByReplacingOccurrencesOfString:@"c" withString:@""]]]];
        
    } else {
        NSLog(@"Error in database");
    }

    
    // Back ************************************************************************************************************************
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBackScrollViewTap:)];
    [cell.backScrollView addGestureRecognizer:tap];
    
    [cell.backFrame setImage:[UIImage imageNamed:card.category.frameImageName]];
    
    cell.detailedQuestionTextView.text = card.detailedQuestion;
    cell.quizTextView.text = card.quizQuestion;
    cell.answerTextView.text = card.quizAnswer;
    cell.didYouKnowTextView.text = card.didYouKnowThat;
    
    cell.cardReferenceNumber.text = card.cardReference;
    
    if (card.detailedQuestion.length == 0)  [cell.detailedQuestionTextView setAlpha:0.0];   else [cell.detailedQuestionTextView setAlpha:1.0];
    if (card.quizQuestion.length == 0)      [cell.quizTextView setAlpha:0.0];               else [cell.quizTextView setAlpha:1.0];
    if (card.quizAnswer.length == 0)        [cell.answerTextView setAlpha:0.0];             else [cell.answerTextView setAlpha:1.0];
    if (card.didYouKnowThat.length == 0)    [cell.didYouKnowTextView setAlpha:0.0];         else [cell.didYouKnowTextView setAlpha:1.0];

    if (!card.moreInfo.length == 0) {
        cell.moreInfoTextView.text = card.moreInfo;
        cell.moreInfoView.alpha = 1.0;
        cell.moreInfoFrame.alpha = 1.0;
    } else {
        cell.moreInfoView.alpha = 0.0;
        cell.moreInfoFrame.alpha = 0.0;
    }
    
    if (![_cellAppearencesSet[indexPath.row] boolValue]) [cell layoutCollectionViewCardCell];//[self setAppearanceForCell:cell atIndex:indexPath.row];
    
    CGFloat topCorrect = (cell.frontTextView.bounds.size.height - [cell.frontTextView contentSize].height * [cell.frontTextView zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    cell.frontTextView.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (!_category) {
        [_pageControlDelegate initializePageControlWithNumberOfPages:0];
        return 0;
    }
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
//    NSLog(@"Number of cards: %i", [sectionInfo numberOfObjects]);
    [_pageControlDelegate initializePageControlWithNumberOfPages:[sectionInfo numberOfObjects]];
    
    _displayingPrimary = nil;
    _displayingPrimary = [[NSMutableArray alloc] initWithCapacity:[sectionInfo numberOfObjects]];
    
    for (int i = 0; i < [sectionInfo numberOfObjects]; i++) {
        [_displayingPrimary insertObject:[NSNumber numberWithBool:YES] atIndex:i];
    }
    
    _cellAppearencesSet = nil;
    _cellAppearencesSet = [[NSMutableArray alloc] initWithCapacity:[sectionInfo numberOfObjects]];
    
    for (int i = 0; i < [sectionInfo numberOfObjects]; i++) {
        [_cellAppearencesSet insertObject:[NSNumber numberWithBool:NO] atIndex:i];
    }
    
    return [sectionInfo numberOfObjects];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LSCollectionViewCardCell *cell = (LSCollectionViewCardCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    void (^completion)(BOOL) = ^(BOOL finished){
        if (finished) {
            _displayingPrimary[indexPath.row] = [_displayingPrimary[indexPath.row] boolValue] ? @NO : @YES;
            if (![_displayingPrimary[indexPath.row] boolValue] && cell.backScrollView.contentSize.height > cell.backScrollView.frame.size.height) [cell.backScrollView flashScrollIndicators];
        }
    };
    
    bool displayingPrimary = [_displayingPrimary[indexPath.row] boolValue];
    
    [self turnCardFromView:(displayingPrimary ? cell.frontView : cell.backView)
                    toView:(displayingPrimary ? cell.backView  : cell.frontView)
      withAnimationOptions:(displayingPrimary ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight) | UIViewAnimationOptionShowHideTransitionViews
               forDuration:0.9
             andCompletion:completion];
}

#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController)
        return _fetchedResultsController;
    
    if (!_managedObjectContext) {
        LSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category = %@", _category];
    [fetchRequest setPredicate:predicate];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"frontImageName" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
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

#pragma mark - Scroll View Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger nearestNumber = lround(fractionalPage);
    
    _currentCardIndex = nearestNumber;
    
    [_pageControlDelegate didEndScrollingCollectionViewAtPage:nearestNumber];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    
    if (_currentCardIndex < [self.collectionView numberOfItemsInSection:0]) {
        
        // Half way there to the left and displaying back side
        if (_lastContentOffset > scrollView.contentOffset.x && scrollView.contentOffset.x / pageWidth < _currentCardIndex - 0.5f && ![_displayingPrimary[_currentCardIndex] boolValue]) {
            
            LSCollectionViewCardCell *cell = (LSCollectionViewCardCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentCardIndex inSection:0]];
            
            [self turnCardFromView:cell.backView toView:cell.frontView withAnimationOptions:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionShowHideTransitionViews forDuration:0.9 andCompletion:^(BOOL finished){}];
            
            _displayingPrimary[_currentCardIndex] = @YES;
            
            // Half way there to the right and displaying back side
        } else if (_lastContentOffset < scrollView.contentOffset.x && scrollView.contentOffset.x / pageWidth > _currentCardIndex + 0.5f && ![_displayingPrimary[_currentCardIndex] boolValue]) {
            
            LSCollectionViewCardCell *cell = (LSCollectionViewCardCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentCardIndex inSection:0]];
            
            [self turnCardFromView:cell.backView toView:cell.frontView withAnimationOptions:UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionShowHideTransitionViews forDuration:0.9 andCompletion:^(BOOL finished){}];
            
            _displayingPrimary[_currentCardIndex] = @YES;
            
        }
    }
    
    _lastContentOffset = scrollView.contentOffset.x;
}

#pragma mark - Category View Controller Delegate

- (NSString *)referenceNumberForShowingCard
{
    NSArray *visibleItems = self.collectionView.indexPathsForVisibleItems;

    if (visibleItems.count == 0) return nil;
    
    LSCollectionViewCardCell *cell = (LSCollectionViewCardCell *)[self.collectionView cellForItemAtIndexPath:visibleItems[0]];
    
    return cell.cardReferenceNumber.text;
}

@end
