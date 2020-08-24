/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: ShowTools.h
* Function : ShowTools
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.15
***********************************************************************************/

#import "ShowTools.h"

@implementation ShowTools

/*-********************************************************************************
* Method: showDeviceStatus
* Description: showDeviceStatus
* Parameter:
* Return Data:
***********************************************************************************/
+ (NSString *)showDeviceStatus:(DeviceBleStatus)status {
    switch (status) {
        case DeviceBleClosed:
            return @"Closed";
            break;
            
        case DeviceBleIsOpen:
            return @"BleIsOpen";
            break;
            
        case DeviceBleSearching:
            return @"Searching";
            break;
            
        case DeviceBleConnecting:
            return @"Connecting";
            break;
            
        case DeviceBleConnected:
            return @"Connected";
            break;
            
        case DeviceBleSynchronization:
            return @"Synchronization";
            break;
            
        case DeviceBleSyncOver:
            return @"SyncOver";
            break;
            
        case DeviceBleSyncFailed:
            return @"SyncFailed";
            break;
            
        case DeviceBleDisconnecting:
            return @"Disconnecting";
            break;
            
            case DeviceBleDisconneced:
            return @"Disconneced";
            break;
            
        case DeviceBleReconnect:
            return @"Reconnecting";
            break;
            
        default:
            return @"nil";
            break;
    }
}


@end
