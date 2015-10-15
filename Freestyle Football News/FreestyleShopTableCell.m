//
//  FreestyleShopTableCell.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 10/15/15.
//  Copyright © 2015 Uros Zivaljevic. All rights reserved.
//

#import "FreestyleShopTableCell.h"

@implementation FreestyleShopTableCell

- (void)awakeFromNib {
    [self.backView setClipsToBounds:YES];
    self.backView.layer.cornerRadius=5.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
