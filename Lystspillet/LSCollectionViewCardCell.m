//
//  LSCollectionViewCardself.m
//  Lystspillet
//
//  Created by Philip Nielsen on 24/11/12.
//  Copyright (c) 2012 Philip Nielsen. All rights reserved.
//

#import "LSCollectionViewCardCell.h"
#import "UITextView+Resize.h"
#import "UIView+Distance.h"

@implementation LSCollectionViewCardCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutCollectionViewCardCell
{
    // Front text view --------------------------------------------------------------------------------------------------------------------------
    
    [self.frontTextView setFont:[UIFont fontWithName:@"Helsinki" size:self.frontTextView.font.pointSize]];
    
    [self.frontTextView sizeFontToFitWithMinFontSize:10 andMaxFontSize:75];
    
    
    // Back text view ---------------------------------------------------------------------------------------------------------------------------
    
    [self.detailedQuestionsHeader setFont:[UIFont fontWithName:@"Helsinki" size:self.detailedQuestionsHeader.font.pointSize]];
    [self.quizHeader setFont:[UIFont fontWithName:@"Helsinki" size:self.quizHeader.font.pointSize]];
    [self.answerHeader setFont:[UIFont fontWithName:@"Helsinki" size:self.answerHeader.font.pointSize]];
    [self.didYouKnowHeader setFont:[UIFont fontWithName:@"Helsinki" size:self.didYouKnowHeader.font.pointSize]];
    [self.moreInfoHeader setFont:[UIFont fontWithName:@"Helsinki" size:self.moreInfoHeader.font.pointSize]];
    
    int distanceBetweenHeaderAndTextView = self.detailedQuestionTextView.frame.origin.y - (self.detailedQuestionsHeader.frame.origin.y + self.detailedQuestionsHeader.frame.size.height);
    
    [self.detailedQuestionTextView sizeToFitForMaxHeight:self.detailedQuestionTextView.contentSize.height];
    [self.quizHeader allignToAboveView:self.detailedQuestionTextView forDistance:5];
    [self.quizTextView allignToAboveView:self.quizHeader forDistance:distanceBetweenHeaderAndTextView];
    [self.quizTextView sizeToFitForMaxHeight:self.quizTextView.contentSize.height];
    [self.answerHeader allignToAboveView:self.quizTextView forDistance:5];
    [self.answerTextView allignToAboveView:self.answerHeader forDistance:distanceBetweenHeaderAndTextView];
    [self.answerTextView sizeToFitForMaxHeight:self.answerTextView.contentSize.height];
    [self.didYouKnowHeader allignToAboveView:self.answerTextView forDistance:5];
    [self.didYouKnowTextView allignToAboveView:self.didYouKnowHeader forDistance:distanceBetweenHeaderAndTextView];
    [self.didYouKnowTextView sizeToFitForMaxHeight:self.didYouKnowTextView.contentSize.height];
    
    UITextView *lowestVisibleTextView = self.didYouKnowTextView;
    
    if (self.didYouKnowTextView.alpha == 0) {
        [self.didYouKnowHeader setAlpha:0.0];
        lowestVisibleTextView = self.answerTextView;
        
        if (self.answerTextView.alpha == 0) {
            [self.answerHeader setAlpha:0.0];
            lowestVisibleTextView = self.quizTextView;
            
            if (self.quizTextView.alpha == 0) {
                [self.quizHeader setAlpha:0.0];
                lowestVisibleTextView = self.detailedQuestionTextView;
            }
        }
    } else {
        [self.didYouKnowHeader setAlpha:1.0];
        
        if (self.answerTextView.alpha > 0) {
            [self.answerHeader setAlpha:1.0];
            
            if (self.quizTextView.alpha > 0) {
                [self.quizHeader setAlpha:1.0];
            }
        }
    }
    
    // Fit view to fit content
    [self.primaryContentView setFrame:
     CGRectMake(
                self.primaryContentView.frame.origin.x,
                self.primaryContentView.frame.origin.y,
                self.primaryContentView.frame.size.width,
                (lowestVisibleTextView.frame.origin.y + lowestVisibleTextView.frame.size.height) + 10
    )];

    // Vertically center primary view for 'Opvarming' category
    if (lowestVisibleTextView == self.detailedQuestionTextView) {
        [self.primaryContentView setCenter:CGPointMake(self.primaryContentView.frame.origin.x + self.primaryContentView.frame.size.width / 2, self.backScrollView.frame.size.height / 2)];
    } else {
        [self.primaryContentView setFrame:CGRectMake(20, 20, self.primaryContentView.frame.size.width, self.primaryContentView.frame.size.height)];
    }
    
    // Fit frame to content
    [self.primaryContentFrame setFrame:
     CGRectMake(
                self.primaryContentView.frame.origin.x - 15,
                self.primaryContentView.frame.origin.y - 15,
                self.primaryContentView.frame.size.width + 30,
                self.primaryContentView.frame.size.height + 20
    )];
    
    
    float bottomOfPrimaryView = self.primaryContentView.frame.origin.y + self.primaryContentView.frame.size.height + 20;
    
    if (self.backScrollView.frame.size.height < bottomOfPrimaryView) {
        [self.backScrollView setContentSize:CGSizeMake(self.backScrollView.frame.size.width, bottomOfPrimaryView)];
    } else {
        [self.backScrollView setContentSize:CGSizeMake(self.backScrollView.frame.size.width, self.backScrollView.frame.size.height + 1)];
    }
    
    // Set up appearance for "More Info"
    if (self.moreInfoView.alpha > 0.0) {
        // Fit view to fit content
        
        [self.moreInfoTextView sizeToFitForMaxHeight:self.moreInfoTextView.contentSize.height];
        
        [self.moreInfoView setFrame:
         CGRectMake(
                    self.moreInfoView.frame.origin.x, // Keep X
                    self.primaryContentView.frame.origin.y + self.primaryContentView.frame.size.height + 35,
                    self.moreInfoView.frame.size.width,
                    (self.moreInfoTextView.frame.origin.y + self.moreInfoTextView.frame.size.height) + 10
                    )];
        
        // Fit frame to content
        [self.moreInfoFrame setFrame:
         CGRectMake(
                    self.moreInfoView.frame.origin.x - 15,
                    self.moreInfoView.frame.origin.y - 15,
                    self.moreInfoView.frame.size.width + 30,
                    self.moreInfoView.frame.size.height + 20)];
        
        float bottomOfPrimaryView = self.moreInfoView.frame.origin.y + self.moreInfoView.frame.size.height + 20;
        if (self.backScrollView.frame.size.height < bottomOfPrimaryView) {
            //        NSLog(@"Content bigger than scrollview");
            [self.backScrollView setContentSize:CGSizeMake(self.backScrollView.frame.size.width, bottomOfPrimaryView)];
        } else {
            //        NSLog(@"Content smaller than scrollview");
            [self.backScrollView setContentSize:CGSizeMake(self.backScrollView.frame.size.width, self.backScrollView.frame.size.height + 1)];
        }
        
    }

}

@end
