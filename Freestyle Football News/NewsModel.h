//
//  NewsModel.h
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/17/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Observable <NSObject>

-(void)updateWithItems:(NSArray*)items;
-(void)failedToDownloadWithError:(NSError*) error;

@end

@interface NewsModel : NSObject <NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSMutableData *downloadedData;
@property (strong, nonatomic) id<Observable> delegate;

-(void) downloadDataAtUrl:(NSString*) url;


@end
