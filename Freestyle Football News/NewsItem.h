//
//  NewsItem.h
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/17/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsItem : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *newsID;
@property BOOL important;


@end
