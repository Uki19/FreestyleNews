//
//  NewsActivityIndicator.h
//  The Artball
//
//  Created by Uros Zivaljevic on 7/4/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsActivityIndicator : UIView

@property (strong, nonatomic) UIActivityIndicatorView *loading;
@property (strong, nonatomic) UILabel *loadingLabel;

-(void)startAnimating;
-(void)stopAnimating;

@end
