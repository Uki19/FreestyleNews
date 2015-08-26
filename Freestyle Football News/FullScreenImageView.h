//
//  FullScreenImageView.h
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 8/26/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullScreenImageView : UIViewController <UIScrollViewDelegate>

@property UIScrollView *scrollView;
@property UIImageView *imageView;
@property UIImage *image;

@end
