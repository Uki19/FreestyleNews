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

static CGRect adFrame;

static BOOL bannerIsVisible;

@interface TabBar ()

@end

@implementation TabBar

@synthesize normalImages;
@synthesize selectedImages;

@synthesize adView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *navs=[[NSMutableArray alloc] init];
    
    normalImages=[[NSMutableArray alloc] init];
    selectedImages=[[NSMutableArray alloc] init];
    
    
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

    adView = [[ADBannerView alloc] initWithFrame:self.tabBar.frame];
    adFrame=adView.frame;

    adView.delegate = self;
    bannerIsVisible = NO;
    
    [self.view addSubview:adView];
    [self.view bringSubviewToFront:self.tabBar];
    
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
//        self.newsView.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        [UIView commitAnimations];
        bannerIsVisible = NO;
         [[NSNotificationCenter defaultCenter] postNotificationName:@"adFailedToLoad" object:nil];
        NSLog(@"FAILED TO LOAD iADs");
        
    }
}

- (NSUInteger)supportedInterfaceOrientations{
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

@end
