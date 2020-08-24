/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKBleDevice.h
* Function : Ble Device
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.11
***********************************************************************************/

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface OBKBleDevice : NSObject

@property (assign, nonatomic) int rssi;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *uuidString;
@property (strong, nonatomic) NSString *macAddress;
@property (strong, nonatomic) NSString *idString;
@property (strong, nonatomic) NSDictionary *advertisementData;
@property (strong, nonatomic) CBPeripheral *peripheral;

@end
