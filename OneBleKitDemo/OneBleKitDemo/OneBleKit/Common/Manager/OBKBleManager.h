/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKBleManager.h
* Function : Ble Manager
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.12
***********************************************************************************/

#import <Foundation/Foundation.h>
#import "OBKBleController.h"
#import "OBKProtocolBase.h"
#import "OBKBikeComputerProtocol.h"

@protocol OBKBleManagerDelegate <NSObject>

- (void)bleConnectError:(id)errorInfo andDevice:(id)bleDevice;

- (void)bleConnectStatus:(DeviceBleStatus)status andDevice:(id)bleDevice;

- (void)bleResultData:(id)resultData withResultId:(int)resultId andDevice:(id)bleDevice;

@end


@interface OBKBleManager : NSObject <OBKBleControllerDelegate, OBKProtocolBaseDelegate>

@property(assign,nonatomic)id <OBKBleManagerDelegate> delegate;

@property (assign,nonatomic) BleDeviceType deviceType;

@property (assign,nonatomic) BOOL isConnected;

@property (strong,nonatomic) OBKBleController *bleController;

@property (strong,nonatomic) OBKProtocolBase *baseProtocol;

- (void)setBleDeviceType:(BleDeviceType)type;

- (void)connectBleDevice:(NSString *)deviceId andIdType:(DeviceIdType)idType;

- (void)disconnectBleDevice;

- (void)editCharacteristicNotify:(OBKDeviceUuid *)deviceUuid withStatus:(BOOL)status;

- (void)readCharacteristic:(OBKDeviceUuid *)deviceUuid;

- (void)writeByte:(NSData *)byteData sendCharacteristic:(OBKDeviceUuid *)deviceUuid writeWithResponse:(BOOL)isResponse;

- (void)receiveApiCmd:(int)cmdId withObject:(id)object;

- (OBKBleDevice *)getConnectDevice;

- (void)setDebugMode:(BOOL)isDebugMode;

@end
