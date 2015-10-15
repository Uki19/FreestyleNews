//
//  FreestyleShopTableCell.h
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 10/15/15.
//  Copyright © 2015 Uros Zivaljevic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreestyleShopTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellerLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
