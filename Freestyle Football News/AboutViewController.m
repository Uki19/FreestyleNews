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
    aboutTextView.contentInset=UIEdgeInsetsMake(0, 0, [TabBar adFrame].size.height, 0);
    NSString* aboutText=[NSString stringWithFormat:@"<a href='http://www.theartball.com/restorepurchase'>Welcome to The Artball!</a><img width='%f' src='http://theartball.com/images/logo-vodoravno.png' /> The Artball is application by freestylers for freestylers! <br> <br>It will help you stay in touch with the latest news and videos from the Freestyle Football world.<br> You will also be able to read great articles about trainings, equipment, freestyle thoughts and freestyle life in general. All articles are written by freestylers themselves. <br><br> Application is developed by: <br><br> Uros Zivaljevic from Serbia <br> Mario Plantosar from Croatia <br><br> If you are interested in helping The Artball by writing news, or you have article that you want to be published in application, please contact us on: <br><br> contact@theartball.com <br><br> Follow us on other social networks: <br><br><a href='https://instagram.com/theartball'><img width='%f' src='http://theartball.com/images/instagram-icon.png'></a><a href='https://www.facebook.com/theartball'><img width='%f' src='http://theartball.com/images/facebook-icon.png'/></a><a href='https://twitter.com/TheArtball'><img width='%f' src='http://theartball.com/images/twitter-icon.png'></a> <br><br><br>Open Source Libraries: <br><br> <u>DTCoreText by Cocoanetics </u><br><br><br> Copyright (c) 2011, Oliver Drobnik All rights reserved. <br><br> Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:<br><br>- Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.<br><br>- Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.<br><br> THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.<br><br><br><u>SDWebImage</u><br><br><br>Copyright (c) 2009 Olivier Poitrey <rs@dailymotion.com><br><br>Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:<br><br>The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.<br><br>THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.<br><br>",self.view.frame.size.width-10, self.view.frame.size.width/6-10,self.view.frame.size.width/6-10,self.view.frame.size.width/6-10];
    NSMutableAttributedString *htmlAboutText=[[NSMutableAttributedString alloc] initWithData:[aboutText dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    [htmlAboutText addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, htmlAboutText.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [htmlAboutText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(635, 40)];
    [htmlAboutText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, 1)];
    [htmlAboutText addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithRed:109.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:1] range:NSMakeRange(2034, htmlAboutText.length-2034)];
    [htmlAboutText addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithRed:109.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:1] range:NSMakeRange(727, 1294)];
    aboutTextView.attributedText=htmlAboutText;
//    aboutTextView.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    aboutTextView.backgroundColor=[UIColor colorWithRed:11.0/255.0 green:120.0/255.0 blue:228.0/255.0 alpha:1];
    aboutTextView.userInteractionEnabled=YES;
    aboutTextView.editable=NO;
    aboutTextView.delegate=self;
    aboutTextView.dataDetectorTypes=UIDataDetectorTypeLink;
    aboutTextView.linkTextAttributes=@{NSForegroundColorAttributeName:[UIColor yellowColor]};
    [self.view addSubview:aboutTextView];
}

-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    
    NSString *urlString=[NSString stringWithFormat:@"%@",URL];
    if([urlString isEqualToString:@"http://www.theartball.com/restorepurchase"]){
//        [(TabBar*)self.tabBarController restore];
        return NO;
    }
    else
        [[UIApplication sharedApplication] openURL:URL];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
   
}

@end
