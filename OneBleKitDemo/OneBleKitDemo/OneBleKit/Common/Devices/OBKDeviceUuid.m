/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKDeviceUuid.m
* Function : Ble Device UUID
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.11
***********************************************************************************/

#import "OBKDeviceUuid.h"

@implementation OBKDeviceUuid

#pragma mark - ****************************** System ******************************
/*-********************************************************************************
* Method: init
* Description: init
* Parameter:
* Return Data:
***********************************************************************************/
- (id)init {
    self.serviceUuid = [[NSString alloc] init];
    self.characteristicUuid = [[NSString alloc] init];
    
    return self;
}


#pragma mark - ****************************** Interface ***************************
/*-********************************************************************************
* Method: setDeviceType
* Description: setDeviceType
* Parameter:
* Return Data:
***********************************************************************************/
- (id)getDeviceUuid:(BleDeviceType)type withIdType:(DeviceUuidType)uuidType andCmdType:(BleCmdType)cmdType {
    if (type == BleDeviceBikeComputer) {
        OBKDeviceUuid *getUuid = [[OBKDeviceUuid alloc] init];
        getUuid.serviceUuid = OBK_SERVICE_UUID;
        getUuid.characteristicUuid = OBK_CHARACTERISTIC_GET;
        
        OBKDeviceUuid *postUuid = [[OBKDeviceUuid alloc] init];
        postUuid.serviceUuid = OBK_SERVICE_UUID;
        postUuid.characteristicUuid = OBK_CHARACTERISTIC_POST;
        
        OBKDeviceUuid *pushUuid = [[OBKDeviceUuid alloc] init];
        pushUuid.serviceUuid = OBK_SERVICE_UUID;
        pushUuid.characteristicUuid = OBK_CHARACTERISTIC_PUSH;
        
        if (uuidType == DeviceUuidNotify) {
            NSMutableArray *uuidArray = [[NSMutableArray alloc] init];
            [uuidArray addObject:getUuid];
            [uuidArray addObject:postUuid];
            [uuidArray addObject:pushUuid];
            return uuidArray;
        }
        else if (uuidType == DeviceUuidWrite) {
            if (cmdType == BleCmdTypeGet) {
                return getUuid;
            }
            else if (cmdType == BleCmdTypePost) {
                return postUuid;
            }
            else if (cmdType == BleCmdTypePush) {
                return pushUuid;
            }
        }
    }
    
    return nil;
}


@end


@implementation OBKDeviceService

#pragma mark - ****************************** System ******************************
/*-********************************************************************************
* Method: init
* Description: init
* Parameter:
* Return Data:
***********************************************************************************/
- (id)init {
    self.characteristicArray = [[NSArray alloc] init];
    self.service = nil;
    
    return self;
}

@end
