//
//  ShopItem.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 10/15/15.
//  Copyright © 2015 Uros Zivaljevic. All rights reserved.
//

#import "ShopItem.h"

@implementation ShopItem

-(instancetype)init{
    self=[super init];
    if(self){
        self.itemImages=[[NSMutableArray alloc] init];
    }
    return self;
}

@end
