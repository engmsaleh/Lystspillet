//
//  LSCategoryTableViewCell.h
//  Lystspillet
//
//  Created by Philip Nielsen on 22/11/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSCategoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitle;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UILabel *categoryDescription;


@end
