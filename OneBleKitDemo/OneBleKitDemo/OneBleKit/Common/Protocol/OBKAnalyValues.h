/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKAnalyValues.h
* Function : Analy Values
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.18
***********************************************************************************/

#import <Foundation/Foundation.h>
#import "OBKEnumList.h"

@interface OBKAnalyValues : NSObject

@property (assign, nonatomic) int oidNumber;
@property (assign, nonatomic) int sidNumber;
@property (assign, nonatomic) BleCmdType cmdType;
@property (assign, nonatomic) BleTransType transType;
@property (strong, nonatomic) NSData *valueData;

- (void)logClass ;

@end
