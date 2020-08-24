/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKBleController.m
* Function : Ble Controller
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.11
***********************************************************************************/

#import "OBKBleController.h"

@implementation OBKBleController {
    CBCentralManager *m_manager;              // 控制器
    CBPeripheral     *m_peripheral;           // 连接的蓝牙
    NSMutableArray   *m_devicesArray;         // 设备列表
    NSMutableArray   *m_servicesArray;        // 服务通道列表
    int              m_checkServiceNum;       // 连接service的个数
}


#pragma mark - ****************************** System ******************************
/*-********************************************************************************
* Method: init
* Description: init
* Parameter:
* Return Data:
***********************************************************************************/
- (id)init {
    self = [super init];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:NO],
                             CBCentralManagerOptionShowPowerAlertKey,
                             nil];
    m_manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:options];
    m_devicesArray  = [[NSMutableArray alloc] init];
    m_servicesArray = [[NSMutableArray alloc] init];
    m_checkServiceNum  = 0;
    self.isDebug = false;
    return self;
}


#pragma mark - ****************************** Interface ***************************
/*-********************************************************************************
* Method: connectBleDevice
* Description: connectBleDevice
* Parameter:
* Return Data:
***********************************************************************************/
- (void)connectBleDevice {
    [m_devicesArray removeAllObjects];
    if (![self getSettingConnectedBlue:self.bleDeviceId]) {
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES],
                                 CBCentralManagerOptionShowPowerAlertKey,
                                 [NSNumber numberWithBool:YES],
                                 CBCentralManagerScanOptionAllowDuplicatesKey, nil];
        [m_manager scanForPeripheralsWithServices:nil options:options];
    }
}


/*-********************************************************************************
* Method: disconnectBleDevice
* Description: disconnectBleDevice
* Parameter:
* Return Data:
***********************************************************************************/
- (void)disconnectBleDevice {
    [m_manager stopScan];
    
    if (m_peripheral.name != nil) {
        [m_manager cancelPeripheralConnection:m_peripheral];
        self.bleDeviceId = @"";
        m_peripheral = nil;
        [self.delegate bleConnectStatus:DeviceBleDisconneced andDevice:self];
    }
}


/*-********************************************************************************
* Method: editCharacteristicNotify
* Description: editCharacteristicNotify
* Parameter:
* Return Data:
***********************************************************************************/
- (void)editCharacteristicNotify:(OBKDeviceUuid *)deviceUuid withStatus:(BOOL)status {
    for (int i = 0; i < m_servicesArray.count; i++) {
        OBKDeviceService *myService = [m_servicesArray objectAtIndex:i];
        if ([myService.service.UUID isEqual:[CBUUID UUIDWithString:deviceUuid.serviceUuid]]) {
            for (CBCharacteristic *charac in myService.characteristicArray) {
                if ([charac.UUID isEqual:[CBUUID UUIDWithString:deviceUuid.characteristicUuid]]) {
                    if (m_peripheral != nil) {
                        [m_peripheral setNotifyValue:status forCharacteristic:charac];
                        if (self.isDebug) {
                            NSLog(@"editCharacteristicNotify %@ %i",deviceUuid.characteristicUuid, status);
                        }
                        break;
                    }
                }
            }
            
            break;
        }
    }
}


/*-********************************************************************************
* Method: readCharacteristic
* Description: readCharacteristic
* Parameter:
* Return Data:
***********************************************************************************/
- (void)readCharacteristic:(OBKDeviceUuid *)deviceUuid {
    for (int i = 0; i < m_servicesArray.count; i++) {
        OBKDeviceService *myService = [m_servicesArray objectAtIndex:i];
        if ([myService.service.UUID isEqual:[CBUUID UUIDWithString:deviceUuid.serviceUuid]]) {
            for (CBCharacteristic *charac in myService.characteristicArray) {
                if ([charac.UUID isEqual:[CBUUID UUIDWithString:deviceUuid.characteristicUuid]]) {
                    if (m_peripheral != nil) {
                        [m_peripheral readValueForCharacteristic:charac];
                        if (self.isDebug) {
                            NSLog(@"readCharacteristic %@",deviceUuid.characteristicUuid);
                        }
                        break;
                    }
                }
            }
            break;
        }
    }
}


