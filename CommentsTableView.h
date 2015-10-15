//
//  CommentsTableView.h
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 10/6/15.
//  Copyright © 2015 Uros Zivaljevic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsModel.h"

@interface CommentsTableView : UITableViewController <ObservableComments, NSURLConnectionDataDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSString *articleID;
@property (strong, nonatomic) NSArray *comments;
@property (strong, nonatomic) CommentsModel *model;
@property (strong, nonatomic) UIActivityIndicatorView *loading;
@property (strong, nonatomic) UILabel *noComments;
@property (strong, nonatomic) UITextField *commentAuthorTextField;
@property (strong, nonatomic) UITextView *commentTextView;
@property (strong, nonatomic) NSString *articleTitle;
@property BOOL addCommentsFlag;
@property BOOL commentsForArticle;

@end
