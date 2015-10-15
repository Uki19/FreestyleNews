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

NSString *shopCellID=@"shopCell";

@interface FreestyleShopTableView ()

@end

@implementation FreestyleShopTableView

-(void)initTableView{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FreestyleShopCell" bundle:nil] forCellReuseIdentifier:shopCellID];
    self.tableView.backgroundColor=[UIColor colorWithWhite:233.0/255.0 alpha:1];
//    [self.tableView setSeparatorColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-10, 70)];
    UILabel *headerLabel=[[UILabel alloc] initWithFrame:headerView.frame];
    headerLabel.text=@"Welcome to Freestyle Shop! Here you can see what freestylers from all over the world are selling, also you can sell your freestyle stuff!";
    headerLabel.numberOfLines=0;
    headerLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.textColor=[UIColor colorWithWhite:0.6 alpha:1];
    headerView.frame=headerLabel.frame;
    
    [headerView addSubview:headerLabel];
    
    self.tableView.tableHeaderView=headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenterAdLoaded:) name:@"adIsLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenterAdFailed:) name:@"adFailedToLoad" object:nil];

    
    if([TabBar bannerIsVisible]){
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, [TabBar adFrame].size.height, 0)];
    }

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

    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 103;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FreestyleShopTableCell *cell = [tableView dequeueReusableCellWithIdentifier:shopCellID forIndexPath:indexPath];
    
    cell.priceLabel.text=@"50e";
    cell.itemNameLabel.text=@"ovo je prodaja ovo je prodaja ovo je prodaja ovo je prodaja ovo je prodaja ovo je prodaja ovo je prodaja";
    cell.sellerLabel.text=@"Nikola djota milosevic";
    cell.itemImageView.image=[UIImage imageNamed:@"triangle"];
    
    return cell;
}

-(void)notificationCenterAdLoaded:(NSNotification*) notification{
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, [TabBar adFrame].size.height, 0)];
}

-(void)notificationCenterAdFailed:(NSNotification*) notification{
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

@end