/*-********************************************************************************
* Method: writeByte
* Description: writeByte
* Parameter:
* Return Data:
***********************************************************************************/
- (void)writeByte:(NSData *)byteData sendCharacteristic:(OBKDeviceUuid *)deviceUuid writeWithResponse:(BOOL)isResponse {
    for (int i = 0; i < m_servicesArray.count; i++) {
        OBKDeviceService *myService = [m_servicesArray objectAtIndex:i];
        if ([myService.service.UUID isEqual:[CBUUID UUIDWithString:deviceUuid.serviceUuid]]) {
            for (CBCharacteristic *charac in myService.characteristicArray) {
                if ([charac.UUID isEqual:[CBUUID UUIDWithString:deviceUuid.characteristicUuid]]) {
                    if (isResponse) {
                        if (m_peripheral != nil) {
                            [m_peripheral writeValue:byteData forCharacteristic:charac type:CBCharacteristicWriteWithResponse];
                            if (self.isDebug) {
                                NSLog(@"writeByte %@ %@ %i",byteData,deviceUuid.characteristicUuid,isResponse);
                            }
                        }
                    }
                    else {
                        if (m_peripheral != nil) {
                            [m_peripheral writeValue:byteData forCharacteristic:charac type:CBCharacteristicWriteWithoutResponse];
                            if (self.isDebug) {
                                NSLog(@"writeByte %@ %@ %i",byteData,deviceUuid.characteristicUuid,isResponse);
                            }
                        }
                    }
                }
            }
            break;
        }
    }
}


#pragma mark - ****************************** Data Edited *************************
/*-********************************************************************************
* Method: getSettingConnectedBlue
* Description: getSettingConnectedBlue
* Parameter:
* Return Data:
***********************************************************************************/
- (BOOL)getSettingConnectedBlue:(NSString *)UUIDString {
    if (self.bleDeviceIdType != DeviceIdUUID) {
        return false;
    }
    
    if (self.bleDeviceId == nil) {
        return false;
    }
    
    NSArray *UUIDArray = [[NSArray alloc] initWithObjects:[[NSUUID UUID] initWithUUIDString:UUIDString], nil];
    NSArray *settingBlueArray = [m_manager retrievePeripheralsWithIdentifiers:UUIDArray];
    
    if ([settingBlueArray isKindOfClass:[NSArray class]]) {
        if (settingBlueArray.count > 0) {
            for (int i = 0; i < settingBlueArray.count; i++) {
                CBPeripheral *nowPeripheral = [settingBlueArray objectAtIndex:i];
                if ([self.bleDeviceId isEqualToString:nowPeripheral.identifier.UUIDString]) {
                    [m_manager stopScan];
                    m_peripheral = nowPeripheral;
                    [m_devicesArray addObject:m_peripheral];
                    [m_manager connectPeripheral:m_peripheral options:nil];
                    return YES;
                }
            }
        }
    }
    
    return NO;
}


/*-********************************************************************************
* Method: compareId
* Description: compareId
* Parameter:
* Return Data:
***********************************************************************************/
- (BOOL)compareId:(NSString *)idString andDevice:(OBKBleDevice *)bleDevice {
    BOOL isIdEqual = NO;
    if (idString.length == 0) {
        return isIdEqual;
    }
    
    if (self.bleDeviceIdType == DeviceIdUUID) {
        NSString *UUIDString = bleDevice.uuidString;
        if ([idString isEqualToString:UUIDString]) {
            isIdEqual = YES;
        }
    }
//    else if (self.bleDeviceIdType == DeviceIdMacAdress) {
//        NSData *byteData = [bleDevice.advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
//        NSString *macString = [FBKSpliceBle bleDataToString:byteData];
//        NSString *MACAddress = [FBKSpliceBle getMacAddress:macString];
//        if ([idString isEqualToString:MACAddress]) {
//            isIdEqual = YES;
//        }
//    }
//    else if (self.bleDeviceIdType == DeviceIdName) {
//        NSString *peripheralName = bleDevice.name;
//        if ([peripheralName hasSuffix:idString]) {
//            isIdEqual = YES;
//        }
//    }
//    else {
//        NSData *byteData = [bleDevice.advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
//        NSString *myIdString = [FBKSpliceBle analyticalDeviceId:byteData];
//        if ([idString isEqualToString:myIdString]) {
//            isIdEqual = YES;
//        }
//    }
    
    return isIdEqual;
}


#pragma mark - ****************************** Ble Delegate ************************
/*-********************************************************************************
* Method: centralManagerDidUpdateState
* Description: centralManagerDidUpdateState
* Parameter:
* Return Data:
***********************************************************************************/
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBManagerStatePoweredOn: {
            [self.delegate bleConnectStatus:DeviceBleIsOpen andDevice:self];
            break;
        }
        default: {
            [self.delegate bleConnectStatus:DeviceBleClosed andDevice:self];
            break;
        }
    }
}


