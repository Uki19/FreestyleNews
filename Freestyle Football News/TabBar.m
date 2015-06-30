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

@interface TabBar ()

@end

@implementation TabBar

@synthesize normalImages;
@synthesize selectedImages;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *navs=[[NSMutableArray alloc] init];
    
    normalImages=[[NSMutableArray alloc] init];
    selectedImages=[[NSMutableArray alloc] init];
    
    
    [self.tabBar setBarTintColor:[UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:1 alpha:1]];
    [self.tabBar setTintColor:[UIColor whiteColor]];
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
//    [self.tabBar setTranslucent:NO];
    
    ViewController *home=[[ViewController alloc] init];
    home.title=@"Home";
    Navigation *navigationView=[[Navigation alloc] initWithRootViewController:home];
    [navs addObject:navigationView];
    navigationView=nil;
    [normalImages addObject:[[UIImage imageNamed:@"home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [selectedImages addObject:[[UIImage imageNamed:@"home-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
  
//    ViewController *competitions=[[ViewController alloc] init];
//    competitions.title=@"Competitions";
//    navigationView=[[Navigation alloc] initWithRootViewController:competitions];
//    [navs addObject:navigationView];
//    navigationView=nil;
//    [normalImages addObject:[[UIImage imageNamed:@"trophy"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [selectedImages addObject:[[UIImage imageNamed:@"trophy-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//
//    
//    ViewController *videos=[[ViewController alloc] init];
//    videos.title=@"Videos";
//    navigationView=[[Navigation alloc] initWithRootViewController:videos];
//    [navs addObject:navigationView];
//    navigationView=nil;
//    [normalImages addObject:[[UIImage imageNamed:@"video"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [selectedImages addObject:[[UIImage imageNamed:@"video-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    
   
    ArticlesTableView *articles=[[ArticlesTableView alloc] init];
    articles.title=@"Articles";
    navigationView=[[Navigation alloc] initWithRootViewController:articles];
    [navs addObject:navigationView];
    navigationView=nil;
    [normalImages addObject:[[UIImage imageNamed:@"article"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [selectedImages addObject:[[UIImage imageNamed:@"article-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//   
//    ViewController *other=[[ViewController alloc] init];
//    other.title=@"Other";
//    navigationView=[[Navigation alloc] initWithRootViewController:other];
//    [navs addObject:navigationView];
//    navigationView=nil;
//    [normalImages addObject:[[UIImage imageNamed:@"other"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [selectedImages addObject:[[UIImage imageNamed:@"other-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
  
    
    [self setViewControllers:navs animated:YES];
    
    for (UITabBarItem* tabItem in self.tabBar.items) {
        [tabItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:29.0/255.0 green:85.0/255.0 blue:143.0/255.0 alpha:1],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
        [tabItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        [tabItem setImage:[normalImages objectAtIndex:[self.tabBar.items indexOfObject:tabItem]]];
        [tabItem setSelectedImage:[selectedImages objectAtIndex:[self.tabBar.items indexOfObject:tabItem]]];
    }
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
