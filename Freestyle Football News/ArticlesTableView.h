//
//  ArticlesTableView.h
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/19/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticlesModel.h"

@interface ArticlesTableView : UITableViewController<ObservableArticles>

@property (strong, nonatomic) ArticlesModel* articlesModel;
@property (strong, nonatomic) NSArray* articles;
@property (strong, nonatomic) NSMutableArray* articleImages;
@property (strong, nonatomic) UIActivityIndicatorView *loading;

@end
