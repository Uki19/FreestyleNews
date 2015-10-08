//
//  ViewController.h
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/17/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "NewsModel.h"
#import "NewsActivityIndicator.h"


@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, Observable, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>


@property (strong, nonatomic) UICollectionView *newsView;
@property (strong, nonatomic) NSArray *news;
@property (strong, nonatomic) NewsModel *newsModel;
@property (strong, nonatomic) NSString *databaseURL;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NewsActivityIndicator *loading;
@property (strong, nonatomic) UISegmentedControl *segment;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGestureLeft;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGestureRight;

@end

