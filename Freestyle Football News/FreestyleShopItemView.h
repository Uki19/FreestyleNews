//
//  FreestyleShopItemView.h
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 10/16/15.
//  Copyright © 2015 Uros Zivaljevic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopItem.h"

@interface FreestyleShopItemView : UIViewController <NSURLConnectionDataDelegate>

@property (strong, nonatomic) ShopItem *shopItem;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *sellerLabel;
@property (strong, nonatomic) UILabel *contactLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UITextView *descriptionView;
@property (strong, nonatomic) UIScrollView *shopScrollView;

@end
