/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKEnumList.h
* Function : enum List
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.11
***********************************************************************************/

#import <Foundation/Foundation.h>

typedef enum {
    DeviceBleClosed = 0,      // 未开启蓝牙
    DeviceBleIsOpen,          // 蓝牙可用
    DeviceBleSearching,       // 搜索中...
    DeviceBleConnecting,      // 连接中...
    DeviceBleConnected,       // 已连接
    DeviceBleSynchronization, // 同步中...
    DeviceBleSyncOver,        // 同步完成
    DeviceBleSyncFailed,      // 同步失败
    DeviceBleDisconnecting,   // 断开中...
    DeviceBleDisconneced,     // 已断开
    DeviceBleReconnect,       // 重连中...
} DeviceBleStatus;


typedef enum {
    BleDeviceBikeComputer = 0, // 码表
} BleDeviceType;


typedef enum {
    DeviceIdUUID = 0,  // 以UUID为匹配条件
    DeviceIdMacAdress, // 以MAC地址为匹配条件
    DeviceIdName,      // 以名称为匹配条件
    DeviceIdOther,     // 以特殊字段为匹配条件
} DeviceIdType;


typedef enum {
    DeviceUuidRead = 0,
    DeviceUuidWrite,
    DeviceUuidNotify,
} DeviceUuidType;


typedef enum {
    BleCmdTypeGet = 0,
    BleCmdTypePost = 1,
    BleCmdTypePush = 2,
} BleCmdType;


typedef enum {
    BleTransTypeRequest = 0,
    BleTransTypeResponse = 1,
    BleTransTypeAck = 2,
} BleTransType;


typedef enum {
    BlePackageStart = 0,
    BlePackageEnd = 1,
    BlePackageCenter = 2,
    BlePackageOK = 3,
    BlePackageNil = 4,
} BlePackageStatus;




