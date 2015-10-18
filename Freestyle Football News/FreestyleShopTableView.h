//
//  FreestyleShopTableView.h
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 10/14/15.
//  Copyright © 2015 Uros Zivaljevic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FreestyleShopModel.h"

@interface FreestyleShopTableView : UITableViewController <UIAlertViewDelegate, ObservableShop>

@property (strong, nonatomic) FreestyleShopModel *model;
@property (strong, nonatomic) NSArray *shopItems;

@end
