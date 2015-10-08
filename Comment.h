//
//  Comment.h
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 10/6/15.
//  Copyright © 2015 Uros Zivaljevic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) NSString *date;

@end
