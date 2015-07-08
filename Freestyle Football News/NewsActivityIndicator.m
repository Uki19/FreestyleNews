//
//  NewsActivityIndicator.m
//  The Artball
//
//  Created by Uros Zivaljevic on 7/4/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import "NewsActivityIndicator.h"

@implementation NewsActivityIndicator

@synthesize loading;
@synthesize loadingLabel;

-(instancetype)init{
    self=[super init];
    if(self){
        self.backgroundColor=[UIColor colorWithWhite:0.6 alpha:0.8];
        self.frame=CGRectMake(0, 0, 100,100);
        [self.layer masksToBounds];
        [self.layer setCornerRadius:10.0f];
        self.hidden=YES;
        loading=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        loading.center=self.center;
        loadingLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 10)];
        loadingLabel.text=@"Loading...";
        loadingLabel.font=[UIFont systemFontOfSize:14];
        [loadingLabel sizeToFit];
        loadingLabel.center=self.center;
        loadingLabel.frame=CGRectOffset(loadingLabel.frame, 0, 25);
        loadingLabel.textColor=[UIColor whiteColor];
        loading.frame=CGRectOffset(loading.frame, 0, -10);
        [self addSubview:loadingLabel];
        [self addSubview:loading];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)stopAnimating{
    self.hidden=YES;
    [loading stopAnimating];
}

-(void)startAnimating{
    self.hidden=NO;
    [loading startAnimating];
}
@end
