//
//  VideoPlayerView.h
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/30/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface VideoPlayerView : UIViewController <YTPlayerViewDelegate>

@property (strong, nonatomic) YTPlayerView *playerView;
@property (strong, nonatomic) NSString *videoURL;

@end
