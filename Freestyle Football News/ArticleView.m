//
//  ArticleView.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/19/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import "ArticleView.h"
#import "DTCoreText.h"
#import "DTTiledLayerWithoutFade.h"
#import "ViewController.h"
#import "TabBar.h"
#import "FullScreenImageView.h"
#import "CommentsTableView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ArticleView ()

@property NSMutableArray *articleImages;
@property UIView* articleContentBackground;
@property NSMutableData* refreshData;
@property UIView *borderBottom;
@property NSString *brojKomentara;

@end

@implementation ArticleView


@synthesize articleTitleLabel;
@synthesize articleScrollView;
@synthesize articleAuthorLabel;
@synthesize articleContentTextView;
@synthesize authorImage;
@synthesize item;
@synthesize dateLabel;
@synthesize brojKomentara;
@synthesize numberCommentsLabel;



-(void)addRadius:(CALayer*)layer angle:(CGFloat)angle{
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:angle];
}

-(void)initNavbarButtons{
    UIBarButtonItem *refreshButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(refreshArticle)];
    UIImage *ci=[UIImage imageNamed:@"comments"];
    UIButton *imageComments=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, ci.size.width, ci.size.height)];
    [imageComments setBackgroundImage:ci forState:UIControlStateNormal];
    numberCommentsLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, imageComments.frame.size.width-20, imageComments.frame.size.height-20)];
    numberCommentsLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:12];
    numberCommentsLabel.textColor=[UIColor whiteColor];
    [numberCommentsLabel sizeToFit];
    numberCommentsLabel.center=imageComments.center;
    numberCommentsLabel.frame=CGRectOffset(numberCommentsLabel.frame, 0, -2);
    [imageComments addSubview:numberCommentsLabel];
    imageComments.frame=CGRectOffset(imageComments.frame, 10, 0);
    UIBarButtonItem *commentsButton=[[UIBarButtonItem alloc] initWithCustomView:imageComments];
    [imageComments addTarget:self action:@selector(openComments) forControlEvents:UIControlEventTouchUpInside];
    if(item.category)
       self.navigationItem.rightBarButtonItems=@[refreshButton,commentsButton];
    else
        self.navigationItem.rightBarButtonItem=commentsButton;
}

#pragma mark - Title, category, date and author text init

-(void)initArticleTitle{
    
    self.articleContentBackground=[[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 0)];
    self.articleContentBackground.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
    [self addRadius:self.articleContentBackground.layer angle:10];
    [articleScrollView addSubview:self.articleContentBackground];
    articleTitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 20, self.view.frame.size.width-30, 300)];
    articleTitleLabel.font=[UIFont boldSystemFontOfSize:28];
    articleTitleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    articleTitleLabel.numberOfLines=0;
    articleTitleLabel.text=item.title;
    [articleTitleLabel sizeToFit];
    CGRect titleFrame=articleTitleLabel.frame;
    self.borderBottom=[[UIView alloc] initWithFrame:CGRectMake(15, titleFrame.size.height+titleFrame.origin.y+10, self.view.frame.size.width-30, 1)];
    self.borderBottom.backgroundColor=[UIColor lightGrayColor];
    [articleScrollView addSubview:self.borderBottom];
    [articleScrollView addSubview:articleTitleLabel];
    
}

-(void)initArticleAuthor{
    CGRect titleFrame=articleTitleLabel.frame;
   
    dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, titleFrame.size.height+titleFrame.origin.y+20, self.view.frame.size.width, 300)];
    dateLabel.text=[NSString stringWithFormat:@"Date added: %@",item.date];
    dateLabel.textColor=[UIColor grayColor];
    dateLabel.font=[UIFont italicSystemFontOfSize:14];
    [dateLabel sizeToFit];
    articleAuthorLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, titleFrame.size.height+titleFrame.origin.y+55, self.view.frame.size.width, 300)];
    if(authorImage)
        articleAuthorLabel.text=[NSString stringWithFormat:@"Written by: %@",item.author];
    else
        articleAuthorLabel.text=[NSString stringWithFormat:@"Category: %@",item.category];
    articleAuthorLabel.textColor=[UIColor grayColor];
    articleAuthorLabel.font=[UIFont italicSystemFontOfSize:14];
    [articleAuthorLabel sizeToFit];
    UIImageView *authorImgView=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-79, dateLabel.frame.origin.y-5, 64, 64)];
    authorImgView.image=authorImage;
    authorImgView.contentMode=UIViewContentModeScaleAspectFill;
    authorImgView.clipsToBounds=YES;
    [self addRadius:authorImgView.layer angle:20];
    [articleScrollView addSubview:authorImgView];
    [articleScrollView addSubview:dateLabel];
    [articleScrollView addSubview:articleAuthorLabel];
}

