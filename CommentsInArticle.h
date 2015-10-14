//
//  CommentsInArticle.h
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 10/13/15.
//  Copyright © 2015 Uros Zivaljevic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsInArticle : UIView

@property (weak, nonatomic) IBOutlet UILabel *commentAuthor;
@property (weak, nonatomic) IBOutlet UILabel *commentDate;
@property (weak, nonatomic) IBOutlet UITextView *commentContent;
@property (nonatomic, strong) UIView *containerView;


@end
