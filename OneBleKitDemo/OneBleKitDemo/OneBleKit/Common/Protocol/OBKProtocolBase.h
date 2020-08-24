/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKProtocolBase.h
* Function : Base Protocol
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.14
***********************************************************************************/

#import <Foundation/Foundation.h>
#import "OBKEnumList.h"
#import "OBKDeviceUuid.h"

@protocol OBKProtocolBaseDelegate <NSObject>

- (void)writeBleByte:(NSData *)byteData withUuid:(OBKDeviceUuid *)deviceUuid isResponse:(BOOL)isResponse andDevice:(id)bleDevice;

- (void)analyticalBleData:(id)resultData withResultId:(int)resultId andDevice:(id)bleDevice;

- (void)synchronizationStatus:(DeviceBleStatus)status andDevice:(id)bleDevice;

@end


@interface OBKProtocolBase : NSObject

@property(assign,nonatomic)id <OBKProtocolBaseDelegate> delegate;

- (void)receiveBleCmd:(int)cmdId withObject:(id)object;

- (void)receiveBleData:(CBCharacteristic *)characteristic;

- (void)setResponseMaxByte:(int)responseMax noResponseMaxByte:(int)noResponseMax;

- (void)bleErrorDisconnected;

@end
