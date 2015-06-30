//
//  NewsCell.h
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/17/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *category;
@property (strong, nonatomic) UIImageView *newsImage;
@property (strong, nonatomic) NSString *imageLocation;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;


-(void)reloadLabels;

@end
