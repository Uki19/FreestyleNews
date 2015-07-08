//
//  Navigation.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/18/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import "Navigation.h"

@interface Navigation ()

@end

@implementation Navigation



-(void)initNavigationBar{
    
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationBar.barTintColor=[UIColor colorWithRed:11.0/255.0 green:120.0/255.0 blue:228.0/255.0 alpha:1];
    self.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
//    [self.navigationBar setTranslucent:NO];
    self.navigationBar.translucent = NO; 
//    UIBarButtonItem *backBtn=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    [self.navigationController.navigationItem setBackBarButtonItem:backBtn];
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjects:@[[UIFont fontWithName:@"HelveticaNeue-Thin" size:18]] forKeys:@[NSFontAttributeName]] forState:UIControlStateNormal];
    
    for (UIView *view in self.navigationBar.subviews) {
        for (UIView *view2 in view.subviews) {
            if ([view2 isKindOfClass:[UIImageView class]]) {
                [view2 removeFromSuperview];
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
