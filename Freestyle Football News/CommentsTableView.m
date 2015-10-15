//
//  CommentsTableView.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 10/6/15.
//  Copyright © 2015 Uros Zivaljevic. All rights reserved.
//

#import "CommentsTableView.h"
#import "CommentsViewCell.h"
#import "Comment.h"
#import "TabBar.h"
#import "CommentsInArticle.h"
#include <QuartzCore/QuartzCore.h>

NSString *cellID=@"commentsCell";

@interface CommentsTableView ()

@property UIView *addCommentView;
@property UIButton *sendButton;

@end

@implementation CommentsTableView

@synthesize articleID;
@synthesize comments;
@synthesize model;
@synthesize loading;
@synthesize noComments;
@synthesize addCommentView;
@synthesize commentAuthorTextField;
@synthesize commentTextView;
@synthesize sendButton;
@synthesize articleTitle;

-(void)initNavBarButtons{
    UIBarButtonItem *refreshButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(refreshAction)];
    UIBarButtonItem *addCommentButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addCommentAction)];
    self.navigationItem.rightBarButtonItems=@[refreshButton,addCommentButton];
}

-(void)initTableView{
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentsViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    self.tableView.backgroundColor=[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.bounces=NO;
    UILabel *headerLabel=[[UILabel alloc] initWithFrame:CGRectMake(16, 10, self.tableView.frame.size.width-32, 0)];
    headerLabel.text=articleTitle;
    headerLabel.numberOfLines=0;
    headerLabel.font=[UIFont boldSystemFontOfSize:18.0];
    headerLabel.lineBreakMode=NSLineBreakByWordWrapping;
    [headerLabel sizeToFit];
    UIView *tvHeaderView=[[UIView alloc] initWithFrame:CGRectMake(16,0, self.tableView.frame.size.width-32, headerLabel.frame.size.height+10)];
    
    [tvHeaderView addSubview:headerLabel];
    [tvHeaderView sizeToFit];
    self.tableView.tableHeaderView=tvHeaderView;

    noComments=[[UILabel alloc] init];
    noComments.text=@"No Comments.";
    noComments.font=[UIFont systemFontOfSize:15];
    [noComments sizeToFit];
    noComments.textAlignment=NSTextAlignmentCenter;
    noComments.center=self.view.center;
    noComments.frame=CGRectMake(0, self.tableView.tableHeaderView.frame.size.height+20, self.view.frame.size.width,noComments.frame.size.height);
    noComments.textColor=[UIColor colorWithWhite:0.5 alpha:1];
    [noComments setHidden:YES];
    [self.tableView addSubview:noComments];
    
}

-(void)initCommentsModel{
    model=[[CommentsModel alloc] init];
    model.delegate=self;
    [model downloadDataForArticleID:articleID isArticle:self.commentsForArticle];
    loading=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loading.color=[UIColor darkGrayColor];
    loading.center=self.tableView.center;
    loading.frame=CGRectMake(loading.frame.origin.x, self.tableView.tableHeaderView.frame.size.height+5, loading.frame.size.width, loading.frame.size.height);
    [self.view addSubview:loading];
    [loading startAnimating];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Comments";
    [self initTableView];
    [self initNavBarButtons];
    [self initCommentsModel];
    [self initAddCommentView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenterAdLoaded:) name:@"adIsLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenterAdFailed:) name:@"adFailedToLoad" object:nil];
    
    if([TabBar bannerIsVisible]){
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, [TabBar adFrame].size.height, 0)];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.addCommentsFlag)
        [self addCommentAction];
    
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

    return comments.count;
}

UITextView *tmpTextView;

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    tmpTextView=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-32, 29)];
    tmpTextView.font=[UIFont systemFontOfSize:14.0];
    tmpTextView.textAlignment=NSTextAlignmentLeft;
    tmpTextView.text=[[comments objectAtIndex:indexPath.row] comment];
    CGSize size = [tmpTextView sizeThatFits:CGSizeMake(tmpTextView.frame.size.width, FLT_MAX)];
    return 85+size.height;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    Comment *com=(Comment*)[comments objectAtIndex:indexPath.row];
    cell.authorLabel.text=com.author;
    cell.CommentTextView.text=com.comment;
    cell.dateLabel.text=[com getTime];

    return cell;
}



#pragma mark - updateWithItems

-(void)updateWithComments:(NSArray *)items{
    comments=items;
    [self.tableView reloadData];
    [loading stopAnimating];
    if(comments.count==0){
        noComments.text=@"No Comments.";
        [noComments setHidden:NO];
    }
    else{
        [noComments setHidden:YES];
    }
}

-(void)failedToDownloadWithError:(NSError *)error{
    [noComments setText:@"Unable to load comments. Try refreshing."];
    [loading stopAnimating];
    noComments.hidden=NO;
}

