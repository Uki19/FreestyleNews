//
//  CommentsViewCell.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 10/6/15.
//  Copyright © 2015 Uros Zivaljevic. All rights reserved.
//

#import "CommentsViewCell.h"

@implementation CommentsViewCell

@synthesize backgroundView;

- (void)awakeFromNib {
    
    [backgroundView.layer setMasksToBounds:YES];
    [backgroundView.layer setCornerRadius:4.0];
    self.backgroundView.layer.borderColor=[UIColor colorWithWhite:0.73 alpha:1].CGColor;
    self.backgroundView.layer.borderWidth=1.0;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
