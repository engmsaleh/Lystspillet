//
//  LSAboutViewController.m
//  Lystspillet
//
//  Created by Philip Nielsen on 27/11/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import "LSAboutViewController.h"
#import "LSAppDelegate.h"
#import "StaticText.h"
#import "NSManagedObjectContext+SingleFetch.h"

@interface LSAboutViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *topShadow;
@property (weak, nonatomic) IBOutlet UIImageView *bottomShadow;

@property (strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation LSAboutViewController

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
    
    NSArray *objects = [self.managedObjectContext fetchObjectsForEntityName:@"StaticText" withPredicate:@"textKey = 'vejledning_tekst'"];
    
    if (objects.count == 1) {
        StaticText *text = objects[0];
        self.textView.text = text.text;
    }
    
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.textView flashScrollIndicators];
}

- (IBAction)done:(UIBarButtonItem *)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@YES forKey:@"gameGuideAlreadyShown"];
    [defaults synchronize];
    
    self.categoryViewController.displayingModal = NO;
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0) {
        [UIView animateWithDuration:0.07 animations:^{
            [self.topShadow setAlpha:0.0];
        }];
    } else {
        [UIView animateWithDuration:0.07 animations:^{
            [self.topShadow setAlpha:1.0];
        }];    
    }
    
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
        [UIView animateWithDuration:0.07 animations:^{
            [self.bottomShadow setAlpha:0.0];
        }];
    } else {
        [UIView animateWithDuration:0.07 animations:^{
            [self.bottomShadow setAlpha:1.0];
        }];
    }
}

@end
