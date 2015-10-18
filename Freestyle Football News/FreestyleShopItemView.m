//
//  FreestyleShopItemView.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 10/16/15.
//  Copyright © 2015 Uros Zivaljevic. All rights reserved.
//

#import "FreestyleShopItemView.h"
#import "FullScreenImageView.h"
#import "TabBar.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FreestyleShopItemView ()

@end

@implementation FreestyleShopItemView

@synthesize titleLabel;
@synthesize sellerLabel;
@synthesize priceLabel;
@synthesize descriptionView;
@synthesize contactLabel;
@synthesize shopScrollView;
@synthesize locationLabel;
@synthesize shopItem;


-(void)initScrollView{
    shopScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-(self.navigationController.navigationBar.frame.size.height+20+self.tabBarController.tabBar.frame.size.height))];
    self.edgesForExtendedLayout=UIRectEdgeBottom;
    
    if([TabBar bannerIsVisible])
        shopScrollView.contentInset=UIEdgeInsetsMake(0, 0, [TabBar adFrame].size.height, 0);

    [self.view addSubview:shopScrollView];
}

-(void)initLabels{
    
    UIColor *fontColor=[UIColor colorWithWhite:0.3 alpha:1];
    
    titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, self.view.frame.size.width-20, 100)];
    titleLabel.text=shopItem.itemTitle;
    titleLabel.numberOfLines=0;
    titleLabel.font=[UIFont boldSystemFontOfSize:24];
    [titleLabel sizeToFit];
    [shopScrollView addSubview:titleLabel];
    
    UILabel *descLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, titleLabel.frame.size.height+40, 300, 40)];
    descLabel.text=@"Item Description:";
