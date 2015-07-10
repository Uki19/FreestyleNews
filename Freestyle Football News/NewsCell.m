//
//  NewsCell.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/17/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

@synthesize title;
@synthesize category;
@synthesize newsImage;
@synthesize imageLocation;
@synthesize gradientLayer;

-(instancetype)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    if(self){
        
        category=[[UILabel alloc] initWithFrame:CGRectMake(2, 2, self.frame.size.width, 30)];
        category.textColor=[UIColor whiteColor];
        category.textAlignment=NSTextAlignmentCenter;
        newsImage=[[UIImageView alloc] initWithFrame:self.bounds];
    
        
//        [self addSubview:category];
        [newsImage setContentMode:UIViewContentModeScaleAspectFill];
        [newsImage setClipsToBounds:YES];
       
     
        title=[[UILabel alloc] initWithFrame:CGRectMake(2, self.frame.size.height, self.frame.size.width, 100)];
        
//        [title setShadowColor:[UIColor blackColor]];
//        [title setShadowOffset:CGSizeMake(1, 1)];
        title.textColor=[UIColor whiteColor];
        title.lineBreakMode=NSLineBreakByTruncatingTail;
        title.numberOfLines=0;
        title.frame=CGRectOffset(title.frame, 0, -title.frame.size.height);
        gradientLayer = [CAGradientLayer layer];
        self.backgroundView=newsImage;
        gradientLayer.frame = self.bounds;
        gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor]CGColor],(id)[[UIColor colorWithWhite:0.0f alpha:0.4f]CGColor], (id)[[UIColor blackColor]CGColor], nil];
        gradientLayer.locations=@[@0.50,@0.60,@1.0];
        [self.layer insertSublayer:gradientLayer atIndex:1];
        [self addSubview:title];

    }
    return self;
}

#pragma mark - Position title labels properly

-(void)reloadLabels{
    title.frame=CGRectMake(10, self.frame.size.height, self.frame.size.width-10, 100);
    [category sizeToFit];
    [title sizeToFit];
    title.frame=CGRectOffset(title.frame, 0, -title.frame.size.height-10);
    title.frame=CGRectMake(10, title.frame.origin.y, self.frame.size.width-10, title.frame.size.height);
    category.frame=CGRectMake(10, title.frame.origin.y-20, category.frame.size.width+10, 20);
    category.backgroundColor=[UIColor orangeColor];
//  title.textAlignment=NSTextAlignmentCenter;
    [self.title setTextColor:[UIColor whiteColor]];
    
}


@end
