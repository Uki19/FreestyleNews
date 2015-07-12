//
//  AboutViewController.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 7/13/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import "AboutViewController.h"
#import "TabBar.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

@synthesize aboutTextView;


-(void)initTextView{
    aboutTextView=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-(self.navigationController.navigationBar.frame.size.height+20+self.tabBarController.tabBar.frame.size.height))];
    if([TabBar bannerIsVisible])
        aboutTextView.contentInset=UIEdgeInsetsMake(0, 0, [TabBar adFrame].size.height, 0);
    aboutTextView.text=@"text \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n test";
    
    [self.view addSubview:aboutTextView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self initTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
   
}

@end
