/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKApiBase.h
* Function : Base Api
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.15
***********************************************************************************/

#import <Foundation/Foundation.h>
#import "OBKBleManager.h"

@protocol OBKApiBsaeDelegate <NSObject>

- (void)bleConnectError:(id)errorInfo andDevice:(id)bleDevice;

- (void)bleConnectStatus:(DeviceBleStatus)status andDevice:(id)bleDevice;

@end


@interface OBKApiBase : NSObject <OBKBleManagerDelegate>

@property(assign,nonatomic)id <OBKApiBsaeDelegate> baseDelegate;

@property (strong,nonatomic) OBKBleManager *bleManager;

@property (assign,nonatomic) BleDeviceType deviceType;

@property (strong,nonatomic) NSString *deviceId;

@property (assign,nonatomic) BOOL isConnected;

- (void)connectBleDevice:(NSString *)deviceId andIdType:(DeviceIdType)idType;

- (void)disconnectBleDevice;

- (void)editCharacteristicNotify:(OBKDeviceUuid *)deviceUuid withStatus:(BOOL)status;

- (void)readCharacteristic:(OBKDeviceUuid *)deviceUuid;

- (void)writeByte:(NSData *)byteData sendCharacteristic:(OBKDeviceUuid *)deviceUuid writeWithResponse:(BOOL)isResponse;

- (OBKBleDevice *)getConnectDevice;

- (void)setDebugMode:(BOOL)isDebug;

@end
