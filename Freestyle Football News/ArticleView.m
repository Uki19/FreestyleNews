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
#import "CommentsInArticle.h"
#import "CommentsViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

BOOL isArticle;

@interface ArticleView ()

@property NSMutableArray *articleImages;
@property UIView* articleContentBackground;
@property NSMutableData* refreshData;
@property UIView *borderBottom;
@property NSString *brojKomentara;
@property UILabel *comLabel;
@property UIButton *viewCommentsButton;
@property UIActivityIndicatorView *loading;

@property UIBarButtonItem *loadingButton;
@property UIBarButtonItem *commentsButton;
@property UIView *commentsHeadView;

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
@synthesize commentsModel;
@synthesize comments;
@synthesize commentsView;
@synthesize commentsHeadView;



-(void)addRadius:(CALayer*)layer angle:(CGFloat)angle{
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:angle];
}

-(void)initNavbarButtons{
    UIBarButtonItem *refreshButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(refreshArticle)];
    UIImage *ci=[UIImage imageNamed:@"comments"];
    self.loading=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.loadingButton=[[UIBarButtonItem alloc] initWithCustomView:self.loading];
    UIButton *imageComments=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, ci.size.width, ci.size.height)];
    [imageComments setBackgroundImage:ci forState:UIControlStateNormal];
    numberCommentsLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, imageComments.frame.size.width, imageComments.frame.size.height-20)];
    numberCommentsLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:12];
    numberCommentsLabel.textColor=[UIColor whiteColor];
    numberCommentsLabel.textAlignment=NSTextAlignmentCenter;
    numberCommentsLabel.center=imageComments.center;
    numberCommentsLabel.frame=CGRectOffset(numberCommentsLabel.frame, 0, -2);
    [imageComments addSubview:numberCommentsLabel];
    imageComments.frame=CGRectOffset(imageComments.frame, 10, 0);
    self.commentsButton=[[UIBarButtonItem alloc] initWithCustomView:imageComments];
    [imageComments addTarget:self action:@selector(openComments) forControlEvents:UIControlEventTouchUpInside];
    if(item.category){
       self.navigationItem.rightBarButtonItems=@[refreshButton,self.commentsButton];
        isArticle=NO;
    }
    else{
        self.navigationItem.rightBarButtonItem=self.commentsButton;
        isArticle=YES;
    }
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
    if(!commentsView)
        [articleScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.articleContentBackground.frame.origin.y+self.articleContentBackground.frame.size.height+10)];
    else
        [articleScrollView setContentSize:CGSizeMake(self.view.frame.size.width, commentsView.frame.origin.y+commentsView.frame.size.height+10)];
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
  
    [self initCommentsModel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenterAdLoaded:) name:@"adIsLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenterAdFailed:) name:@"adFailedToLoad" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Comments methods

-(void)initCommentsModel{
    
    if(item.category)
        self.navigationItem.rightBarButtonItems=@[self.navigationItem.rightBarButtonItems[0],self.loadingButton];
    else
        self.navigationItem.rightBarButtonItem=self.loadingButton;
    [self.loading startAnimating];
    commentsModel=[[CommentsModel alloc] init];
    commentsModel.delegate=self;
    [commentsModel downloadDataForArticleID:item.newsID isArticle:isArticle];
}


-(void)initCommentsView{
    
    commentsHeadView=[[UIView alloc] initWithFrame:CGRectMake(self.articleContentBackground.frame.origin.x, self.articleContentBackground.frame.origin.y+self.articleContentBackground.frame.size.height+5, self.articleContentBackground.frame.size.width, 30)];
    self.comLabel=[[UILabel alloc] initWithFrame:CGRectMake(5,0, commentsHeadView.frame.size.width, 30)];
    self.comLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:17.0];
    self.comLabel.textColor=[UIColor colorWithWhite:0.3 alpha:1];
    self.viewCommentsButton=[[UIButton alloc] initWithFrame:CGRectMake(commentsHeadView.frame.size.width-145, 0, 100, 30)];
    [self setLabelAndButton];
        [self.viewCommentsButton setBackgroundColor:[UIColor colorWithRed:11.0/255.0 green:129.0/255.0 blue:228.0/255.0 alpha:1]];
    [self.viewCommentsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addRadius:self.viewCommentsButton.layer angle:5.0];
    self.viewCommentsButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    [self.viewCommentsButton addTarget:self action:@selector(openComments) forControlEvents:UIControlEventTouchUpInside];
    UIButton *writeCommentButton=[[UIButton alloc] initWithFrame:CGRectMake(commentsHeadView.frame.size.width-40, 0, 40, 30)];
    [self addRadius:writeCommentButton.layer angle:5.0];
    [writeCommentButton setBackgroundColor:[UIColor colorWithRed:11.0/255.0 green:129.0/255.0 blue:228.0/255.0 alpha:1]];
    [writeCommentButton setImage:[UIImage imageNamed:@"pencil"] forState:UIControlStateNormal];
    [writeCommentButton addTarget:self action:@selector(openCommentsAndAdd) forControlEvents:UIControlEventTouchUpInside];
    [commentsHeadView addSubview:writeCommentButton];
    [commentsHeadView addSubview:self.viewCommentsButton];
    [commentsHeadView addSubview:self.comLabel];
    
    [self.articleScrollView addSubview:commentsHeadView];
    commentsView=[[UITableView alloc] initWithFrame:CGRectMake(self.articleContentBackground.frame.origin.x,commentsHeadView.frame.origin.y+35, self.articleContentBackground.frame.size.width,(comments.count<=2?comments.count:2)*120)];
    [commentsView registerNib:[UINib nibWithNibName:@"CommentsViewCell" bundle:nil] forCellReuseIdentifier:@"commentsCell"];
    commentsView.userInteractionEnabled=NO;
    commentsView.separatorStyle=UITableViewCellSeparatorStyleNone;
    commentsView.delegate=self;
    commentsView.dataSource=self;
    commentsView.scrollEnabled=NO;
    [self addRadius:commentsView.layer angle:5.0];
    [articleScrollView addSubview:commentsView];
    CGRect frameContent=CGRectMake(self.commentsView.frame.origin.x, self.commentsView.frame.origin.y, self.commentsView.frame.size.width,self.commentsView.contentSize.height);
    self.commentsView.frame=frameContent;
    [self setScrollViewSize];
}

