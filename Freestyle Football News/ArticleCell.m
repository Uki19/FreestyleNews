//
//  ArticleCell.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/19/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import "ArticleCell.h"

@implementation ArticleCell

@synthesize articleAuthor;
@synthesize articleImage;
@synthesize articleTitle;
@synthesize backView;

- (void)awakeFromNib {
    CALayer* l=articleImage.layer;
    [l setMasksToBounds:YES];
    //[l setCornerRadius:10.0f];
    
    CALayer* b=backView.layer;
    [b setMasksToBounds:YES];
    //[b setCornerRadius:10.0f];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
