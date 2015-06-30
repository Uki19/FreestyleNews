//
//  ArchiveTableView.h
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/22/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

@interface ArchiveTableView : UITableViewController <Observable, UISearchDisplayDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NewsModel *newsModel;
@property (strong, nonatomic) NSArray *downloadedData;
@property (strong, nonatomic) NSString *databaseURL;
@property (strong, nonatomic) NSString *articleTitle;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) UIActivityIndicatorView *loading;
@property (strong, nonatomic) UISearchDisplayController *search;


@end
