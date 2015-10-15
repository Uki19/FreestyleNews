//
//  FreestyleShopModel.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 10/15/15.
//  Copyright © 2015 Uros Zivaljevic. All rights reserved.
//

#import "FreestyleShopModel.h"
#import "ShopItem.h"

@implementation FreestyleShopModel

@synthesize downloadedData;

-(void)downloadData{
    NSString *urlString=[NSString stringWithFormat:@"http://www.theartball.com/admin/iOS/get-shop-items.php"];
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
    NSMutableArray *shopItemsArray=[[NSMutableArray alloc] init];
    NSError *error;
    NSArray *jsonArray=[NSJSONSerialization JSONObjectWithData:downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    for(int i=0;i<jsonArray.count;i++){
        NSDictionary *itemDict=jsonArray[i];
        ShopItem *shopItem=[[ShopItem alloc] init];
        shopItem.itemTitle=itemDict[@"title"];
        shopItem.itemDescription=itemDict[@"description"];
        shopItem.itemPrice=itemDict[@"price"];
        shopItem.itemSeller=itemDict[@"seller"];
        shopItem.itemContact=itemDict[@"contact"];
        [shopItem.itemImages addObject:itemDict[@"image1"]];
        [shopItem.itemImages addObject:itemDict[@"image2"]];
        [shopItem.itemImages addObject:itemDict[@"image3"]];
        
        [shopItemsArray addObject:shopItem];
    }
    
    if(self.delegate){
        [self.delegate updateWithItems:shopItemsArray];
    }
}





@end
