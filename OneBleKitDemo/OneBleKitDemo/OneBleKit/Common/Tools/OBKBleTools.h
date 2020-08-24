/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKBleTools.h
* Function : Ble Tools
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.11
***********************************************************************************/

#import <Foundation/Foundation.h>
#import "OBKAnalyValues.h"
#import "OBKEnumList.h"

@interface OBKBleTools : NSObject

// Get Value Data
- (OBKAnalyValues *)getValueData:(NSData *)value;

// Is CRC Check Succeed
- (BOOL)isCRCCheckSucceed:(NSData *)value;

// Stitching Data
- (NSData *)stitchingData:(BleCmdType)cmdType withTrans:(BleTransType)transType andSid:(int)sid data:(NSData *)value;

// Check CRC Data
- (NSData *)CheckCRCData:(NSData *)cmdData;

// translation Data
- (NSData *)translationData:(NSData *)cmdData isSend:(BOOL)isSend;

// bale Cmd Data
- (NSData *)baleCmdData:(NSData *)cmdData isSend:(BOOL)isSend;

// get Package Status
- (BlePackageStatus)getPackageStatus:(NSData *)cmdData;

// Get Bit Number
- (int)getBitNumber:(int)dataNumber withStart:(int)start andEnd:(int)stop;

@end
