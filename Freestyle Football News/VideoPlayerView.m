//
//  VideoPlayerView.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/30/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import "VideoPlayerView.h"

@interface VideoPlayerView ()

@end

@implementation VideoPlayerView

@synthesize playerView;
@synthesize videoURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    
    playerView=[[YTPlayerView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.width)];
    playerView.center=self.view.center;
    [self.view addSubview:playerView];
    playerView.delegate=self;
    [playerView loadWithVideoId:[videoURL substringFromIndex:videoURL.length-11]];
    UIButton *cancelButton=[[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x-40, playerView.frame.origin.y+playerView.frame.size.height+20, 80, 25)];
    [cancelButton setTitle:@"Hide" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
}

-(void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state{
//    
//    if(state==kYTPlayerStatePaused){
//        [self cancelAction];
//    }
    
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
