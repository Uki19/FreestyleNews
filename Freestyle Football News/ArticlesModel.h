//
//  ArticlesModel.h
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/19/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ObservableArticles <NSObject>

-(void)updateWithItems:(NSArray*)items;
-(void)failedToDownloadWithError:(NSError*)error;

@end

@interface ArticlesModel : NSObject <NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSMutableData *downloadedData;
@property (strong, nonatomic) id<ObservableArticles> delegate;

-(void)downloadData;

@end