//    NSMutableAttributedString *descAtrStr=[[NSMutableAttributedString alloc] initWithString:@"Item Description:" attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
//    descLabel.attributedText=descAtrStr;
    descLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:19];
    descLabel.textColor=[UIColor colorWithRed:11.0/255.0 green:120.0/255.0 blue:228.0/255.0 alpha:1];
    [descLabel sizeToFit];
    [shopScrollView addSubview:descLabel];
    
    descriptionView=[[UITextView alloc] initWithFrame:CGRectMake(10, descLabel.frame.size.height+descLabel.frame.origin.y+10, self.view.frame.size.width-20, 300)];
    descriptionView.backgroundColor=[UIColor clearColor];
    descriptionView.text=shopItem.itemDescription;
    descriptionView.font=[UIFont systemFontOfSize:15];
    descriptionView.textColor=fontColor;
    descriptionView.editable=NO;
    [descriptionView sizeToFit];
    UIView *backgroundViewDesciption=[[UIView alloc] initWithFrame:CGRectMake(0, descriptionView.frame.origin.y, self.view.frame.size.width, descriptionView.frame.size.height)];
    backgroundViewDesciption.backgroundColor=[UIColor colorWithWhite:244.0/255.0 alpha:1];
    [shopScrollView addSubview:backgroundViewDesciption];
    [shopScrollView addSubview:descriptionView];
    
    UILabel *sellerInfo=[[UILabel alloc] initWithFrame:CGRectMake(10, descriptionView.frame.size.height+descriptionView.frame.origin.y+10, 300, 40)];
    sellerInfo.text=@"Seller Info:";
    sellerInfo.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:19];
    sellerInfo.textColor=[UIColor colorWithRed:11.0/255.0 green:120.0/255.0 blue:228.0/255.0 alpha:1];
    [sellerInfo sizeToFit];
    [shopScrollView addSubview:sellerInfo];
    
    sellerLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, sellerInfo.frame.size.height+sellerInfo.frame.origin.y+10, self.view.frame.size.width-20, 100)];
    sellerLabel.text=shopItem.itemSeller;
    sellerLabel.font=[UIFont systemFontOfSize:14];
    sellerLabel.textColor=fontColor;
    [sellerLabel sizeToFit];
   
    
    contactLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, sellerLabel.frame.size.height+sellerLabel.frame.origin.y+10, self.view.frame.size.width-20, 100)];
    contactLabel.text=[NSString stringWithFormat:@"Contact: %@",shopItem.itemContact];
    contactLabel.font=[UIFont systemFontOfSize:14];
    contactLabel.textColor=fontColor;
    [contactLabel sizeToFit];
    locationLabel=[[UILabel alloc] initWithFrame:CGRectOffset(contactLabel.frame, 0, contactLabel.frame.size.height+10)];
    locationLabel.text=[NSString stringWithFormat:@"Location: %@",shopItem.itemLocation];
    locationLabel.font=[UIFont systemFontOfSize:14];
    locationLabel.textColor=fontColor;
    [locationLabel sizeToFit];
    UIView *backgroundViewSeller=[[UIView alloc] initWithFrame:CGRectMake(0, sellerLabel.frame.origin.y-5, self.view.frame.size.width,sellerLabel.frame.size.height+contactLabel.frame.size.height+locationLabel.frame.size.height+30)];
    backgroundViewSeller.backgroundColor=[UIColor colorWithWhite:244.0/255.0 alpha:1];
    [shopScrollView addSubview:backgroundViewSeller];
    [shopScrollView addSubview:locationLabel];
    [shopScrollView addSubview:sellerLabel];
    [shopScrollView addSubview:contactLabel];
    
    priceLabel=[[UILabel alloc] initWithFrame:CGRectOffset(locationLabel.frame, 0, locationLabel.frame.size.height+20)];
    priceLabel.text=[NSString stringWithFormat:@"Price: %@€",shopItem.itemPrice];
    priceLabel.font=[UIFont boldSystemFontOfSize:16];
    priceLabel.textColor=[UIColor whiteColor];
    [priceLabel sizeToFit];
    priceLabel.frame=CGRectMake(0, priceLabel.frame.origin.y, self.view.frame.size.width, priceLabel.frame.size.height+10);
    priceLabel.textAlignment=NSTextAlignmentCenter;
    priceLabel.backgroundColor=[UIColor colorWithRed:11.0/255.0 green:120.0/255.0 blue:228.0/255.0 alpha:1];
    [shopScrollView addSubview:priceLabel];
    
    UILabel *imagesLabel=[[UILabel alloc] initWithFrame:CGRectOffset(priceLabel.frame, 10, priceLabel.frame.size.height+10)];
    imagesLabel.text=[NSString stringWithFormat:@"Images (%ld):",shopItem.itemImages.count];
    imagesLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:19];
    imagesLabel.textColor=[UIColor colorWithRed:11.0/255.0 green:120.0/255.0 blue:228.0/255.0 alpha:1];
    [imagesLabel sizeToFit];
    [shopScrollView addSubview:imagesLabel];
    
    CGFloat velicinaSlike=(self.view.frame.size.width-40)/3;
    UIView *backgroundViewImages=[[UIView alloc] initWithFrame:CGRectMake(0,imagesLabel.frame.origin.y+imagesLabel.frame.size.height+10 , self.view.frame.size.width, velicinaSlike+20)];
    backgroundViewImages.backgroundColor=[UIColor colorWithWhite:244.0/255.0 alpha:1];
    [shopScrollView addSubview:backgroundViewImages];
    
    for(int i=0;i<shopItem.itemImages.count;i++){
        UIImageView *itemImageView=[[UIImageView alloc] initWithFrame:CGRectMake(i*(velicinaSlike+10)+10, imagesLabel.frame.origin.y+imagesLabel.frame.size.height+20, velicinaSlike,velicinaSlike)];
        [itemImageView sd_setImageWithURL:[NSURL URLWithString:shopItem.itemImages[i]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        itemImageView.clipsToBounds=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImage:)];
        itemImageView.userInteractionEnabled=YES;
        [itemImageView addGestureRecognizer:tap];
        itemImageView.contentMode=UIViewContentModeScaleAspectFill;
        [shopScrollView addSubview:itemImageView];
    }
    
    UIButton *contactSellerButton=[[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, backgroundViewImages.frame.size.height+backgroundViewImages.frame.origin.y+10, 200, 35)];
    contactSellerButton.backgroundColor=[UIColor colorWithRed:11.0/255.0 green:120.0/255.0 blue:228.0/255.0 alpha:1];
    [contactSellerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [contactSellerButton setTitle:@"Contact seller" forState:UIControlStateNormal];
    contactSellerButton.layer.cornerRadius=5.0;
    contactSellerButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    [contactSellerButton addTarget:self action:@selector(openContact) forControlEvents:UIControlEventTouchUpInside];
    [shopScrollView addSubview:contactSellerButton];
    
    [shopScrollView setContentSize:CGSizeMake(self.view.frame.size.width, contactSellerButton.frame.size.height+contactSellerButton.frame.origin.y+10)];
}

-(void)openContact{
    NSURL *url;
    if([shopItem.itemContact containsString:@"@"])
        url=[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@",shopItem.itemContact]];
    else
        url=[NSURL URLWithString:shopItem.itemContact];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)openImage:(UITapGestureRecognizer*)sender{
    FullScreenImageView *fullScreenImageView=[[FullScreenImageView alloc] init];
    fullScreenImageView.image=((UIImageView*)sender.view).image;
    [self.navigationController pushViewController:fullScreenImageView animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Item";
    self.view.backgroundColor=[UIColor colorWithWhite:236.0/255.0 alpha:1];
    [self initScrollView];
    [self initLabels];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenterAdLoaded:) name:@"adIsLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenterAdFailed:) name:@"adFailedToLoad" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)notificationCenterAdLoaded:(NSNotification*) notification{
    shopScrollView.contentInset = UIEdgeInsetsMake(0, 0, [TabBar adFrame].size.height, 0);
}

-(void)notificationCenterAdFailed:(NSNotification*) notification{
    shopScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
