/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKApiBase.m
* Function : Base Api
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.15
***********************************************************************************/

#import "OBKApiBase.h"

@implementation OBKApiBase

#pragma mark - ****************************** System ******************************
/*-********************************************************************************
* Method: init
* Description: init
* Parameter:
* Return Data:
***********************************************************************************/
- (id)init {
    self = [super init];
    self.bleManager = [[OBKBleManager alloc] init];
    self.bleManager.delegate = self;
    self.deviceId = [[NSString alloc] init];
    return self;
}


#pragma mark - ****************************** Interface ***************************
/*-********************************************************************************
* Method: connectBleDevice
* Description: connectBleDevice
* Parameter:
* Return Data:
***********************************************************************************/
- (void)connectBleDevice:(NSString *)deviceId andIdType:(DeviceIdType)idType {
    self.deviceId = deviceId;
    [self.bleManager connectBleDevice:deviceId andIdType:idType];
}


/*-********************************************************************************
* Method: connectBleDevice
* Description: connectBleDevice
* Parameter:
* Return Data:
***********************************************************************************/
- (void)disconnectBleDevice {
    [self.bleManager disconnectBleDevice];
}


/*-********************************************************************************
* Method: connectBleDevice
* Description: connectBleDevice
* Parameter:
* Return Data:
***********************************************************************************/
- (void)editCharacteristicNotify:(OBKDeviceUuid *)deviceUuid withStatus:(BOOL)status {
    [self.bleManager editCharacteristicNotify:deviceUuid withStatus:status];
}


/*-********************************************************************************
* Method: readCharacteristic
* Description: readCharacteristic
* Parameter:
* Return Data:
***********************************************************************************/
- (void)readCharacteristic:(OBKDeviceUuid *)deviceUuid {
    [self.bleManager readCharacteristic:deviceUuid];
}


/*-********************************************************************************
* Method: writeByte
* Description: writeByte
* Parameter:
* Return Data:
***********************************************************************************/
- (void)writeByte:(NSData *)byteData sendCharacteristic:(OBKDeviceUuid *)deviceUuid writeWithResponse:(BOOL)isResponse {
    [self.bleManager writeByte:byteData sendCharacteristic:deviceUuid writeWithResponse:isResponse];
}


/*-********************************************************************************
* Method: getConnectDevice
* Description: getConnectDevice
* Parameter:
* Return Data:
***********************************************************************************/
- (OBKBleDevice *)getConnectDevice {
    return [self.bleManager getConnectDevice];
}


/*-********************************************************************************
* Method: getConnectDevice
* Description: getConnectDevice
* Parameter:
* Return Data:
***********************************************************************************/
- (void)setDebugMode:(BOOL)isDebug {
    [self.bleManager setDebugMode:isDebug];
}


#pragma mark - ****************************** Ble Delegate ************************
/*-********************************************************************************
* Method: bleConnectError
* Description: bleConnectError
* Parameter:
* Return Data:
***********************************************************************************/
- (void)bleConnectError:(id)errorInfo andDevice:(id)bleDevice {
    [self.baseDelegate bleConnectError:errorInfo andDevice:self];
}


/*-********************************************************************************
* Method: bleConnectStatus
* Description: bleConnectStatus
* Parameter:
* Return Data:
***********************************************************************************/
- (void)bleConnectStatus:(DeviceBleStatus)status andDevice:(id)bleDevice {
    if (status == DeviceBleConnected || status == DeviceBleSynchronization || status == DeviceBleSyncOver || status == DeviceBleSyncFailed) {
        self.isConnected = YES;
    }
    else {
        self.isConnected = NO;
    }
    [self.baseDelegate bleConnectStatus:status andDevice:self];
}


/*-********************************************************************************
* Method: bleResultData
* Description: bleResultData
* Parameter:
* Return Data:
***********************************************************************************/
- (void)bleResultData:(id)resultData withResultId:(int)resultId andDevice:(id)bleDevice {
}


@end
