/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKBleScanner.h
* Function : Ble Scanner
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.11
***********************************************************************************/

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol OBKBleScannerDelegate <NSObject>

- (void)phoneBleStatus:(BOOL)isPoweredOn;

- (void)scanDeviceResult:(NSArray *)devices;

@end


@interface OBKBleScanner : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

@property(assign,nonatomic) id <OBKBleScannerDelegate> delegate;

@property(assign,nonatomic) int limitRssi;

@property(assign,nonatomic) BOOL isRealTime;

@property(strong,nonatomic) NSArray *limitNameArray;

@property(strong,nonatomic) NSArray *uuidArray;

- (void)startScanBleDevice;

- (void)stopScanBleDevice;

@end

