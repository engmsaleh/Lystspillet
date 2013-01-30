//
//  LSCardViewController.m
//  Lystspillet
//
//  Created by Philip Nielsen on 25/11/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import "LSCardViewController.h"

@interface LSCardViewController () <UIGestureRecognizerDelegate>

@property (nonatomic) __block BOOL displayingPrimary;
@property (strong, nonatomic) IBOutlet UIButton *turnButton;

@end

@implementation LSCardViewController

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
    _displayingPrimary = YES;
    
//    UIImage *buttonImage = [[UIImage imageNamed:@"Button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 11, 0, 11)];
//    [_turnButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    
//    UIImage *buttonImagePushd = [[UIImage imageNamed:@"ButtonPushed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 11, 0, 11)];
//    [_turnButton setBackgroundImage:buttonImagePushd forState:UIControlStateHighlighted];
    
//    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:72/255.0 green:3/255.0 blue:141/255.0 alpha:1.0]];
    
    UIGestureRecognizer *swipeFront = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    swipeFront.delegate = self;
    [_frontView addGestureRecognizer:swipeFront];
    
    UIGestureRecognizer *swipeBack  = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    swipeBack.delegate = self;
    [_backView  addGestureRecognizer:swipeBack];
    
    UIGestureRecognizer *tapFront = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_frontView addGestureRecognizer:tapFront];
    
    UIGestureRecognizer *tapBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_backView addGestureRecognizer:tapBack];
    
//    _cardFrontImage.image = [UIImage imageNamed:_card.frontImageName];
//    _cardBackImage.image = [UIImage imageNamed:_card.backImageName];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint velocity = [recognizer velocityInView:(_displayingPrimary ? _frontView : _backView)];
    if(velocity.x > 0) {
        [self turnCardInDirection:UIViewAnimationOptionTransitionFlipFromLeft];
    } else {
        [self turnCardInDirection:UIViewAnimationOptionTransitionFlipFromRight];
    }
}

- (void)handleTap:(UIPanGestureRecognizer *)recognizer
{
    [self turnCard:nil];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint translation = [panGestureRecognizer translationInView:(_displayingPrimary ? _frontView : _backView)];
    return fabs(translation.x) > fabs(translation.y);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)turnCard:(id)sender
{
    [UIView transitionFromView:(_displayingPrimary ? _frontView : _backView)
                        toView:(_displayingPrimary ? _backView : _frontView)
                      duration:0.9
                       options:(_displayingPrimary ?
                                UIViewAnimationOptionTransitionFlipFromRight :
                                UIViewAnimationOptionTransitionFlipFromLeft)
                    completion:^(BOOL finished) {
                        if (finished) {
                            _displayingPrimary = !_displayingPrimary;
                        }
                    }
     ];
}

- (void)turnCardInDirection:(UIViewAnimationOptions)direction
{
    [UIView transitionFromView:(_displayingPrimary ? _frontView : _backView)
                        toView:(_displayingPrimary ? _backView : _frontView)
                      duration:0.9
                       options:direction
                    completion:^(BOOL finished) {
                        if (finished) {
                            _displayingPrimary = !_displayingPrimary;
                        }
                    }
     ];
}

@end
