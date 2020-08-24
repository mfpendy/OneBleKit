/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKBleDevice.m
* Function : Ble Device
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.11
***********************************************************************************/

#import "OBKBleDevice.h"

@implementation OBKBleDevice

#pragma mark - ****************************** System ******************************
/*-********************************************************************************
* Method: init
* Description: init
* Parameter:
* Return Data:
***********************************************************************************/
- (id)init {
    self.rssi = 0;
    self.name = [[NSString alloc] init];
    self.uuidString = [[NSString alloc] init];
    self.macAddress = [[NSString alloc] init];
    self.idString = [[NSString alloc] init];
    self.advertisementData = [[NSDictionary alloc] init];
    self.peripheral = nil;
    
    return self;
}

@end
