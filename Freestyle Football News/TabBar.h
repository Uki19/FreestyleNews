//
//  TabBar.h
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/18/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface TabBar : UITabBarController <ADBannerViewDelegate>

@property (strong, nonatomic) NSMutableArray *normalImages;
@property (strong, nonatomic) NSMutableArray *selectedImages;
@property (strong, nonatomic) ADBannerView  *adView;

+(CGRect)adFrame;
+(BOOL)bannerIsVisible;

@end
