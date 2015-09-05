//
//  TabBar.h
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/18/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <StoreKit/StoreKit.h>



@interface TabBar : UITabBarController <ADBannerViewDelegate, SKPaymentTransactionObserver,SKProductsRequestDelegate>{
    BOOL areAdsRemoved;
}

@property (strong, nonatomic) NSMutableArray *normalImages;
@property (strong, nonatomic) NSMutableArray *selectedImages;
@property (strong, nonatomic) ADBannerView  *adView;
@property (strong, nonatomic) SKProduct *product;
@property (strong, nonatomic) NSString *productID;
@property (strong, nonatomic) NSString *productTitle;
@property (strong, nonatomic) NSString *productDescription;



+(CGRect)adFrame;
+(BOOL)bannerIsVisible;
-(void)restore;

@end
