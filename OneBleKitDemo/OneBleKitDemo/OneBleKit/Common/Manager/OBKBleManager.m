/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKBleManager.m
* Function : Ble Manager
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.12
***********************************************************************************/

#import "OBKBleManager.h"

@implementation OBKBleManager

#pragma mark - ****************************** System ******************************
/*-********************************************************************************
* Method: init
* Description: init
* Parameter:
* Return Data:
***********************************************************************************/
- (id)init {
    self = [super init];
    self.isConnected = false;
    self.bleController = [[OBKBleController alloc] init];
    self.bleController.delegate = self;
    return self;
}


#pragma mark - ****************************** Interface ***************************
/*-********************************************************************************
* Method: setBleDeviceType
* Description: setBleDeviceType
* Parameter:
* Return Data:
***********************************************************************************/
- (void)setBleDeviceType:(BleDeviceType)type {
    self.deviceType = type;
    if (self.deviceType == BleDeviceBikeComputer) {
        self.baseProtocol = [[OBKBikeComputerProtocol alloc] init];
        self.baseProtocol.delegate = self;
    }
}


/*-********************************************************************************
* Method: connectBleDevice
* Description: connectBleDevice
* Parameter:
* Return Data:
***********************************************************************************/
- (void)connectBleDevice:(NSString *)deviceId andIdType:(DeviceIdType)idType {
    self.bleController.bleDeviceId = deviceId;
    self.bleController.bleDeviceIdType = idType;
    [self.bleController connectBleDevice];
}


/*-********************************************************************************
* Method: connectBleDevice
* Description: connectBleDevice
* Parameter:
* Return Data:
***********************************************************************************/
- (void)disconnectBleDevice {
    [self.bleController disconnectBleDevice];
}


/*-********************************************************************************
* Method: connectBleDevice
* Description: connectBleDevice
* Parameter:
* Return Data:
***********************************************************************************/
- (void)editCharacteristicNotify:(OBKDeviceUuid *)deviceUuid withStatus:(BOOL)status {
    [self.bleController editCharacteristicNotify:deviceUuid withStatus:status];
}


/*-********************************************************************************
* Method: readCharacteristic
* Description: readCharacteristic
* Parameter:
* Return Data:
***********************************************************************************/
- (void)readCharacteristic:(OBKDeviceUuid *)deviceUuid {
    [self.bleController readCharacteristic:deviceUuid];
}


/*-********************************************************************************
* Method: writeByte
* Description: writeByte
* Parameter:
* Return Data:
***********************************************************************************/
- (void)writeByte:(NSData *)byteData sendCharacteristic:(OBKDeviceUuid *)deviceUuid writeWithResponse:(BOOL)isResponse {
    [self.bleController writeByte:byteData sendCharacteristic:deviceUuid writeWithResponse:isResponse];
}


/*-********************************************************************************
* Method: receiveApiCmd
* Description: receiveApiCmd
* Parameter:
* Return Data:
***********************************************************************************/
- (void)receiveApiCmd:(int)cmdId withObject:(id)object {
    [self.baseProtocol receiveBleCmd:cmdId withObject:object];
}


/*-********************************************************************************
* Method: getConnectDevice
* Description: getConnectDevice
* Parameter:
* Return Data:
***********************************************************************************/
- (OBKBleDevice *)getConnectDevice {
    return self.bleController.bleDevice;
}


/*-********************************************************************************
* Method: getConnectDevice
* Description: getConnectDevice
* Parameter:
* Return Data:
***********************************************************************************/
- (void)setDebugMode:(BOOL)isDebugMode {
    self.bleController.isDebug = isDebugMode;
}


#pragma mark - ****************************** Ble Delegate ************************
/*-********************************************************************************
* Method: bleConnectError
* Description: bleConnectError
* Parameter:
* Return Data:
***********************************************************************************/
- (void)bleConnectError:(id)errorInfo andDevice:(id)bleDevice {
    [self.delegate bleConnectError:errorInfo andDevice:self];
}


/*-********************************************************************************
* Method: bleConnectStatus
* Description: bleConnectStatus
* Parameter:
* Return Data:
***********************************************************************************/
- (void)bleConnectStatus:(DeviceBleStatus)status andDevice:(id)bleDevice {
    if (status == DeviceBleConnected) {
        OBKDeviceUuid *uuidClass = [[OBKDeviceUuid alloc] init];
        NSArray *uuidArray = [uuidClass getDeviceUuid:BleDeviceBikeComputer withIdType:DeviceUuidNotify andCmdType:BleCmdTypeGet];
        for (int i = 0; i < uuidArray.count; i++) {
            OBKDeviceUuid *myUuid = [uuidArray objectAtIndex:i];
            [self.bleController editCharacteristicNotify:myUuid withStatus:true];
        }
    }
    else if (status == DeviceBleReconnect) {
        [self.baseProtocol bleErrorDisconnected];
    }
    
    if (status == DeviceBleConnected || status == DeviceBleSynchronization || status == DeviceBleSyncOver || status == DeviceBleSyncFailed) {
        self.isConnected = YES;
    }
    else {
        self.isConnected = NO;
    }
    [self.delegate bleConnectStatus:status andDevice:self];
}


/*-********************************************************************************
* Method: bleWriteStatus
* Description: bleWriteStatus
* Parameter:
* Return Data:
***********************************************************************************/
- (void)bleWriteStatus:(BOOL)Succeed andDevice:(id)bleDevice {
    return;
}


/*-********************************************************************************
* Method: bleReceiveByteData
* Description: bleReceiveByteData
* Parameter:
* Return Data:
***********************************************************************************/
- (void)bleReceiveByteData:(CBCharacteristic *)characteristic andDevice:(id)bleDevice {
    [self.baseProtocol receiveBleData:characteristic];
}


/*-********************************************************************************
* Method: bleResponseMaxByte
* Description: bleResponseMaxByte
* Parameter:
* Return Data:
***********************************************************************************/
- (void)bleResponseMaxByte:(int)responseMax noResponseMaxByte:(int)noResponseMax andDevice:(id)bleDevice {
    [self.baseProtocol setResponseMaxByte:responseMax noResponseMaxByte:noResponseMax];
}


#pragma mark - ****************************** Protocol Delegate *******************
/*-********************************************************************************
* Method: writeBleByte
* Description: writeBleByte
* Parameter:
* Return Data:
***********************************************************************************/
- (void)writeBleByte:(NSData *)byteData withUuid:(OBKDeviceUuid *)deviceUuid isResponse:(BOOL)isResponse andDevice:(id)bleDevice {
    [self.bleController writeByte:byteData sendCharacteristic:deviceUuid writeWithResponse:isResponse];
}


/*-********************************************************************************
* Method: analyticalBleData
* Description: analyticalBleData
* Parameter:
* Return Data:
***********************************************************************************/
- (void)analyticalBleData:(id)resultData withResultId:(int)resultId andDevice:(id)bleDevice {
    [self.delegate bleResultData:resultData withResultId:resultId andDevice:self];
}


/*-********************************************************************************
* Method: synchronizationStatus
* Description: synchronizationStatus
* Parameter:
* Return Data:
***********************************************************************************/
- (void)synchronizationStatus:(DeviceBleStatus)status andDevice:(id)bleDevice {
    [self.delegate bleConnectStatus:status andDevice:self];
}


@end
