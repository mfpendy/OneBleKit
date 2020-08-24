/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKDateTools.h
* Function : Date Tools
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.11
***********************************************************************************/

#import <Foundation/Foundation.h>

@interface OBKDateTools : NSObject

// Date to format string
- (NSString *)dateToString:(NSDate *)date withType:(NSString *)type;

// Date To Timestamp
- (double)dateToTimestamp:(NSDate*)myDate;

// Date String To Timestamp
- (double)dateStringToTimestamp:(NSString *)dateString;

// Get Time Zone Number
- (int)getTimeZoneNumber:(NSDate *)anyDate;

@end
