//
//  LSCategoryViewController.m
//  Lystspillet
//
//  Created by Philip Nielsen on 29/12/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import "LSCategoryViewController.h"
#import "Category.h"
#import "LSBrowserViewController.h"
#import "LSAboutViewController.h"
#import "LSAppDelegate.h"
#import "NSObject+PerformBlockAfterDelay.h"
#import "UIDevice-Hardware.h"
#import "LSAppDelegate.h"
#import "NSManagedObjectContext+SingleFetch.h"
#import "StaticText.h"
#import <MessageUI/MFMailComposeViewController.h>

typedef enum : NSUInteger {
    ShowingAbout,
    ShowingHelp,
    ShowingNormal
} State;

@interface LSCategoryViewController () <UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) LSCardCollectionViewController *cardCollectionViewController;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) UIPopoverController *activityPopover;
@property (nonatomic, strong) UIBarButtonItem *aboutBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *helpBarButtonItem;
@property (nonatomic, strong) UIActionSheet *supportActionSheet;
@property (nonatomic, strong) UIActionSheet *helpActionSheet;
@property (nonatomic) State state;
@property (nonatomic, strong) NSArray *helpElements;

@property (strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation LSCategoryViewController

@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

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
    
    if (!self.managedObjectContext) {
        LSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
    }
    
    self.helpElements = @[@"Brugsanvisning", @"Spillevejledning"];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        [self handleSplitViewBarButtonItem:self.splitViewBarButtonItem];
        
        UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
        self.aboutBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Om" style:UIBarButtonItemStyleBordered target:self action:@selector(about)];
        self.helpBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"Hjælp" style:UIBarButtonItemStyleBordered target:self action:@selector(help:)];
        UIBarButtonItem *support  = [[UIBarButtonItem alloc] initWithTitle:@"Support" style:UIBarButtonItemStyleBordered target:self action:@selector(support:)];
        
        if ([MFMailComposeViewController canSendMail]) {
            [self.navigationItem setRightBarButtonItems:@[share, self.aboutBarButtonItem, self.helpBarButtonItem, support] animated:NO];
        } else {
            [self.navigationItem setRightBarButtonItems:@[share, self.aboutBarButtonItem, self.helpBarButtonItem] animated:NO];
        }
            
        
        self.state = ShowingAbout;
        
        UITapGestureRecognizer *helpTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(helpImageTapped:)];
        [helpTap setNumberOfTapsRequired:1];
        [self.helpImage addGestureRecognizer:helpTap];
        
        [self setTitle:@"Lystspillet"];
        
        NSArray *objects = [self.managedObjectContext fetchObjectsForEntityName:@"StaticText" withPredicate:@"textKey = 'forside_tekst'"];
        
        if (objects.count == 1) {
            StaticText *frontText = objects[0];
            self.aboutWelcome.text = frontText.text;
        }
        
    }
//    else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
//        [self setToolbarItems:@[admin, about, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], share]];

}

-(void)viewDidAppear:(BOOL)animated
{
    [UIView animateWithDuration:1.0 animations:^{
        [self.logo setFrame:CGRectMake(self.logo.frame.origin.x, 80, self.logo.frame.size.width, self.logo.frame.size.height)];
        [self.aboutWelcome setAlpha:1.0];
    } completion:^(BOOL finished) {
        [self performBlock:^{
            [UIView animateWithDuration:0.5 animations:^{
                
                [self.arrowStartView setAlpha:1.0];
            }];
        } afterDelay:0.7];
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setState:(State)state
{
    _state = state;
    
    switch (state) {
        case ShowingAbout:
        {
            [self.aboutBarButtonItem setEnabled:NO];
            [self.helpBarButtonItem setEnabled:YES];
            self.helpElements = @[@"Spillevejledning"];
            break;
        }
            
        case ShowingHelp:
        {
            [self.aboutBarButtonItem setEnabled:NO];
            self.helpElements = @[@"Luk brugsanvisning", @"Spillevejledning"];
            break;
        }
            
        case ShowingNormal:
        {
            [self.aboutBarButtonItem setEnabled:YES];
            [self.helpBarButtonItem setEnabled:YES];
            
            self.helpElements = @[@"Brugsanvisning", @"Spillevejledning"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            BOOL helpAlreadyShown = [[defaults objectForKey:@"helpAlreadyShown"] boolValue];
            
            if (!helpAlreadyShown) {
                [self showGuide];
                [defaults setObject:@YES forKey:@"helpAlreadyShown"];
                [defaults synchronize];
            }
            
            break;
        }
            
            
        default:
            break;
    }
}

- (void)share:(UIBarButtonItem *)sender
{
    NSArray *objects = [self.managedObjectContext fetchObjectsForEntityName:@"StaticText" withPredicate:@"textKey = 'deling_tekst'"];
    
    if (objects.count == 1) {
        StaticText *sharingText = objects[0];
        
        UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[sharingText.text] applicationActivities:nil];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            //        activityViewController.completionHandler = ^(NSString *activityType, BOOL completed){ NSLog(@"completion 2 - activityType: %@ completed: %@", activityType, completed ? @"YES" : @"NO"); [self dismissViewControllerAnimated:YES completion:^{NSLog(@"completion 3");}]; };
            [self presentViewController:activityViewController animated:YES completion:^{ NSLog(@"completion 1"); }];
            
        } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            if (self.activityPopover.isPopoverVisible) {
                [self.activityPopover dismissPopoverAnimated:YES];
                return;
            }
            self.activityPopover = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
            [self.activityPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
    }
}

- (void)about
{
    if (self.startView.alpha == 0.0) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.startView setAlpha:1.0];
        }];
        self.state = ShowingAbout;
        
        [self setTitle:@"Lystspillet"];
    }
}

