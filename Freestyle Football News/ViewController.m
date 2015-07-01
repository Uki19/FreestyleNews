//
//  ViewController.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/17/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import "ViewController.h"
#import "NewsCell.h"
#import "NewsItem.h"
#import "NewsItemView.h"
#import "ArticleView.h"
#import "ArchiveTableView.h"
#import "YTPlayerView.h"
#import "VideoPlayerView.h"

static NSString *cellID = @"NewsCell";

@interface ViewController ()

@property NSMutableDictionary *newsImages;
@property NSMutableArray *imgs;
@property NSMutableArray *imgsCopy;
@property NSArray *newsCopy;

@end

@implementation ViewController

@synthesize newsView;
@synthesize news;
@synthesize newsModel;
@synthesize category;
@synthesize databaseURL;
@synthesize loading;
@synthesize segment;
@synthesize swipeGestureRight;
@synthesize swipeGestureLeft;

@synthesize bannerIsVisible;

#pragma mark - Refresh and Archive buttons and actions

-(void)initNavbarButtons{
    UIBarButtonItem *refreshButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(refreshAction)];
    self.navigationItem.rightBarButtonItem=refreshButton;
    UIBarButtonItem *archiveButton=[[UIBarButtonItem alloc] initWithTitle:@"Archive" style:UIBarButtonItemStylePlain target:self action:@selector(pushArchiveView)];
    self.navigationItem.leftBarButtonItem=archiveButton;
}

-(void)refreshAction{
    [loading startAnimating];
    
    [newsModel downloadDataAtUrl:databaseURL];
}

-(void)pushArchiveView{
    ArchiveTableView *archiveTableView=[[ArchiveTableView alloc] init];
    archiveTableView.category=category;
    [self.navigationController pushViewController:archiveTableView animated:YES];
}

#pragma mark - SegmentedControl init and actions

-(void)initSegmentedControl{
    segment=[[UISegmentedControl alloc] initWithItems:@[@"All",@"Comps",@"Videos",@"Other"]];
    segment.frame=CGRectMake(-2, self.navigationController.navigationBar.frame.size.height+19,self.view.frame.size.width+4, 30);
    segment.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:138.0/255.0 blue:229.0/255.0 alpha:1];
    segment.tintColor=[UIColor colorWithRed:0 green:154.0/255.0 blue:255.0/255.0 alpha:1];
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Thin" size:14]} forState:UIControlStateNormal];
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    [segment addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
    segment.selectedSegmentIndex=0;
    [self.view addSubview:segment];
}

-(void)segmentControlAction:(UISegmentedControl*)sender {
    [loading startAnimating];
    NSString *selectedTitle=[sender titleForSegmentAtIndex:[sender selectedSegmentIndex]];
    if([selectedTitle isEqualToString:@"Comps"]) selectedTitle=@"Competitions";
//    [self setArticlesForCategory:selectedTitle];
    
    if(![selectedTitle isEqualToString:@"All"]) {
        self.category=selectedTitle;
    } else {
        self.category=@"Home";
    }
    
    databaseURL=@"http://ineco-posredovanje.co.rs/apptest/getnews.php";
    
    if(![category isEqualToString:@"Home"]) {
        databaseURL=[databaseURL stringByAppendingString:[NSString stringWithFormat:@"?category=%@&archive=0",category]];
    }
    
    [newsModel downloadDataAtUrl:databaseURL];
}

//
//-(void)setArticlesForCategory:(NSString*)categ {
//    NSMutableArray *tmp=[[NSMutableArray alloc] init];
//    NSMutableArray *tmpImgs=[[NSMutableArray alloc] init];
//    for(NewsItem* item in self.newsCopy) {
//        if([item.category isEqualToString:categ] || [categ isEqualToString:@"All"]){
//            [tmp addObject:item];
//            [tmpImgs addObject:[self.imgsCopy objectAtIndex:[self.newsCopy indexOfObject:item]]];
//        }
//    }
//    self.imgs=tmpImgs;
//    news=tmp;
//    [newsView reloadData];
//}


#pragma mark - init news Model and NewsView(CollectionView)

-(void)initNewsModelAndData {
    self.newsImages=[[NSMutableDictionary alloc] init];
    loading=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loading.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:138.0/255.0 blue:229.0/255.0 alpha:0.5];
    CALayer *loadingLayer=loading.layer;
    [loadingLayer setMasksToBounds:YES];
    [loadingLayer setCornerRadius:4.0f];
    loading.center=self.view.center;
    [self.view addSubview:loading];
    [loading startAnimating];
    
    newsModel=[[NewsModel alloc] init];
    news=[[NSArray alloc] init];
    newsModel.delegate=self;
    databaseURL=@"http://ineco-posredovanje.co.rs/apptest/getnews.php";
    
    if(![category isEqualToString:@"Home"]) {
        databaseURL=[databaseURL stringByAppendingString:[NSString stringWithFormat:@"?category=%@&archive=0",category]];
    }
        
    [newsModel downloadDataAtUrl:databaseURL];
}


