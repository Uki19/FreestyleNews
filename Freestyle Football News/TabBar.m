//
//  TabBar.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/18/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import "TabBar.h"
#import "ViewController.h"
#import "Navigation.h"
#import "ArticlesTableView.h"
#import "ArchiveTableView.h"
#import "AboutViewController.h"
#import "FreestyleShopTableView.h"


static CGRect adFrame;

static BOOL bannerIsVisible;

@interface TabBar ()

@property (strong,nonatomic) UIView *removeAdsView;
@property (strong, nonatomic) NewsActivityIndicator *loading;

@end

@implementation TabBar

@synthesize normalImages;
@synthesize selectedImages;
@synthesize removeAdsView;
//@synthesize product;
@synthesize productID;
@synthesize productDescription;
@synthesize productTitle;
@synthesize loading;

@synthesize adView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *navs=[[NSMutableArray alloc] init];
    
    normalImages=[[NSMutableArray alloc] init];
    selectedImages=[[NSMutableArray alloc] init];
    loading=[[NewsActivityIndicator alloc] init];
    loading.center=self.view.center;
    [self.view addSubview:loading];
    
    [self.tabBar setBarTintColor:[UIColor  colorWithRed:11.0/255.0 green:120.0/255.0 blue:228.0/255.0 alpha:1]];
    [self.tabBar setTintColor:[UIColor whiteColor]];
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0 green:154.0/255.0 blue:1 alpha:1],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [self.tabBar setTranslucent:NO];
    
    ViewController *home=[[ViewController alloc] init];
    home.title=@"Home";
    Navigation *navigationView=[[Navigation alloc] initWithRootViewController:home];
    [navs addObject:navigationView];
    navigationView=nil;
    [normalImages addObject:[[UIImage imageNamed:@"home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [selectedImages addObject:[[UIImage imageNamed:@"home-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

   
    ArticlesTableView *articles=[[ArticlesTableView alloc] init];
    articles.title=@"Articles";
    navigationView=[[Navigation alloc] initWithRootViewController:articles];
    [navs addObject:navigationView];
    navigationView=nil;
    [normalImages addObject:[[UIImage imageNamed:@"article"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [selectedImages addObject:[[UIImage imageNamed:@"article-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    FreestyleShopTableView *freestyleShop=[[FreestyleShopTableView alloc] init];
    freestyleShop.title=@"Shop";
    navigationView=[[Navigation alloc] initWithRootViewController:freestyleShop];
    [navs addObject:navigationView];
    navigationView=nil;
    [normalImages addObject:[[UIImage imageNamed:@"shop"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [selectedImages addObject:[[UIImage imageNamed:@"shop-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    AboutViewController *about=[[AboutViewController alloc] init];
    about.title=@"About";
    navigationView=[[Navigation alloc] initWithRootViewController:about];
    [navs addObject:navigationView];
    navigationView=nil;
    [normalImages addObject:[[UIImage imageNamed:@"about"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [selectedImages addObject:[[UIImage imageNamed:@"about-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
  
    
    [self setViewControllers:navs animated:YES];
    
    for (UITabBarItem* tabItem in self.tabBar.items) {
        [tabItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:128.0/255.0 green:204.0/255.0 blue:1 alpha:1],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
        [tabItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        [tabItem setImage:[normalImages objectAtIndex:[self.tabBar.items indexOfObject:tabItem]]];
        [tabItem setSelectedImage:[selectedImages objectAtIndex:[self.tabBar.items indexOfObject:tabItem]]];
    }

//    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    //this will load wether or not they bought the in-app purchase
    
    
    
    adView = [[ADBannerView alloc] initWithFrame:self.tabBar.frame];
    adFrame=adView.frame;

    adView.delegate = self;
    bannerIsVisible = NO;
//    removeAdsView=[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100, adFrame.origin.y, 100, 20)];
//    removeAdsView.backgroundColor=[UIColor blackColor];
//    UILabel *removeAdLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
//    removeAdLabel.text=@"Remove Ads";
//    removeAdLabel.font=[UIFont systemFontOfSize:14];
//    removeAdLabel.textAlignment=NSTextAlignmentCenter;
//    [removeAdsView addSubview:removeAdLabel];
//    removeAdLabel.textColor=[UIColor whiteColor];
//    [self.view addSubview:removeAdsView];
    [self.view addSubview:adView];
//    if(areAdsRemoved){
//        adView.delegate=nil;
//        [adView removeFromSuperview];
//        [removeAdsView removeFromSuperview];
//    }
    [self.view bringSubviewToFront:self.tabBar];
//    UITapGestureRecognizer *tapRemoveAds=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeAdsAction)];
//    [removeAdsView addGestureRecognizer:tapRemoveAds];
}



+(CGRect)adFrame{
    return adFrame;
}

+(BOOL)bannerIsVisible{
    return bannerIsVisible;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
    if (!bannerIsVisible) {
        
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, -adView.frame.size.height);
        removeAdsView.frame=CGRectOffset(removeAdsView.frame, 0, -adView.frame.size.height-20);
        [UIView commitAnimations];
        bannerIsVisible = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"adIsLoaded" object:nil];
//        self.newsView.frame=CGRectMake(0, 0, self.newsView.frame.size.width, self.newsView.frame.size.height-adView.frame.size.height);
        
        NSLog(@"LOADED iADs");
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    
    if (bannerIsVisible) {
        
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, adView.frame.size.height);
        removeAdsView.frame=CGRectOffset(removeAdsView.frame, 0, adView.frame.size.height+20);
//        self.newsView.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        [UIView commitAnimations];
        bannerIsVisible = NO;
         [[NSNotificationCenter defaultCenter] postNotificationName:@"adFailedToLoad" object:nil];
        NSLog(@"FAILED TO LOAD iADs");
        
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - In App Purchase

//-(void)removeAdsAction{
////    [loading startAnimating];
//    productID=@"theartball.removeAdBanner";
//    if([SKPaymentQueue canMakePayments]){
//        SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:productID]];
//        request.delegate=self;
//        [request start];
//    }
//}
//
//-(void)buyAction{
////    [loading stopAnimating];
//    SKPayment *payment=[SKPayment paymentWithProduct:product];
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//    [[SKPaymentQueue defaultQueue] addPayment:payment];
//    
//}
//
//-(void)restore{
//    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
//}
//
//#pragma mark _
//#pragma mark SKProductsRequestDelegate
//
//-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
//
//    NSArray *products=response.products;
//    if(products.count !=0){
//        product=products[0];
//        productTitle=product.localizedTitle;
//        productDescription=product.localizedDescription;
//    }
//    [self buyAction];
//}
//
//-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
//    for (SKPaymentTransaction *transaction in transactions) {
//        switch (transaction.transactionState) {
//            case SKPaymentTransactionStatePurchased:
//                [self removeAdBanner];
//                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//                break;
//            case SKPaymentTransactionStateRestored:
//                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//                break;
//                
//            default:
//                
//                break;
//        }
//    }
//}
//
//-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
//
//    for(SKPaymentTransaction *transaction in queue.transactions){
//        if(transaction.transactionState == SKPaymentTransactionStateRestored){
//        
//            [self removeAdBanner];
//            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//            break;
//        }
//    }
//}
//
//-(void)removeAdBanner{
//    adView.hidden=YES;
//    bannerIsVisible=NO;
//    areAdsRemoved=YES;
//    [adView removeFromSuperview];
//    [removeAdsView removeFromSuperview];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"adFailedToLoad" object:nil];
//    [[NSUserDefaults standardUserDefaults] setBool:areAdsRemoved forKey:@"areAdsRemoved"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

@end