#pragma mark - Article content text init

-(void)initArticleContent{
    [DTAttributedTextContentView setLayerClass:[DTTiledLayerWithoutFade class]];

    CGRect authorFrame=articleAuthorLabel.frame;
    articleContentTextView=[[DTAttributedTextContentView alloc] initWithFrame:CGRectMake(15, authorFrame.size.height+authorFrame.origin.y+20, self.view.frame.size.width-30, 300)];


    
    NSString* content=[self addImgTagsToText:item.content];
    
    DTCSSStylesheet *style=[[DTCSSStylesheet alloc] initWithStyleBlock:@"p{font:HelveticaNeue;}"];
    DTHTMLAttributedStringBuilder *stringBuilder=[[DTHTMLAttributedStringBuilder alloc] initWithHTML:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{DTDefaultTextColor:[UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1],DTDefaultFontSize:@15,DTDefaultFontName:@"HelveticaNeue",DTDefaultLineHeightMultiplier:@1.3,DTDefaultLinkColor:[UIColor colorWithRed:0 green:153.0/255.0 blue:1 alpha:1],DTDefaultStyleSheet:style} documentAttributes:nil];
    
    articleContentTextView.shouldDrawImages=NO;
    articleContentTextView.shouldDrawLinks=NO;
    articleContentTextView.delegate=self;
    articleContentTextView.attributedString=[stringBuilder generatedAttributedString];
    [articleContentTextView setBackgroundColor:[UIColor clearColor]];

    [articleContentTextView sizeToFit];
    CGFloat labelHeight=articleContentTextView.frame.size.height;
    CGFloat labelY=articleContentTextView.frame.origin.y;
    CGRect backFrame=self.articleContentBackground.frame;
    backFrame.size.height=labelY+labelHeight+30;
    self.articleContentBackground.frame=backFrame;
    [articleScrollView addSubview:articleContentTextView];

}

#pragma mark - Method for adding HTML tags to links

