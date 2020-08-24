/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKBleController.h
* Function : Ble Controller
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.11
***********************************************************************************/

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "OBKEnumList.h"
#import "OBKBleDevice.h"
#import "OBKDeviceUuid.h"

@protocol OBKBleControllerDelegate <NSObject>

- (void)bleConnectError:(id)errorInfo andDevice:(id)bleDevice;

- (void)bleConnectStatus:(DeviceBleStatus)status andDevice:(id)bleDevice;

- (void)bleWriteStatus:(BOOL)Succeed andDevice:(id)bleDevice;

- (void)bleReceiveByteData:(CBCharacteristic *)characteristic andDevice:(id)bleDevice;

- (void)bleResponseMaxByte:(int)responseMax noResponseMaxByte:(int)noResponseMax andDevice:(id)bleDevice;

@end



@interface OBKBleController : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>

@property(assign,nonatomic)id <OBKBleControllerDelegate> delegate;

@property(assign,nonatomic) BOOL isDebug;

@property(strong,nonatomic) NSString *bleDeviceId;

@property(strong,nonatomic) OBKBleDevice *bleDevice;

@property(assign,nonatomic) BleDeviceType bleDeviceType;

@property(assign,nonatomic) DeviceIdType bleDeviceIdType;

- (void)connectBleDevice;

- (void)disconnectBleDevice;

- (void)editCharacteristicNotify:(OBKDeviceUuid *)deviceUuid withStatus:(BOOL)status;

- (void)readCharacteristic:(OBKDeviceUuid *)deviceUuid;

- (void)writeByte:(NSData *)byteData sendCharacteristic:(OBKDeviceUuid *)deviceUuid writeWithResponse:(BOOL)isResponse;

@end