- (void)admin
{
    
}

- (void)help:(UIBarButtonItem *)sender
{
    
    if (self.helpActionSheet) {
        [self.helpActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
        self.helpActionSheet = nil;
        return;
    }
    
    if (self.supportActionSheet) {
        [self.supportActionSheet dismissWithClickedButtonIndex:-1 animated:NO];
        self.supportActionSheet = nil;
    }
    
    self.helpActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSString *element in self.helpElements)
         [self.helpActionSheet addButtonWithTitle:element];
    [self.helpActionSheet showFromBarButtonItem:sender animated:YES];
    
}

- (void)helpImageTapped:(UIGestureRecognizer *)gesture
{
    if (self.helpImage.alpha != 0) {
        [UIView animateWithDuration:0.6 animations:^{
            [self.helpImage setAlpha:0.0];
        }];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL helpAlreadyShown = [[defaults objectForKey:@"gameGuideAlreadyShown"] boolValue];
        
        if (!helpAlreadyShown) {
            [self performSegueWithIdentifier:@"Vejledning" sender:self];
            [defaults setObject:@YES forKey:@"gameGuideAlreadyShown"];
            [defaults synchronize];
        }

        
        self.state = ShowingNormal;
    }
}

- (void)support:(UIBarButtonItem *)sender
{
    if (self.supportActionSheet) {
        [self.supportActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
        self.supportActionSheet = nil;
        return;
    }
    
    if (self.helpActionSheet) {
        [self.helpActionSheet dismissWithClickedButtonIndex:-1 animated:NO];
        self.helpActionSheet = nil;
    }
    
    self.supportActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Anullér" destructiveButtonTitle:nil otherButtonTitles:@"Fejl i kort", @"Forslag", @"Funktionel fejl", nil];
    [self.supportActionSheet showFromBarButtonItem:sender animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Card Container"]) {
        self.cardCollectionViewController = segue.destinationViewController;
        self.cardCollectionViewController.pageControlDelegate = self;
        self.cardCollectionViewController.category = self.category;
        
    } else if ([segue.identifier isEqualToString:@"Custom Browser"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        LSBrowserViewController *browserController = navigationController.viewControllers[0];
        browserController.url = self.browserURL;
    } else if ([segue.identifier isEqualToString:@"Vejledning"]) {
        self.displayingModal = YES;
        UINavigationController *navigationController = segue.destinationViewController;
        LSAboutViewController *aboutController = navigationController.viewControllers[0];
        aboutController.categoryViewController = self;
    }
}

- (void)setCategory:(Category *)category
{
//    NSLog(@"CategoryViewController - setting category");
    _category = category;
    
    [self setTitle:category.title];
    
    self.categoryImage.image = [UIImage imageNamed:category.imageName];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    self.displayingModal = NO;
    [super dismissViewControllerAnimated:flag completion:completion];
}

- (void)showGuide
{
    if (self.helpImage.alpha == 0) {
        [UIView animateWithDuration:0.6 animations:^{
            [self.helpImage setAlpha:1.0];
        }];
        self.state = ShowingHelp;
    } else {
        [UIView animateWithDuration:0.6 animations:^{
            [self.helpImage setAlpha:0.0];
        }];
        self.state = ShowingNormal;
    }
}

#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet isEqual:self.supportActionSheet]) {
        
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        
        self.supportActionSheet = nil;
        
        switch (buttonIndex) {
            case 0: {
                
                NSString *reference = [self.cardCollectionViewController referenceNumberForShowingCard];
                
                NSMutableString *body = [NSMutableString string];
                [body appendString:@"Hej,</br></br>Jeg har fundet følgende fejl på et kort: <ul>"];
                [body appendFormat:@"<li><b>Referencenummer%@</li>", reference ? [NSString stringWithFormat:@": </b>%@", reference] : @"</b> (kan ses på bagsiden af kortet):&nbsp;"];
                [body appendString:@"<li><b>Fejl:</b>&nbsp;</li>"];
                [body appendString:@"</ul>"];
                
                [controller setSubject:@"Fejl i kort"];
                [controller setMessageBody:body isHTML:YES];
                [controller setToRecipients:@[@"info@lystspillet.dk"]];
                break;
            }
                
            case 1: {
                [controller setSubject:@"Forslag til iOS App"];
                [controller setMessageBody:@"Hej,</br></br>Jeg har følgende forslag til app'en:<ul><li></li></ul>" isHTML:YES];
                [controller setToRecipients:@[@"support@simplesense.dk"]];
                [controller setCcRecipients:@[@"info@lystspillet.dk"]];
                break;
            }
                
            case 2: {
                NSMutableString *body = [NSMutableString string];
                [body appendString:@"Hej,</br></br>Jeg oplever følgende problemer:"];
                [body appendString:@"<ul><li></li></ul>"];
                [body appendString:@"Yderligere informationer:"];
                [body appendString:@"<ul>"];
                [body appendFormat:@"<li><b>Model:</b> %@</li>", [[UIDevice currentDevice] platformString] ];
                [body appendFormat:@"<li><b>Styresystem:</b> %@</li>", [[UIDevice currentDevice] systemVersion] ];
                [body appendFormat:@"<li><b>App version:</b> %@</li>", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ];
                [body appendString:@"</ul>"];
                
                [controller setSubject:@"Funktionel fejl i iOS App"];
                [controller setMessageBody:body isHTML:YES];
                [controller setToRecipients:@[@"support@simplesense.dk"]];
                [controller setCcRecipients:@[@"info@lystspillet.dk"]];
                break;
            }
                
            default:
                return;
        }
    
        if (controller) [self presentViewController:controller animated:YES completion:^{}];
        
    } else if ([actionSheet isEqual:self.helpActionSheet]) {
        
        if (self.helpElements.count == 1 && buttonIndex == 0) {
            
            [self performSegueWithIdentifier:@"Vejledning" sender:self];
            
        } else if (self.helpElements.count == 2) {
            
            switch (buttonIndex) {
                case 0: {
                    [self showGuide];
                    break;
                }
                    
                case 1: {
                    [self performSegueWithIdentifier:@"Vejledning" sender:self];
                    break;
                }
                    
                default:
                    break;
            }
        }
        
        self.helpActionSheet = nil;
    }
}

#pragma mark - Mail Compose Controller Delegate

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - Split View Delegate

- (void)handleSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (self.splitViewBarButtonItem) [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    if (splitViewBarButtonItem)  [self.navigationItem setLeftBarButtonItem:splitViewBarButtonItem animated:NO];
    _splitViewBarButtonItem = splitViewBarButtonItem;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (splitViewBarButtonItem != _splitViewBarButtonItem) {
        [self handleSplitViewBarButtonItem:splitViewBarButtonItem];
    }
}

#pragma mark - Category Table View Controller Delegate

- (void)didSelectCategory:(NSString *)categoryName withCategory:(Category *)category
{
    [self setTitle:categoryName];
    self.category = category;
    
    self.categoryImage.image = [UIImage imageNamed:category.imageName];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{ self.startView.alpha = 0.0; } completion:^(BOOL finished){}];
    
    self.state = ShowingNormal;
    
    self.cardCollectionViewController.category = self.category;
}

#pragma mark - Page Control Delegate

- (void)didEndScrollingCollectionViewAtPage:(int)page
{
    [self.pageControl setCurrentPage:page];
}

- (void)initializePageControlWithNumberOfPages:(int)numberOfPages
{
    [self.pageControl setNumberOfPages:numberOfPages];
}

@end
