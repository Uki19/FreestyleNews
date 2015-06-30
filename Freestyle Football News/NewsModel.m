//
//  NewsModel.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/17/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import "NewsModel.h"
#import "NewsItem.h"

@implementation NewsModel

@synthesize downloadedData;
@synthesize delegate;


#pragma mark - Connection methods and json serialization

-(void)downloadDataAtUrl:(NSString *)url{
    
    NSURL *jsonURL=[NSURL URLWithString:url];
    NSURLRequest *request=[NSURLRequest requestWithURL:jsonURL];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    downloadedData=[[NSMutableData alloc] init];
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [downloadedData appendData:data];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    if(self.delegate)
        [self.delegate failedToDownloadWithError:error];
    
}



-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSMutableArray *receivedNews=[[NSMutableArray alloc] init];
    NSError *error;
    NSArray *jsonArray=[NSJSONSerialization JSONObjectWithData:downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    for(int i=0;i<jsonArray.count;i++){
        NSDictionary *newsDictionary=jsonArray[i];
        NewsItem* newsItem=[[NewsItem alloc] init];
        newsItem.title=newsDictionary[@"Title"];
        newsItem.content=newsDictionary[@"Content"];
        newsItem.category=newsDictionary[@"Category"];
        newsItem.imageURL=newsDictionary[@"Image"];
        newsItem.author=newsDictionary[@"Author"];
        newsItem.date=newsDictionary[@"Date"];
        newsItem.important=[newsDictionary[@"Important"] isEqualToString:@"0"]?NO:YES;
        
        [receivedNews addObject:newsItem];
    }
    
    if(self.delegate)
        [self.delegate updateWithItems:receivedNews];
    
    
}


@end
