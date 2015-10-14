//
//  CommentsInArticle.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 10/13/15.
//  Copyright © 2015 Uros Zivaljevic. All rights reserved.
//

#import "CommentsInArticle.h"

@implementation CommentsInArticle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // No need to re-assign self here... owner:self is all you need to get
        // your outlet wired up...
        UIView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"CommentsInArticleView" owner:self options:nil] lastObject];
        // now add the view to ourselves...
        [xibView setFrame:[self bounds]];
       
        [self addSubview:self.commentAuthor];
        [self addSubview:xibView]; // we automatically retain this with -addSubview:
        
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
