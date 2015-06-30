//
//  ArticleCell.h
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/19/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *articleImage;
@property (weak, nonatomic) IBOutlet UILabel *articleAuthor;
@property (weak, nonatomic) IBOutlet UILabel *articleTitle;
@property (weak, nonatomic) IBOutlet UIView *backView;



@end
