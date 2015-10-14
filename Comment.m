//
//  Comment.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 10/6/15.
//  Copyright © 2015 Uros Zivaljevic. All rights reserved.
//

#import "Comment.h"

@implementation Comment

-(NSString*)getTime{
    
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd. MMM yy 'at' HH:mm"];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDate *localDate=[df dateFromString:self.time];
  
    df.timeZone=[NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
//    [df setDoesRelativeDateFormatting:YES];
    NSString *localTimeString=[df stringFromDate:localDate];
    NSDate *newDate=[df dateFromString:self.time];
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:newDate];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
//    
//    NSDateComponents *yesterday = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
//    [yesterday setDay:-1];
    

//    [today setDay:-1];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1];
    NSDate *yesterdayDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0];
    NSDateComponents *yesterday = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:yesterdayDate];

    if([today day] == [otherDay day] &&
       [today month] == [otherDay month] &&
       [today year]==[otherDay year]) {
        localTimeString=[NSString stringWithFormat:@"Today at%@",[[localTimeString componentsSeparatedByString:@"at"] objectAtIndex:1]];
    }
    if([yesterday day] == [otherDay day] &&
       [yesterday month] == [otherDay month] &&
       [yesterday year]==[otherDay year]) {
        localTimeString=[NSString stringWithFormat:@"Yesterday at%@",[[localTimeString componentsSeparatedByString:@"at"] objectAtIndex:1]];
    }
    return localTimeString;
}

@end