-(NSString*)addImgTagsToText:(NSString*)text{
    NSDataDetector *detector=[NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray* links=[detector matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    NSString *result=text;
    CGFloat embedHeight;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        embedHeight=500;
    else embedHeight=250;
    NSMutableArray *parsedLinks=[[NSMutableArray alloc] init];
    for(int i=0;i<links.count;i++){
        NSString *test=[NSString stringWithFormat:@"%@",[links[i] URL]];
        if(![parsedLinks containsObject:test]){
        if([test rangeOfString:@".jpg"].location != NSNotFound || [test rangeOfString:@".png"].location != NSNotFound){
            
            result=[result stringByReplacingOccurrencesOfString:test withString:[NSString stringWithFormat:@"<br><img src='%@' width='%f' height='%f' /><span style='color:#878787;' align='center'><small>+Click on image to view in fullscreen</small></span><br>",test,articleContentTextView.frame.size.width,embedHeight]];
        }
        else if([test hasPrefix:@"https://www.youtube.com"] || [test hasPrefix:@"https://youtu.be"]){
            if(test.length > 43){
                test=[test substringWithRange:NSMakeRange(0, 43)];
            }
            result=[result stringByReplacingOccurrencesOfString:test withString:[NSString stringWithFormat:@"<br><iframe src='%@' width='%f' height='%f'></iframe><br><br>",test,articleContentTextView.frame.size.width,embedHeight]];
        }
            else
                result=[result stringByReplacingOccurrencesOfString:test withString:[NSString stringWithFormat:@"<br><a href='%@'>%@</a><br>",test,test]];
            [parsedLinks addObject:test];
        }

    }
    return result;
}

#pragma mark - ScrollView init and height adjust

-(void)setScrollViewSize{
    CGFloat maxHeight=0.0;
    for (UIView *sub in articleScrollView.subviews) {
        if(sub.frame.origin.y+sub.frame.size.height>maxHeight)
            maxHeight=sub.frame.origin.y+sub.frame.size.height;
    }
    [articleScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.articleContentBackground.frame.origin.y+self.articleContentBackground.frame.size.height+10)];
}

-(void)initScrollView{
    articleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-(self.navigationController.navigationBar.frame.size.height+20+self.tabBarController.tabBar.frame.size.height))];
    self.edgesForExtendedLayout=UIRectEdgeBottom;
    
    if([TabBar bannerIsVisible])
        articleScrollView.contentInset=UIEdgeInsetsMake(0, 0, [TabBar adFrame].size.height, 0);
    
    [self.view addSubview:articleScrollView];

}

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1];
    [self initNavbarButtons];
    [self initScrollView];
    [self initArticleTitle];
    [self initArticleAuthor];
    [self initArticleContent];
    
    [self setScrollViewSize];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenterAdLoaded:) name:@"adIsLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenterAdFailed:) name:@"adFailedToLoad" object:nil];
    
//    [self getCommentsNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Comments methods

-(void)openComments{
    CommentsTableView *commentsView=[[CommentsTableView alloc] init];
    commentsView.articleID=item.newsID;
    [self.navigationController pushViewController:commentsView animated:YES];
}


#pragma mark - DTAttributedText parse Links and open them on Click

-(UIView*)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame{
    NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];
    
    NSURL *URL = [attributes objectForKey:DTLinkAttribute];
    NSString *identifier = [attributes objectForKey:DTGUIDAttribute];
    
    DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
    button.URL = URL;
    button.minimumHitSize = CGSizeMake(25, 25);
    button.GUID = identifier;
    
    
    UIImage *normalImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDefault];
    [button setImage:normalImage forState:UIControlStateNormal];

    [button setTitleColor:[UIColor colorWithRed:77.0/255.0 green:184.0/255.0 blue:219.0/255.0 alpha:1] forState:UIControlStateHighlighted];
    
  
    [button addTarget:self action:@selector(openLink:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(void)openLink:(DTLinkButton*)button{
    NSURL *url=button.URL;
    
    if([[UIApplication sharedApplication] canOpenURL:url])
        [[UIApplication sharedApplication] openURL:url];
}



#pragma mark - DTAttributedText parse images and videos

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame {
    if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
        imageView.shouldShowProgressiveDownload=YES;
       
        imageView.clipsToBounds=YES;
        [imageView sd_setImageWithURL:attachment.contentURL];
        imageView.delegate = self;
        [imageView setAccessibilityValue:@"ASDF"];
//        imageView.url = attachment.contentURL;
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImageFullScreen:)];
        [imageView setUserInteractionEnabled:YES];
        [imageView addGestureRecognizer:tapGesture];
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        return imageView;
    }
    
    if ([attachment isKindOfClass:[DTIframeTextAttachment class]]) {
        YTPlayerView *ytPlayer=[[YTPlayerView alloc] initWithFrame:frame];
        NSString* ytLink=[NSString stringWithFormat:@"%@",attachment.contentURL];
        NSString* ytVideoID=[ytLink substringFromIndex:ytLink.length-11];
        [ytPlayer loadWithVideoId:ytVideoID];
        return ytPlayer;
    }
    
    return nil;
}

-(void)openImageFullScreen:(UITapGestureRecognizer*)sender{
    FullScreenImageView *fullScreenImage=[[FullScreenImageView alloc] init];
    fullScreenImage.image=((DTLazyImageView*)sender.view).image;
    [self.navigationController pushViewController:fullScreenImage animated:YES];
}