-(void)setLabelAndButton{
    if(comments.count==0)
        self.comLabel.text=@"No comments";
    else
        self.comLabel.text=@"Recent comments:";
    [self.viewCommentsButton setTitle:[NSString stringWithFormat:@"View All (%ld)",(unsigned long)comments.count] forState:UIControlStateNormal];
    if (floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_8_0) {
        [self refreshArticle];
    }
}

UITextView *tmpCommView;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    tmpCommView=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-32, 29)];
    tmpCommView.font=[UIFont systemFontOfSize:14.0];
    tmpCommView.textAlignment=NSTextAlignmentLeft;
    tmpCommView.text=[[comments objectAtIndex:comments.count-1-indexPath.row] comment];
    CGSize size = [tmpCommView sizeThatFits:CGSizeMake(tmpCommView.frame.size.width, FLT_MAX)];
    return 85+size.height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return comments.count<=2?comments.count:2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentsViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"commentsCell"];
    Comment *comm=[comments objectAtIndex:comments.count-1-indexPath.row];
    
    cell.authorLabel.text=comm.author;
    cell.dateLabel.text=[comm getTime];
    cell.CommentTextView.text=comm.comment;
    return cell;
}

-(void)openComments{
    CommentsTableView *commentsViewController=[[CommentsTableView alloc] init];
    commentsViewController.articleID=item.newsID;
    commentsViewController.articleTitle=item.title;
    commentsViewController.commentsForArticle=isArticle;
    [self.navigationController pushViewController:commentsViewController animated:YES];
}

-(void)openCommentsAndAdd{
    CommentsTableView *commentsViewController=[[CommentsTableView alloc] init];
    commentsViewController.articleID=item.newsID;
    commentsViewController.articleTitle=item.title;
    commentsViewController.addCommentsFlag=YES;
    commentsViewController.commentsForArticle=isArticle;
    [self.navigationController pushViewController:commentsViewController animated:YES];
}

-(void)updateWithComments:(NSArray *)items{
    
    comments=items;
    numberCommentsLabel.text=[NSString stringWithFormat:@"%ld",(unsigned long)comments.count];
    if(commentsView){
        [commentsView reloadData];
        CGRect frameContent=CGRectMake(self.commentsView.frame.origin.x, self.commentsView.frame.origin.y, self.commentsView.frame.size.width,self.commentsView.contentSize.height);
        self.commentsView.frame=frameContent;
        [self setScrollViewSize];
        [self setLabelAndButton];
    }
    else{
        [self initCommentsView];
    }
    if(item.category)
        self.navigationItem.rightBarButtonItems=@[self.navigationItem.rightBarButtonItems[0],self.commentsButton];
    else
        self.navigationItem.rightBarButtonItem=self.commentsButton;
    [self.loading stopAnimating];
}


-(void)failedToDownloadWithError:(NSError *)error{
    
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
    
    commentsHeadView.frame=CGRectMake(commentsHeadView.frame.origin.x, self.articleContentBackground.frame.origin.y+self.articleContentBackground.frame.size.height+5, commentsHeadView.frame.size.width, commentsHeadView.frame.size.height);
     commentsView.frame=CGRectMake(commentsView.frame.origin.x,commentsHeadView.frame.origin.y+35, commentsView.frame.size.width,commentsView.frame.size.height);
    
    [self setScrollViewSize];

//    [numberCommentsLabel sizeToFit];
}



#pragma mark - NSURL Connection

-(void)refreshArticle{
    NSURL *articleUrl=[NSURL URLWithString:[NSString stringWithFormat:@"http://www.theartball.com/admin/iOS/get-single-article.php?id=%@",item.newsID]];
    NSURLRequest *request=[NSURLRequest requestWithURL:articleUrl];
    [NSURLConnection connectionWithRequest:request delegate:self];
    [commentsModel downloadDataForArticleID:item.newsID isArticle:isArticle];
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