/*-********************************************************************************
* Method: didDiscoverPeripheral
* Description: didDiscoverPeripheral
* Parameter:
* Return Data:
***********************************************************************************/
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSString *bleName = @"Unnamed";
    if (peripheral.name != nil) {
        bleName = peripheral.name;
    }
    
    OBKBleDevice *myDevice = [[OBKBleDevice alloc] init];
    myDevice.name = bleName;
    myDevice.rssi = [RSSI intValue];
    myDevice.advertisementData = advertisementData;
    myDevice.uuidString = peripheral.identifier.UUIDString;
    myDevice.macAddress = @"";
    myDevice.idString = @"";
    myDevice.peripheral = peripheral;
    
    if ([self compareId:self.bleDeviceId andDevice:myDevice]) {
        self.bleDevice = myDevice;
        [m_manager stopScan];
        m_peripheral = peripheral;
        [m_devicesArray addObject:m_peripheral];
        [m_manager connectPeripheral:m_peripheral options:nil];
    }
    
}


/*-********************************************************************************
* Method: didConnectPeripheral
* Description: didConnectPeripheral
* Parameter:
* Return Data:
***********************************************************************************/
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [self.delegate bleConnectStatus:DeviceBleConnecting andDevice:self];
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
}


/*-********************************************************************************
* Method: didFailToConnectPeripheral
* Description: didFailToConnectPeripheral
* Parameter:
* Return Data:
***********************************************************************************/
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [self.delegate bleConnectError:error andDevice:self];
}


/*-********************************************************************************
* Method: didDiscoverServices
* Description: didDiscoverServices
* Parameter:
* Return Data:
***********************************************************************************/
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        [self.delegate bleConnectError:error andDevice:self];
        return;
    }
    
    [m_servicesArray removeAllObjects];
    m_checkServiceNum = 0;
    for (CBService *service in peripheral.services) {
        m_checkServiceNum = m_checkServiceNum + 1;
        [peripheral discoverCharacteristics:nil forService:service];
        
        if (self.isDebug) {
            NSLog(@"didDiscoverServices %@",service.UUID.UUIDString);
        }
    }
}


/*-********************************************************************************
* Method: didDiscoverCharacteristicsForService
* Description: didDiscoverCharacteristicsForService
* Parameter:
* Return Data:
***********************************************************************************/
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        [self.delegate bleConnectError:error andDevice:self];
        return;
    }
    
    NSMutableArray *myCharacteristicsArray = [[NSMutableArray alloc] init];
    for (CBCharacteristic *charac in service.characteristics) {
        [myCharacteristicsArray addObject:charac];
        if (self.isDebug) {
            NSLog(@"didDiscoverCharacteristicsForService %@",charac.UUID.UUIDString);
        }
    }
    
    OBKDeviceService *myService = [[OBKDeviceService alloc] init];
    myService.service = service;
    myService.characteristicArray = myCharacteristicsArray;
    [m_servicesArray addObject:myService];
    
    if (m_checkServiceNum == m_servicesArray.count) {
        int maxResponse = (int)[peripheral maximumWriteValueLengthForType:CBCharacteristicWriteWithResponse];
        int maxNoResponse = (int)[peripheral maximumWriteValueLengthForType:CBCharacteristicWriteWithoutResponse];
        [self.delegate bleResponseMaxByte:maxResponse noResponseMaxByte:maxNoResponse andDevice:self];
        [self.delegate bleConnectStatus:DeviceBleConnected andDevice:self];
        NSLog(@"m_checkServiceNum ----------------------%i--%i",maxResponse,maxNoResponse);
    }
}


/*-********************************************************************************
* Method: didUpdateValueForCharacteristic
* Description: didUpdateValueForCharacteristic
* Parameter:
* Return Data:
***********************************************************************************/
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        [self.delegate bleConnectError:error andDevice:self];
        return;
    }
    
    if (self.isDebug) {
        NSLog(@"didUpdateValueForCharacteristic %@ %@",characteristic.UUID.UUIDString,characteristic.value);
    }
    [self.delegate bleReceiveByteData:characteristic andDevice:self];
}


/*-********************************************************************************
* Method: didUpdateNotificationStateForCharacteristic
* Description: didUpdateNotificationStateForCharacteristic
* Parameter:
* Return Data:
***********************************************************************************/
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        [self.delegate bleConnectError:error andDevice:self];
    }
}


/*-********************************************************************************
* Method: didWriteValueForCharacteristic
* Description: didWriteValueForCharacteristic
* Parameter:
* Return Data:
***********************************************************************************/
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        [self.delegate bleConnectError:error andDevice:self];
        [self.delegate bleWriteStatus:NO andDevice:self];
    }
    else {
        [self.delegate bleWriteStatus:YES andDevice:self];
    }
}


/*-********************************************************************************
* Method: didDisconnectPeripheral
* Description: didDisconnectPeripheral
* Parameter:
* Return Data:
***********************************************************************************/
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    if (self.bleDeviceId.length != 0 && m_peripheral != nil) {
        [self.delegate bleConnectStatus:DeviceBleReconnect andDevice:self];
        [m_manager connectPeripheral:m_peripheral options:nil];
    }
    else {
        [self.delegate bleConnectStatus:DeviceBleDisconneced andDevice:self];
    }
}


@end