-(void)initNewsView {
    UICollectionViewFlowLayout *flowlayout=[[UICollectionViewFlowLayout alloc] init];
   
    newsView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:flowlayout];
    flowlayout.sectionInset=UIEdgeInsetsMake(38.0f, 8.0f, 1.0f, 8.0f);
    flowlayout.minimumInteritemSpacing=3.0f;
    flowlayout.minimumLineSpacing=3.0f;
    newsView.backgroundColor=[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
    newsView.delegate=self;
   
    newsView.dataSource=self;
    [newsView registerClass:[NewsCell class] forCellWithReuseIdentifier:cellID];
    [newsView registerClass:[NewsCell class] forCellWithReuseIdentifier:@"Prvi Cell"];
    [self.view addSubview:newsView];
    
    swipeGestureRight=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    [swipeGestureRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [newsView addGestureRecognizer:swipeGestureRight];
    swipeGestureLeft=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    [swipeGestureLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [newsView addGestureRecognizer:swipeGestureLeft];
}

#pragma mark - Swipe gesture

-(void)swipe:(UISwipeGestureRecognizer*)swipe {
    BOOL hasNext;
    if(swipe.direction==UISwipeGestureRecognizerDirectionLeft) {
        if(segment.selectedSegmentIndex<segment.numberOfSegments-1) {
           segment.selectedSegmentIndex++;
            hasNext=YES;
        }
    }
    else {
        if(segment.selectedSegmentIndex>0){
            segment.selectedSegmentIndex--;
            hasNext=YES;
        }
    }
    if(hasNext)
        [self segmentControlAction:segment];
}

#pragma mark - CollectionView delegate and datasource methods

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewsCell *cell = nil;
    NewsItem *newsItem = [news objectAtIndex:indexPath.row];
    
    if(indexPath.row == 0 || newsItem.important) {
        cell=[newsView dequeueReusableCellWithReuseIdentifier:@"Prvi Cell" forIndexPath:indexPath];
    } else {
        cell=[newsView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(indexPath.row==0 || newsItem.important) {
            cell.title.font=[UIFont fontWithName:nil size:35];
            cell.category.font=[UIFont boldSystemFontOfSize:20];
        } else {
            cell.title.font=[UIFont fontWithName:nil size:24];
            cell.category.font=[UIFont boldSystemFontOfSize:14];
        }
    } else {
        if(indexPath.row==0 || newsItem.important) {
            cell.title.font=[UIFont fontWithName:nil size:25];
            cell.category.font=[UIFont boldSystemFontOfSize:14];
        } else {
            cell.title.font=[UIFont fontWithName:nil size:14];
            cell.category.font=[UIFont boldSystemFontOfSize:8];
        }
        
    }
    
    if([newsItem.category isEqualToString:@"Videos"]) {
        cell.newsImage.image=[self addPlayIconOnImage:[self.imgs objectAtIndex:indexPath.row]];
    } else {
        cell.newsImage.image=[self.imgs objectAtIndex:indexPath.row];
    }
    
    cell.category.text=newsItem.category;
    cell.title.text=newsItem.title;
    [cell reloadLabels];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return news.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if([(NewsItem*)[news objectAtIndex:indexPath.row] important] || indexPath.row==0) {
        return CGSizeMake(newsView.frame.size.width-16, newsView.frame.size.width-16);
    } else {
        return CGSizeMake(newsView.frame.size.width/2-10, newsView.frame.size.width/2-10);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleView *newsItemView=[[ArticleView alloc] init];
    NewsItem *item=[news objectAtIndex:indexPath.row];
    newsItemView.item=item;
    newsItemView.title=@"News";
    
    if([item.category isEqualToString:@"Videos"]){
        VideoPlayerView *videoPlayer=[[VideoPlayerView alloc] init];
        videoPlayer.videoURL=item.content;
        [self presentViewController:videoPlayer animated:YES completion:NULL];
    } else {
        [self.navigationController pushViewController:newsItemView animated:YES];
    }
}

#pragma mark - Observer update methods

-(void)updateWithItems:(NSArray *)items {
    int numberImportant = 0;
    int lastImportantIndex = 0;
    news = items;
    self.newsCopy=news;
    self.imgs=[[NSMutableArray alloc] init];
    
    int brImportant=0;
    //algoritam za zamjenu vijesti ako je neparan broj prije sljedece vazne vijesti
    for(int i=1; i<news.count; i++){
        if([(NewsItem*)[news objectAtIndex:i] important]) {
            if((i - lastImportantIndex) % 2 == 0) {
                NSMutableArray *array;
                array = [NSMutableArray arrayWithArray:news];
                
                NewsItem *previousNews = [news objectAtIndex:i-1];
                NewsItem *importantNews = [news objectAtIndex:i];
                
                
                [array replaceObjectAtIndex:i withObject:previousNews];
                [array replaceObjectAtIndex:i-1 withObject:importantNews];
                
                
                news = array;
            }
            brImportant++;
            lastImportantIndex = i-brImportant;
        }
    }
    
    for(int i=0; i<news.count; i++){
        if([(NewsItem*)[news objectAtIndex:i] important]) {
            numberImportant++;
        }
        
        NSURL *imgurl = [NSURL URLWithString:((NewsItem *)news[i]).imageURL];
        NSData *imgData = [NSData dataWithContentsOfURL:imgurl];
        UIImage *image = [UIImage imageWithData:imgData];
        
        if((i==0) || ([(NewsItem*)[news objectAtIndex:i] important])) {
            image=[self imageWithImage:image scaledToSize:CGSizeMake(500, 500) andCompressedTo:1];
        } else {
            image=[self imageWithImage:image scaledToSize:CGSizeMake(400, 400) andCompressedTo:0.6];
        }
        
        if(image){
            if(![self.imgs containsObject:image]) {
                [self.imgs addObject:image];
            }
        } else {
            [self.imgs addObject:[UIImage imageNamed:@"home"]];
        }
    }
    
 
    
    
    
    NSMutableArray *array;
    if(numberImportant % 2 == 0) {
        array = [NSMutableArray arrayWithArray:news];
        [array removeLastObject];
        news = array;
    }
    [newsView reloadData];
    self.imgsCopy=self.imgs;
//    [segment setSelectedSegmentIndex:0];
//    self.category=@"Home";
    [loading stopAnimating];
}

-(void)failedToDownloadWithError:(NSError *)error {
    if([UIAlertController class]) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Failed to connect" message:@"Make sure you are connected to the internet and retry." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *retryAction=[UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [newsModel downloadDataAtUrl:databaseURL];
        }];
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [loading stopAnimating];
        }];
        
        [alert addAction:retryAction];
        [alert addAction:cancelAction];
     
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Failed to connect" message:@"Make sure you are connected to the internet and retry." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
        [alertView setAlertViewStyle:UIAlertViewStyleDefault];
        
        [alertView show];
    }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==[alertView cancelButtonIndex]) {
        [loading stopAnimating];
    } else {
        [newsModel downloadDataAtUrl:databaseURL];
    }
}

