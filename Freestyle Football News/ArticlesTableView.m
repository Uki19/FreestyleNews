//
//  ArticlesTableView.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/19/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import "ArticlesTableView.h"
#import "ArticleCell.h"
#import "NewsItem.h"
#import "ArticleView.h"

static NSString* cellID=@"CelijaZaArticle";

@interface ArticlesTableView ()

@end

@implementation ArticlesTableView

@synthesize articlesModel;
@synthesize articles;
@synthesize articleImages;
@synthesize loading;

#pragma mark - Article Model init

-(void)initModelAndData{
    
    loading=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loading.color=[UIColor grayColor];
    loading.center=CGPointMake(self.view.center.x, loading.frame.size.height);
    [self.view addSubview:loading];
    [loading startAnimating];
    articlesModel=[[ArticlesModel alloc] init];
    articles=[[NSArray alloc] init];
    
    articlesModel.delegate=self;
    
    [articlesModel downloadData];
    
}

#pragma mark - Image scale and compress method

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
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
    newImage=[UIImage imageWithData: UIImageJPEGRepresentation(newImage, 0.6)];
    return newImage;
}

#pragma mark - Observer update methods

-(void)updateWithItems:(NSArray *)items{
    
    articleImages=[[NSMutableArray alloc] init];
    articles=items;
    
    for (NewsItem* item in articles) {
        NSURL *imgUrl=[NSURL URLWithString:item.imageURL];
        NSData *imgData=[NSData dataWithContentsOfURL:imgUrl];
        UIImage *image=[UIImage imageWithData:imgData];
        image=[self imageWithImage:image scaledToSize:CGSizeMake(100, 100)];
        if(image==nil)
            image=[UIImage imageNamed:@"profiledefault"];
        
        [articleImages addObject:image];
    }
    [loading stopAnimating];
    [self.tableView reloadData];
    
}

-(void)failedToDownloadWithError:(NSError *)error{
    
    if([UIAlertController class]){
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Failed to connect" message:@"Make sure you are connected to the internet and retry." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *retryAction=[UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [articlesModel downloadData];
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

#pragma mark - ViewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleTableCell" bundle:nil] forCellReuseIdentifier:cellID];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1]];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]];
    
    [self initModelAndData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return articles.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [loading startAnimating];
    ArticleView* articleView=[[ArticleView alloc] init];
    
    NewsItem *article=[articles objectAtIndex:indexPath.row];
    

    articleView.item=article;
    articleView.authorImage=[articleImages objectAtIndex:indexPath.row];
    articleView.title=@"Article";
    [self.navigationController pushViewController:articleView animated:YES];
    [loading stopAnimating];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    ArticleCell *cell = (ArticleCell*)[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    NewsItem *item=[articles objectAtIndex:indexPath.row];
    
    cell.articleTitle.text=item.title;
    cell.articleAuthor.text=[NSString stringWithFormat:@"By: %@",item.author];
    cell.articleImage.image=[articleImages objectAtIndex:[indexPath row]];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
