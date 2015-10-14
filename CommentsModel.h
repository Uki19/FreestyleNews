//
//  CommentsModel.h
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 10/6/15.
//  Copyright © 2015 Uros Zivaljevic. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ObservableComments <NSObject>

-(void)updateWithComments:(NSArray*)items;
-(void)failedToDownloadWithError:(NSError*) error;

@end

@interface CommentsModel : NSObject <NSURLConnectionDataDelegate>

@property id<ObservableComments> delegate;
@property (strong, nonatomic) NSMutableData *downloadedData;

-(void)downloadDataForArticleID:(NSString*)articleID;

@end
