//
//  LSCategoryTableViewCell.m
//  Lystspillet
//
//  Created by Philip Nielsen on 22/11/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import "LSCategoryTableViewCell.h"

@interface LSCategoryTableViewCell()



@end

@implementation LSCategoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _infoButton.selected = NO;
    // If you don't set highlighted to NO in this method,
    // for some reason it'll be highlighed while the
    // table cell selection animates out
    _infoButton.highlighted = NO;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    _infoButton.highlighted = NO;
}

@end
