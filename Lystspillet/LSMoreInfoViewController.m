//
//  LSMoreInfoViewController.m
//  Lystspillet
//
//  Created by Philip Nielsen on 23/11/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import "LSMoreInfoViewController.h"
#import "UITextView+Resize.h"

@interface LSMoreInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *frameImage;

@end

@implementation LSMoreInfoViewController

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
    
    [self setTitle:self.category.title];
    [self.descriptionTextView setText:self.category.longDescription];
    [self.imageView setImage:[UIImage imageNamed:self.category.imageName]];
    
    [self.descriptionTextView setFont:[UIFont fontWithName:@"Helsinki" size:self.descriptionTextView.font.pointSize]];
    
    [self.frameImage setImage:[UIImage imageNamed:self.category.frameImageName]];
    
    int originalTop = self.descriptionTextView.frame.origin.y;
    int originalHeight = self.descriptionTextView.frame.size.height;
    
    int originalCenter = (originalHeight / 2) + originalTop;
    
    [self.descriptionTextView sizeToFitForMaxHeight:self.descriptionTextView.frame.size.height];
    int newHeight = self.descriptionTextView.frame.size.height;
    
    [self.descriptionTextView setFrame:CGRectMake(self.descriptionTextView.frame.origin.x, originalCenter - (newHeight / 2), self.descriptionTextView.frame.size.width, self.descriptionTextView.frame.size.height)];
    
    
    
}
- (IBAction)done:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
