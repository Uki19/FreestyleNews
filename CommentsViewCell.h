//
//  CommentsViewCell.h
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 10/6/15.
//  Copyright © 2015 Uros Zivaljevic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *CommentLabel;
@property (weak, nonatomic) IBOutlet UIView *authorBackground;
@property (weak, nonatomic) IBOutlet UIView *commentBackground;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;

@end
