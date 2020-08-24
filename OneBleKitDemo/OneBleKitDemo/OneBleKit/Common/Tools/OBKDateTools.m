/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKDateTools.m
* Function : Date Tools
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.11
***********************************************************************************/

#import "OBKDateTools.h"

@implementation OBKDateTools

/*-********************************************************************************
* Method: DateToString
* Description: Date to format string
* Parameter:
* Return Data:
***********************************************************************************/
- (NSString *)dateToString:(NSDate *)date withType:(NSString *)type {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:type];
    NSString *resultString = [dateFormatter stringFromDate:date];
    return resultString;
}


/*-********************************************************************************
* Method: dateToTimestamp
* Description: Date To Timestamp
* Parameter:
* Return Data:
***********************************************************************************/
- (double)dateToTimestamp:(NSDate*)myDate {
    double resultNumber = [myDate timeIntervalSince1970];
    return resultNumber;
}


/*-********************************************************************************
* Method: dateStringToTimestamp
* Description: Date String To Timestamp
* Parameter:
* Return Data:
***********************************************************************************/
- (double)dateStringToTimestamp:(NSString *)dateString {
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [myFormatter dateFromString:dateString];
    double resultNumber = [nowDate timeIntervalSince1970];
    return resultNumber;
}


/*-********************************************************************************
* Method: getTimeZoneNumber
* Description: Get Time Zone Number
* Parameter:
* Return Data:
***********************************************************************************/
- (int)getTimeZoneNumber:(NSDate *)anyDate {
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//Or GMT
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    return interval;
}


@end
