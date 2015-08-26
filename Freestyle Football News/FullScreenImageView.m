//
//  FullScreenImageView.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 8/26/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import "FullScreenImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TabBar.h"

@interface FullScreenImageView ()

@end

@implementation FullScreenImageView

@synthesize scrollView;
@synthesize imageView;
@synthesize image;


-(void)initScrollAndImageViews{
    
    scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-(self.navigationController.navigationBar.frame.size.height+20+self.tabBarController.tabBar.frame.size.height))];
   
    imageView=[[UIImageView alloc] initWithImage:image];
    
    [scrollView addSubview:imageView];
    [scrollView setContentSize:imageView.bounds.size];
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    CGFloat zoomScale;
    if(imageView.frame.size.width>imageView.frame.size.height)
        zoomScale=self.view.frame.size.width/imageView.frame.size.width;
    else
        zoomScale=self.view.frame.size.height/imageView.frame.size.height;
    scrollView.maximumZoomScale=2.0;
    scrollView.minimumZoomScale=self.view.frame.size.width/imageView.frame.size.width;
    [scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width/2,self.scrollView.frame.size.height/2)];
    scrollView.delegate=self;
    self.edgesForExtendedLayout=UIRectEdgeBottom;
    [self.view addSubview:scrollView];
    if([TabBar bannerIsVisible]){
        scrollView.contentInset=UIEdgeInsetsMake(0, 0, [TabBar adFrame].size.height, 0);
    }
    [scrollView setZoomScale:self.view.frame.size.width/imageView.frame.size.width];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Pinch to zoom";
    self.view.backgroundColor=[UIColor whiteColor];
    [self initScrollAndImageViews];
    self.view.backgroundColor=[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    // center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect frameToCenter = imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
    {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
    {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    } else {
        frameToCenter.origin.y = 0;
    }
    
    imageView.frame = frameToCenter;
    
}

@end
