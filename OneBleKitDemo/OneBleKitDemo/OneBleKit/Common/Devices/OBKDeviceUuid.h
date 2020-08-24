/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKDeviceUuid.h
* Function : Ble Device UUID
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.11
***********************************************************************************/

#define   OBK_SERVICE_UUID          @"FDA0"  // Service
#define   OBK_CHARACTERISTIC_GET    @"FDA1"  // Get
#define   OBK_CHARACTERISTIC_POST   @"FDA2"  // Post
#define   OBK_CHARACTERISTIC_PUSH   @"FDA3"  // Push

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "OBKEnumList.h"

@interface OBKDeviceUuid : NSObject

@property (strong, nonatomic) NSString *serviceUuid;
@property (strong, nonatomic) NSString *characteristicUuid;

- (id)getDeviceUuid:(BleDeviceType)type withIdType:(DeviceUuidType)uuidType andCmdType:(BleCmdType)cmdType;

@end


@interface OBKDeviceService : NSObject

@property (strong, nonatomic) NSArray *characteristicArray;
@property (strong, nonatomic) CBService *service;

@end
