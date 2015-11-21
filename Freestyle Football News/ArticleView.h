//
//  ArticleView.h
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/19/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "DTCoreText.h"
#import "YTPlayerView.h"
#import "NewsItem.h"
#import "CommentsModel.h"
#import "Comment.h"

@protocol ChangeListener <NSObject>

-(void)setChanged:(BOOL)changed;

@end

@interface ArticleView : UIViewController <DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate, NSURLConnectionDataDelegate, ObservableComments, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id<ChangeListener> changeDelegate;

@property (strong, nonatomic) NewsItem* item;
@property (strong, nonatomic) UIScrollView *articleScrollView;
@property (strong, nonatomic) UILabel *articleTitleLabel;
@property (strong, nonatomic) UILabel *articleAuthorLabel;
@property (strong, nonatomic) DTAttributedTextContentView *articleContentTextView;
@property (strong, nonatomic) UIImage *authorImage;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *numberCommentsLabel;
@property (strong, nonatomic) CommentsModel *commentsModel;
@property (strong, nonatomic) NSArray *comments;
@property (strong, nonatomic) UITableView *commentsView;

@end
