/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKBleScanner.m
* Function : Ble Scanner
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.11
***********************************************************************************/

#import "OBKBleScanner.h"
#import "OBKBleDevice.h"

@implementation OBKBleScanner {
    CBCentralManager *m_manager;
    NSMutableArray   *m_devicesArray;
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
    self.limitRssi = -120;
    self.isRealTime = false;
    self.limitNameArray = [[NSMutableArray alloc] init];
    self.uuidArray = [[NSMutableArray alloc] init];
    m_devicesArray = [[NSMutableArray alloc] init];
    m_manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    return self;
}


#pragma mark - ****************************** Interface ***************************
/*-********************************************************************************
* Method: startScanBleDevice
* Description: startScanBleDevice
* Parameter:
* Return Data:
***********************************************************************************/
- (void)startScanBleDevice {
    NSArray *systemArray = [self getSettingConnectedBlue:self.uuidArray];
    if (systemArray != nil) {
        if (self.isRealTime) {
            [m_devicesArray removeAllObjects];
        }
        
        [m_devicesArray addObjectsFromArray:systemArray];
        [self.delegate scanDeviceResult:m_devicesArray];
    }
    
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:false] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [m_manager scanForPeripheralsWithServices:self.uuidArray options:options];
}


/*-********************************************************************************
* Method: stopScanBleDevice
* Description: stopScanBleDevice
* Parameter:
* Return Data:
***********************************************************************************/
- (void)stopScanBleDevice {
    if (m_manager != nil) {
        [m_manager stopScan];
    }
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
            [self.delegate phoneBleStatus:YES];
            break;
        }
        default: {
            [self.delegate phoneBleStatus:NO];
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
    NSString *bleName = @"Unnamed";;
    if (peripheral.name != nil) {
        bleName = peripheral.name;
    }
    
    if ([RSSI intValue] < self.limitRssi) {
        return;
    }
    
    if (![self isNameInArray:self.limitNameArray andName:bleName]) {
        return;
    }
    
    OBKBleDevice *bleDevice = [[OBKBleDevice alloc] init];
    bleDevice.name = bleName;
    bleDevice.rssi = [RSSI intValue];
    bleDevice.advertisementData = advertisementData;
    bleDevice.uuidString = peripheral.identifier.UUIDString;
    bleDevice.macAddress = @"";
    bleDevice.idString = @"";
    bleDevice.peripheral = peripheral;
    
    if (self.isRealTime) {
        [m_devicesArray removeAllObjects];
        [m_devicesArray addObject:bleDevice];
        [self.delegate scanDeviceResult:m_devicesArray];
    }
    else {
        BOOL isHave = NO;
        for (int i = 0; i < m_devicesArray.count; i++) {
            OBKBleDevice *listDevice = [m_devicesArray objectAtIndex:i];
            if (peripheral == listDevice.peripheral) {
                [m_devicesArray replaceObjectAtIndex:i withObject:bleDevice];
                isHave = YES;
                break;
            }
        }
        
        if (!isHave) {
            [m_devicesArray addObject:bleDevice];
        }
        
        [self.delegate scanDeviceResult:m_devicesArray];
    }
}


#pragma mark - ****************************** Data Edited *************************
/*-********************************************************************************
* Method: getSettingConnectedBlue
* Description: getSettingConnectedBlue
* Parameter:
* Return Data:
***********************************************************************************/
- (NSArray *)getSettingConnectedBlue:(NSArray *)UUIDArray {
    if (UUIDArray == nil) {
        return nil;
    }
    
    NSArray *settingBlueArray = [m_manager retrieveConnectedPeripheralsWithServices:UUIDArray];
    if ([settingBlueArray isKindOfClass:[NSArray class]]) {
        if (settingBlueArray.count > 0) {
            NSMutableArray *resultArray = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < settingBlueArray.count; i++) {
                CBPeripheral *nowPeripheral = [settingBlueArray objectAtIndex:i];
                NSString *rssiNumber = @"0";
                NSDictionary *advertisementData = [[NSDictionary alloc] init];
                
                NSMutableDictionary *deviceInfoDic = [[NSMutableDictionary alloc] init];
                [deviceInfoDic setObject:nowPeripheral forKey:@"peripheral"];
                [deviceInfoDic setObject:rssiNumber forKey:@"RSSI"];
                [deviceInfoDic setObject:advertisementData forKey:@"advertisementData"];
                [resultArray addObject:deviceInfoDic];
            }
            
            return resultArray;
        }
    }
    
    return nil;
}


/*-********************************************************************************
* Method: isNameInArray
* Description: isNameInArray
* Parameter:
* Return Data:
***********************************************************************************/
- (BOOL)isNameInArray:(NSArray *)nameArray andName:(NSString *)bleName {
    if (nameArray.count == 0) {
        return true;
    }
    
    NSString *scanName = bleName.uppercaseString;
    BOOL isNameIn = false;
    
    for (int i = 0; i < nameArray.count; i++) {
        NSString *listName = [nameArray objectAtIndex:i];
        listName = listName.uppercaseString;
        if ([scanName hasPrefix:listName]) {
            isNameIn = true;
            break;;
        }
    }
    
    return isNameIn;
}


@end
