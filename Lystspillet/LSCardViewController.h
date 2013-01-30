//
//  LSCardViewController.h
//  Lystspillet
//
//  Created by Philip Nielsen on 25/11/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface LSCardViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *frontView;
@property (strong, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) IBOutlet UIImageView *cardFrontImage;
@property (strong, nonatomic) IBOutlet UIImageView *cardBackImage;

@property (nonatomic, strong) Card *card;

@end
