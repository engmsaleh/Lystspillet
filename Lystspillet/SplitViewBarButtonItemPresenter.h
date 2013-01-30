//
//  SplitViewBarButtonItemPresenter.h
//  FOLD
//
//  Created by Philip Nielsen on 03/04/12.
//  Copyright (c) 2012 Netcompany A/S. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SplitViewBarButtonItemPresenter <NSObject>
@property (nonatomic, strong) UIBarButtonItem *splitViewBarButtonItem;
@end