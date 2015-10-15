//
//  FreestyleShopModel.h
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 10/15/15.
//  Copyright © 2015 Uros Zivaljevic. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ObservableShop <NSObject>

-(void)updateWithItems:(NSArray*)items;
-(void)failedToDownloadWithError:(NSError*) error;

@end

@interface FreestyleShopModel : NSObject <NSURLConnectionDataDelegate>

@property id<ObservableShop> delegate;
@property (strong, nonatomic) NSMutableData *downloadedData;

-(void)downloadData;


@end