#pragma mark - DTLazyImage size adjust and reload layout

- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size {
    NSURL *url = lazyImageView.url;
    CGSize imageSize = size;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    
    BOOL didUpdate = NO;
   
    for (DTTextAttachment *oneAttachment in [articleContentTextView.layoutFrame textAttachmentsWithPredicate:pred]) {
        if (CGSizeEqualToSize(oneAttachment.originalSize, CGSizeZero)) {
            oneAttachment.originalSize = imageSize;
            didUpdate = YES;
        }
    }
    [articleContentTextView relayoutText];
}

-(void)resetTitle:(NSString*)newTitle andContent:(NSString*)newContent andCommentsNumber:(NSString*) noOfComments{
    CGFloat visinaPre=articleTitleLabel.frame.size.height;
    articleTitleLabel.text=newTitle;
    articleTitleLabel.frame=CGRectMake(15, 20, self.view.frame.size.width-30, 300);
    [articleTitleLabel sizeToFit];
    CGFloat razlika=articleTitleLabel.frame.size.height-visinaPre;
    NSLog(@"%f",razlika);
    NSString *content=[self addImgTagsToText:newContent];
    DTCSSStylesheet *style=[[DTCSSStylesheet alloc] initWithStyleBlock:@"p{font:HelveticaNeue;}"];
    DTHTMLAttributedStringBuilder *stringBuilder=[[DTHTMLAttributedStringBuilder alloc] initWithHTML:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{DTDefaultTextColor:[UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1],DTDefaultFontSize:@15,DTDefaultFontName:@"HelveticaNeue",DTDefaultLineHeightMultiplier:@1.3,DTDefaultLinkColor:[UIColor colorWithRed:0 green:153.0/255.0 blue:1 alpha:1],DTDefaultStyleSheet:style} documentAttributes:nil];
    articleContentTextView.attributedString=[stringBuilder generatedAttributedString];
    articleAuthorLabel.frame=CGRectOffset(articleAuthorLabel.frame, 0, razlika);
    articleContentTextView.frame=CGRectOffset(articleContentTextView.frame, 0, razlika);
    self.borderBottom.frame=CGRectOffset(self.borderBottom.frame, 0, razlika);
    dateLabel.frame=CGRectOffset(dateLabel.frame, 0, razlika);
    [articleContentTextView sizeToFit];
    CGFloat labelHeight=articleContentTextView.frame.size.height;
    CGFloat labelY=articleContentTextView.frame.origin.y;
    CGRect backFrame=self.articleContentBackground.frame;
    backFrame.size.height=labelY+labelHeight+30;
    self.articleContentBackground.frame=backFrame;
    [articleContentTextView relayoutText];
    [self setScrollViewSize];
    numberCommentsLabel.text=[NSString stringWithFormat:@"%@",noOfComments];
//    [numberCommentsLabel sizeToFit];
}



#pragma mark - NSURL Connection

-(void)refreshArticle{
    NSURL *articleUrl=[NSURL URLWithString:[NSString stringWithFormat:@"http://www.theartball.com/admin/iOS/get-single-article.php?id=%@",item.newsID]];
    NSURLRequest *request=[NSURLRequest requestWithURL:articleUrl];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.refreshData=[[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.refreshData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSError *error;
    NSDictionary *jsonArray=[NSJSONSerialization JSONObjectWithData:self.refreshData options:NSJSONReadingAllowFragments error:&error];
    
    
    NSString *newTitle=jsonArray[@"title"];
    NSString *newContent=jsonArray[@"content"];
    NSString *commentNo=jsonArray[@"numberOfCom"];
    [self resetTitle:newTitle andContent:newContent andCommentsNumber:commentNo];
}

#pragma mark - Notification Center updates

-(void)notificationCenterAdLoaded:(NSNotification*) notification{
     articleScrollView.contentInset = UIEdgeInsetsMake(0, 0, [TabBar adFrame].size.height, 0);
}

-(void)notificationCenterAdFailed:(NSNotification*) notification{
     articleScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
