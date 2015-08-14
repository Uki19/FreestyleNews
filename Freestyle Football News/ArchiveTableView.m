//
//  ArchiveTableView.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/22/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import "ArchiveTableView.h"
#import "ArchiveViewCell.h"
#import "NewsItem.h"
#import "ArticleView.h"
#import "TabBar.h"
#import "VideoPlayerView.h"

static NSString* cellID=@"ArchiveCell";

@interface ArchiveTableView ()

@property NSArray* searchResults;
@property NSArray* downloadedDataCopy;


@end

@implementation ArchiveTableView

@synthesize newsModel;
@synthesize downloadedData;
@synthesize date;
@synthesize databaseURL;
@synthesize articleTitle;
@synthesize category;
@synthesize loading;
@synthesize search;

#pragma mark - SearchBar i metode za search

-(void)initSearchBar{
    UISearchBar *searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    search=[[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.searchDisplayController.searchResultsTableView.delegate=self;
    self.searchDisplayController.searchResultsTableView.dataSource=self;
    self.searchDisplayController.searchResultsTableView.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1];
    self.tableView.tableHeaderView=searchBar;
    [self.tableView setContentOffset:CGPointMake(0, 20)];
    search.delegate=self;
    searchBar.delegate=self;
    search.searchResultsDataSource=self;
    search.searchBar.translucent=NO;
    
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"title contains[c] %@", searchText];
    self.searchResults = [downloadedData filteredArrayUsingPredicate:resultPredicate];
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        [self.tableView insertSubview:self.searchDisplayController.searchBar aboveSubview:self.tableView];
    }
}


-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
    if([TabBar bannerIsVisible])
      [tableView setContentInset:UIEdgeInsetsMake(search.searchBar.frame.size.height+20, 0, [TabBar adFrame].size.height, 0)];
}


#pragma mark - News model init

-(void) initModelAndData{
    
    newsModel=[[NewsModel alloc] init];
    downloadedData=[[NSArray alloc] init];
    loading=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loading.center=self.view.center;
    [self.view addSubview:loading];
    databaseURL=@"http://www.theartball.com/admin/iOS/getnews.php?archive=1";
    if(![category isEqualToString:@"Home"])
        databaseURL=[databaseURL stringByAppendingString:[NSString stringWithFormat:@"&category=%@",category]];
    [loading startAnimating];
    newsModel.delegate=self;
    [newsModel downloadDataAtUrl:databaseURL];
}

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initModelAndData];
    [self initSearchBar];
    if([category isEqualToString:@"Home"])
        self.title=@"Archive";
    else self.title=[NSString stringWithFormat:@"%@ Archive",category];
    [self.tableView registerNib:[UINib nibWithNibName:@"ArchiveTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    [self.view setBackgroundColor:[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenterAdLoaded:) name:@"adIsLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenterAdFailed:) name:@"adFailedToLoad" object:nil];
    
    if([TabBar bannerIsVisible]){
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, [TabBar adFrame].size.height, 0)];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.searchDisplayController.searchResultsTableView)
        return self.searchResults.count;
    return downloadedData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArchiveViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];

    NewsItem *item=nil;
    if(tableView == self.searchDisplayController.searchResultsTableView)
        item=[self.searchResults objectAtIndex:indexPath.row];
    else
        item=[downloadedData objectAtIndex:indexPath.row];
    
      cell.backgroundColor = [UIColor clearColor];
    cell.titleLabel.text=item.title;
    cell.categoryLabel.text=[NSString stringWithFormat:@"%@ - %@",item.date, item.category];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsItem *item = nil;
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        item = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        item = [downloadedData objectAtIndex:indexPath.row];
    }
    
    if([item.category isEqual:@"Videos"]) {
        VideoPlayerView *videoView=[[VideoPlayerView alloc] init];
        videoView.videoURL=item.content;
        [self presentViewController:videoView animated:YES completion:NULL];
    } else {
        ArticleView *articleView=[[ArticleView alloc] init];
        articleView.item=item;
        articleView.title=@"News";
        [self.navigationController pushViewController:articleView animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.0f;
}

#pragma mark - Observer metode

-(void)updateWithItems:(NSArray *)items{
    
    downloadedData=items;
    self.downloadedDataCopy=items;
    [loading stopAnimating];
    [self.tableView reloadData];
}

-(void)failedToDownloadWithError:(NSError *)error{
    if([UIAlertController class]){
        
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
    }
    else{
        
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Failed to connect" message:@"Make sure you are connected to the internet and retry." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
        [alertView setAlertViewStyle:UIAlertViewStyleDefault];
        
        [alertView show];
    }
}



#pragma mark - Notification Center updates

-(void)notificationCenterAdLoaded:(NSNotification*) notification{
    //   [self.tableView setContentInset:UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height+20, 0, [TabBar adFrame].size.height+self.tabBarController.tabBar.frame.size.height, 0)];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, [TabBar adFrame].size.height, 0)];
}

-(void)notificationCenterAdFailed:(NSNotification*) notification{
    //   [self.tableView setContentInset:UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height+20, 0, self.tabBarController.tabBar.frame.size.height, 0)];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}


@end
