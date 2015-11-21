//
//  FreestyleShopTableView.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 10/14/15.
//  Copyright © 2015 Uros Zivaljevic. All rights reserved.
//

#import "FreestyleShopTableView.h"
#import "FreestyleShopTableCell.h"
#import "TabBar.h"
#import "FreestyleShopItemView.h"
#import "ShopItem.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString *shopCellID=@"shopCell";

@interface FreestyleShopTableView ()

@property UIActivityIndicatorView *loading;

@end

@implementation FreestyleShopTableView

@synthesize model;
@synthesize shopItems;

-(void)initNavBarButtons{
     UIBarButtonItem *refreshButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(refreshAction)];
    UIBarButtonItem *addBarButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSellItemAction)];
    self.navigationItem.rightBarButtonItems=@[addBarButton,refreshButton];
}

-(void)initTableView{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FreestyleShopCell" bundle:nil] forCellReuseIdentifier:shopCellID];
    self.tableView.backgroundColor=[UIColor colorWithWhite:233.0/255.0 alpha:1];
//    [self.tableView setSeparatorColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-10, 80)];
    UILabel *headerLabel=[[UILabel alloc] initWithFrame:headerView.frame];
    headerLabel.text=@"Welcome to Freestyle Shop! Here you can see what freestylers from all over the world are selling, also you can sell your freestyle stuff. Just click + button to add item!";
    headerLabel.numberOfLines=0;
    headerLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.textColor=[UIColor colorWithWhite:0.6 alpha:1];
    headerView.frame=headerLabel.frame;
    
    [headerView addSubview:headerLabel];
    self.tableView.tableHeaderView=headerView;
    
    self.loading=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loading.center=CGPointMake(self.tableView.center.x, 150);
    [self.tableView addSubview:self.loading];
}

-(void)initShopModel{
    model=[[FreestyleShopModel alloc] init];
    model.delegate=self;
    [model downloadData];
    [self.loading startAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self initNavBarButtons];
    [self initShopModel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenterAdLoaded:) name:@"adIsLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenterAdFailed:) name:@"adFailedToLoad" object:nil];

    
    if([TabBar bannerIsVisible]){
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, [TabBar adFrame].size.height, 0)];
    }

}

-(void)updateWithItems:(NSArray *)items{
    shopItems=items;
    [self.tableView reloadData];
    [self.loading stopAnimating];
}

-(void)failedToDownloadWithError:(NSError *)error{
    
}

-(void)refreshAction{
    [model downloadData];
    [self.loading startAnimating];
}

-(void)addSellItemAction{
    if([UIAlertController class]){
        UIAlertController *popup=[UIAlertController alertControllerWithTitle:@"Open webpage in Safari?" message:@"You are about to add item you want to sell, click Open to continue." preferredStyle:UIAlertControllerStyleAlert];
        
        [popup addAction:[UIAlertAction actionWithTitle:@"Open" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.theartball.com/add-listing.php"]];
        }]];
        [popup addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            return;
        }]];
        [self presentViewController:popup animated:YES completion:nil];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Open webpage in Safari?" message:@"You are about to add item you want to sell, click Open to continue." delegate:self cancelButtonTitle:@"Open" otherButtonTitles:@"Cancel", nil];
        alert.delegate=self;
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.theartball.com/add-listing.php"]];

    else return;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return shopItems.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FreestyleShopItemView *fsShopItemView=[[FreestyleShopItemView alloc] init];
    
    fsShopItemView.shopItem=[shopItems objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:fsShopItemView animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FreestyleShopTableCell *cell = [tableView dequeueReusableCellWithIdentifier:shopCellID forIndexPath:indexPath];
    
    ShopItem *shopItem=[shopItems objectAtIndex:indexPath.row];
    
    cell.itemNameLabel.text=shopItem.itemTitle;
    cell.priceLabel.text=[NSString stringWithFormat:@"%@€",shopItem.itemPrice];
    cell.sellerLabel.text=shopItem.itemSeller;
    [cell.itemImageView sd_setImageWithURL:[NSURL URLWithString:shopItem.mainImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return cell;
}

-(void)notificationCenterAdLoaded:(NSNotification*) notification{
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, [TabBar adFrame].size.height, 0)];
}

-(void)notificationCenterAdFailed:(NSNotification*) notification{
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

@end