-(void)initAddCommentView{
    addCommentView=[[UIView alloc] initWithFrame:CGRectMake(0, -220, self.view.frame.size.width, 220)];
    addCommentView.backgroundColor=[UIColor colorWithRed:11.0/255.0 green:120.0/255.0 blue:228.0/255.0 alpha:1];
    addCommentView.hidden=YES;
    addCommentView.layer.masksToBounds = NO;
    addCommentView.layer.shadowOffset = CGSizeMake(0, 8);
    addCommentView.layer.shadowRadius = 5;
    addCommentView.layer.shadowOpacity = 0.5;
    
    UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 50, 20)];
    nameLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
    nameLabel.text=@"Name:";
    nameLabel.textColor=[UIColor whiteColor];
    
    commentAuthorTextField=[[UITextField alloc] initWithFrame:CGRectMake(20, 30, addCommentView.frame.size.width-40, 25)];
    commentAuthorTextField.backgroundColor=[UIColor whiteColor];
    commentAuthorTextField.placeholder=@"Anonymous";
    commentAuthorTextField.layer.cornerRadius=5.0;
    [commentAuthorTextField setBorderStyle:UITextBorderStyleRoundedRect];
    
    commentAuthorTextField.delegate=self;

    UILabel *commentLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 60, 100, 20)];
    commentLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
    commentLabel.text=@"Comment:";
    commentLabel.textColor=[UIColor whiteColor];
    
    commentTextView=[[UITextView alloc] initWithFrame:CGRectMake(20, 80, addCommentView.frame.size.width-40, 80)];
    commentTextView.layer.cornerRadius=5.0;
    commentTextView.layer.borderWidth=2.0;
    commentTextView.layer.borderColor=[UIColor clearColor].CGColor;

    sendButton=[[UIButton alloc] initWithFrame:CGRectMake(addCommentView.frame.size.width/2-65,175, 60, 30)];
    [sendButton setTitle:@"SEND" forState:UIControlStateNormal];
    sendButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:12];
    [sendButton setTitleColor:[UIColor colorWithRed:11.0/255.0 green:120.0/255.0 blue:228.0/255.0 alpha:1] forState:UIControlStateNormal];
    [sendButton setBackgroundColor:[UIColor whiteColor]];
    sendButton.layer.cornerRadius=3.0;
    
    [sendButton addTarget:self action:@selector(sendCommentAction) forControlEvents:UIControlEventTouchUpInside];

    UIButton *cancelButton=[[UIButton alloc] initWithFrame:sendButton.frame];
    cancelButton.frame=CGRectOffset(cancelButton.frame, 70, 0);
    [cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    cancelButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:12];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
   
    [addCommentView addSubview:cancelButton];
    [addCommentView addSubview:sendButton];

    [addCommentView addSubview:nameLabel];
    [addCommentView addSubview:commentLabel];
    [addCommentView addSubview:commentTextView];
    [addCommentView addSubview:commentAuthorTextField];
    [self.view addSubview:addCommentView];
//    [self.navigationController.view bringSubviewToFront:self.navigationController.navigationBar];
    
}

-(void)refreshAction{
    [noComments setHidden:YES];
    [loading startAnimating];
    [model downloadDataForArticleID:articleID isArticle:self.commentsForArticle];
}



-(void)sendCommentAction{
    
    NSString *urlString=@"http://www.theartball.com/admin/iOS/addcomment.php";
    NSString *author=[commentAuthorTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if(author.length==0) author=@"Anonymous";
    NSString *comment=[commentTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if(comment.length==0){
           commentTextView.layer.borderColor=[UIColor redColor].CGColor;
        return;
    }
    
    urlString=[urlString stringByAppendingString:[NSString stringWithFormat:@"?author=%@&comment=%@&article_id=%@",author,comment,articleID]];
    if(self.commentsForArticle)
        urlString=[urlString stringByAppendingString:@"&forArticles=1"];
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    NSString *httpBody=[NSString stringWithFormat:@"author=%@&comment=%@&article_id=%@",author,comment,articleID];
    if(self.commentsForArticle)
        httpBody=[httpBody stringByAppendingString:@"&forArticles=1"];
    [urlRequest setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];


    [NSURLConnection connectionWithRequest:urlRequest delegate:self];

}

BOOL completed;

-(void)addCommentAction{
    
    [self.tableView setScrollEnabled:NO];
    if(addCommentView.hidden){
        addCommentView.hidden=NO;
        [UIView animateWithDuration:0.25 animations:^(){
            addCommentView.frame=CGRectOffset(addCommentView.frame, 0, self.tableView.contentOffset.y+220);
        } completion:^(BOOL finished){
            completed=true;
        }];
    }
    else
        [self cancelAction];
}


-(void)cancelAction{
    [commentTextView endEditing:YES];
    [commentAuthorTextField endEditing:YES];
    if(completed) {
    [UIView animateWithDuration:0.25 animations:^(){
        addCommentView.frame=CGRectOffset(addCommentView.frame, 0, -self.tableView.contentOffset.y-220);
    } completion:^(BOOL finished){
        addCommentView.hidden=YES;
        [commentTextView setText:@""];
        [commentAuthorTextField setText:@""];
        [self.tableView setScrollEnabled:YES];
        commentTextView.layer.borderColor=[UIColor clearColor].CGColor;
        completed=false;
    }];
    }
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self cancelAction];
    [self refreshAction];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Unable to send comment" message:@"Make sure you are connected to internet and try again." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        return;
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 20;
}

-(void)notificationCenterAdLoaded:(NSNotification*) notification{
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, [TabBar adFrame].size.height, 0)];
}

-(void)notificationCenterAdFailed:(NSNotification*) notification{
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
