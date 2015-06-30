//
//  ArticlesModel.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/19/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import "ArticlesModel.h"
#import "NewsItem.h"


@implementation ArticlesModel

@synthesize downloadedData;
@synthesize delegate;

#pragma mark - Connection methods and json serialization

-(void)downloadData{
    
    NSURL *jsonURL=[NSURL URLWithString:@"http://ineco-posredovanje.co.rs/apptest/getarticles.php"];
    NSURLRequest *request=[NSURLRequest requestWithURL:jsonURL];
    [NSURLConnection connectionWithRequest:request delegate:self];

}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    downloadedData=[[NSMutableData alloc] init];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if(self.delegate){
        [self.delegate failedToDownloadWithError:error];
    }
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [downloadedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{

    NSMutableArray* receivedArticles=[[NSMutableArray alloc] init];
    NSError *error;
    NSArray *jsonArray=[NSJSONSerialization JSONObjectWithData:downloadedData options:NSJSONReadingAllowFragments error:&error];
    for(int i=0;i<jsonArray.count;i++){
        NSDictionary *articlesDictionary=jsonArray[i];
        NewsItem *article=[[NewsItem alloc] init];
        article.title=articlesDictionary[@"Title"];
        article.content=articlesDictionary[@"Content"];
        article.author=articlesDictionary[@"Author"];
        article.imageURL=articlesDictionary[@"Image"];
        article.date=articlesDictionary[@"Date"];
        [receivedArticles addObject:article];
    }
    
    if(self.delegate){
        [self.delegate updateWithItems:receivedArticles];
    }
        
}

@end