#pragma mark - Image scale and compress method

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize andCompressedTo:(CGFloat)compression {
    CGFloat min=image.size.height<image.size.width?image.size.height:image.size.width;
    CGFloat velikoS=image.size.width;
    CGFloat velikoV=image.size.height;
    CGRect rect=CGRectMake((velikoS-min)/2, (velikoV-min)/2, min, min);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    UIGraphicsBeginImageContext(newSize);
    [cropped drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    newImage=[UIImage imageWithData: UIImageJPEGRepresentation(newImage, compression)];
    return newImage;
}

-(UIImage *)addPlayIconOnImage:(UIImage* )image {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    [[UIImage imageNamed:@"playicon"] drawInRect:CGRectMake(image.size.width/2-image.size.width/6,image.size.height/2-image.size.height/6, image.size.width/3, image.size.height/3)];
    UIImage *resultImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.category=self.title;
    
    adView = [[ADBannerView alloc] initWithFrame:self.tabBarController.tabBar.frame];
    
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        adView.frame = CGRectOffset(adView.frame, 0, 748.0f);
//    } else {
//        adView.frame = CGRectOffset(adView.frame, 0, 480.0f);
//    }
    
//    adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
//    adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    
    adView.delegate = self;
    self.bannerIsVisible = NO;
   
    [self initNewsView];
    [self initNavbarButtons];
    [self initNewsModelAndData];
    [self initSegmentedControl];

    [self.view addSubview:adView];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
    if (!self.bannerIsVisible) {
        
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, -adView.frame.size.height);
        [UIView commitAnimations];
        self.bannerIsVisible = YES;
        self.newsView.frame=CGRectMake(0, 0, self.newsView.frame.size.width, self.newsView.frame.size.height-adView.frame.size.height);
        
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    
    if (self.bannerIsVisible) {
        
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, adView.frame.size.height);
        self.newsView.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

@end
