//
//  ShopItem.h
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 10/15/15.
//  Copyright © 2015 Uros Zivaljevic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopItem : NSObject

@property (nonatomic, strong) NSString *itemTitle;
@property (strong, nonatomic) NSString *itemDescription;
@property (strong, nonatomic) NSString *itemPrice;
@property (strong, nonatomic) NSString *itemContact;
@property (strong, nonatomic) NSMutableArray *itemImages;
@property (strong, nonatomic) NSString *itemSeller;

@end
