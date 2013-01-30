//
//  LSCollectionViewCardCell.h
//  Lystspillet
//
//  Created by Philip Nielsen on 24/11/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSCollectionViewCardCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *frontView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UITextView *frontTextView;
@property (weak, nonatomic) IBOutlet UILabel *cardType;
@property (weak, nonatomic) IBOutlet UIImageView *frontFrame;
@property (weak, nonatomic) IBOutlet UIImageView *frontImage;

@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *backFrame;
@property (weak, nonatomic) IBOutlet UILabel *detailedQuestionsHeader;
@property (weak, nonatomic) IBOutlet UILabel *quizHeader;
@property (weak, nonatomic) IBOutlet UILabel *answerHeader;
@property (weak, nonatomic) IBOutlet UILabel *didYouKnowHeader;
@property (weak, nonatomic) IBOutlet UITextView *detailedQuestionTextView;
@property (weak, nonatomic) IBOutlet UITextView *quizTextView;
@property (weak, nonatomic) IBOutlet UITextView *answerTextView;
@property (weak, nonatomic) IBOutlet UITextView *didYouKnowTextView;
@property (weak, nonatomic) IBOutlet UIView *primaryContentView;
@property (weak, nonatomic) IBOutlet UIImageView *primaryContentFrame;

@property (weak, nonatomic) IBOutlet UIView *moreInfoView;
@property (weak, nonatomic) IBOutlet UILabel *moreInfoHeader;
@property (weak, nonatomic) IBOutlet UITextView *moreInfoTextView;
@property (weak, nonatomic) IBOutlet UIImageView *moreInfoFrame;

@property (weak, nonatomic) IBOutlet UILabel *cardReferenceNumber;

- (void)layoutCollectionViewCardCell;

@end
