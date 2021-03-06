//
//  CommentsModel.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 10/6/15.
//  Copyright © 2015 Uros Zivaljevic. All rights reserved.
//

#import "CommentsModel.h"
#import "Comment.h"

@implementation CommentsModel

@synthesize downloadedData;

-(void)downloadDataForArticleID:(NSString *)articleID isArticle:(BOOL)isArticle{
    
    NSString *urlString=[NSString stringWithFormat:@"http://www.theartball.com/admin/iOS/getcomments.php?article_id=%@",articleID];
    if(isArticle)
        urlString=[urlString stringByAppendingString:@"&forArticles=1"];
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    downloadedData=[[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if(self.delegate)
        [self.delegate failedToDownloadWithError:error];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [downloadedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSMutableArray *comments=[[NSMutableArray alloc] init];
    NSError *error;
    NSArray *jsonArray=[NSJSONSerialization JSONObjectWithData:downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    for(int i=0;i<jsonArray.count;i++){
        NSDictionary *commentDict=jsonArray[i];
        Comment *comment=[[Comment alloc] init];
        comment.author=commentDict[@"author"];
        comment.time=commentDict[@"time"];
        comment.comment=commentDict[@"comment"];
        [comments addObject:comment];
    }
    
    if(self.delegate){
        [self.delegate updateWithComments:comments];
    }
}

@end
