//
//  LSCategoryViewController.h
//  Lystspillet
//
//  Created by Philip Nielsen on 29/12/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"
#import "LSCardCollectionViewController.h"
#import "LSCategoryTableViewController.h"

@interface LSCategoryViewController : UIViewController <SplitViewBarButtonItemPresenter, LSCategoryTableViewControllerDelegate, LSCardCollectionViewPageControlDelegate>

@property (weak, nonatomic) IBOutlet UIView *cardContainer;
@property (nonatomic, strong) NSURL *browserURL;
@property (nonatomic, strong) Category *category;
@property (weak, nonatomic) IBOutlet UIView *startView;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UITextView *aboutWelcome;
@property (weak, nonatomic) IBOutlet UIView *arrowStartView;
@property (weak, nonatomic) IBOutlet UIImageView *helpImage;

@property (nonatomic) BOOL displayingModal;

@end
