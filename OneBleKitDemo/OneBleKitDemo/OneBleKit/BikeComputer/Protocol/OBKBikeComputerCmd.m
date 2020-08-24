/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKBikeComputerCmd.m
* Function : BikeComputer Cmd
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.15
***********************************************************************************/

#import "OBKBikeComputerCmd.h"
#import "OBKBleTools.h"

@implementation OBKBikeComputerCmd {
    OBKBleTools *myBleTools;
    OBKDeviceUuid *m_uuidClass;
    int m_filePacketIndex;
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
    myBleTools = [[OBKBleTools alloc] init];
    m_uuidClass = [[OBKDeviceUuid alloc] init];
    self.bluetoothMTU = 20;
    self.maxPacket = 128;
    return self;
}


/*-********************************************************************************
* Method: addFilePacketIndex
* Description: addFilePacketIndex
* Parameter:
* Return Data:
***********************************************************************************/
- (void)addFilePacketIndex {
    if (m_filePacketIndex == 255) {
        m_filePacketIndex = 0;
    }
    else {
        m_filePacketIndex = m_filePacketIndex + 1;
    }
}


#pragma mark - ****************************** Interface ***************************
/*-********************************************************************************
* Method: ackCommond
* Description: ackCommond
* Parameter:
* Return Data:
***********************************************************************************/
- (OBKCmdValues *)ackCommond:(int)sid withOid:(int)oid andCmdType:(BleCmdType)cmdType {
    NSMutableData *cmdData = [[NSMutableData alloc] init];
    NSData *requestData = [myBleTools stitchingData:cmdType withTrans:BleTransTypeAck andSid:sid data:cmdData];
    OBKDeviceUuid *myUuid = [m_uuidClass getDeviceUuid:BleDeviceBikeComputer withIdType:DeviceUuidWrite andCmdType:cmdType];
    OBKCmdValues *cmdValue = [[OBKCmdValues alloc] init];
    cmdValue.oidNumber = oid;
    cmdValue.sidNumber = sid;
    cmdValue.cmdArray = [NSArray arrayWithObject:requestData];
    cmdValue.sendUuid = myUuid;
    return cmdValue;
}


/*-********************************************************************************
* Method: getDeviceInformation
* Description: getDeviceInformation
* Parameter:
* Return Data:
***********************************************************************************/
- (OBKCmdValues *)getDeviceInformation:(int)sid {
    NSMutableData *cmdData = [[NSMutableData alloc] init];
    
    int oid = (int) OidForGetDeviceInfo;
    Byte bytes[2];
    bytes[0] = (Byte) (oid/256 > 256 ? 256:oid/256);
    bytes[1] = (Byte) (oid%256);
    [cmdData appendBytes:bytes length:sizeof(bytes)];
    
    NSData *requestData = [myBleTools stitchingData:BleCmdTypeGet withTrans:BleTransTypeRequest andSid:sid data:cmdData];
    OBKDeviceUuid *myUuid = [m_uuidClass getDeviceUuid:BleDeviceBikeComputer withIdType:DeviceUuidWrite andCmdType:BleCmdTypeGet];
    OBKCmdValues *cmdValue = [[OBKCmdValues alloc] init];
    cmdValue.oidNumber = oid;
    cmdValue.sidNumber = sid;
    cmdValue.cmdArray = [NSArray arrayWithObject:requestData];
    cmdValue.sendUuid = myUuid;
    return cmdValue;
}


/*-********************************************************************************
* Method: postUtcInfo
* Description: postUtcInfo
* Parameter:
* Return Data:
***********************************************************************************/
- (OBKCmdValues *)postUtcInfo:(UtcInfo *)utcInfo withSid:(int)sid {
    NSMutableData *cmdData = [[NSMutableData alloc] init];
    
    int oid = (int) OidForPostUtcInfo;
    Byte bytes[2];
    bytes[0] = (Byte) (oid/256 > 256 ? 256:oid/256);
    bytes[1] = (Byte) (oid%256);
    [cmdData appendBytes:bytes length:sizeof(bytes)];
    
    NSData *utcData = [utcInfo data];
    [cmdData appendData:utcData];
    
    NSData *requestData = [myBleTools stitchingData:BleCmdTypePost withTrans:BleTransTypeRequest andSid:sid data:cmdData];
    OBKDeviceUuid *myUuid = [m_uuidClass getDeviceUuid:BleDeviceBikeComputer withIdType:DeviceUuidWrite andCmdType:BleCmdTypePost];
    OBKCmdValues *cmdValue = [[OBKCmdValues alloc] init];
    cmdValue.oidNumber = oid;
    cmdValue.sidNumber = sid;
    cmdValue.cmdArray = [NSArray arrayWithObject:requestData];
    cmdValue.sendUuid = myUuid;
    return cmdValue;
}


/*-********************************************************************************
* Method: postResetDevice
* Description: postResetDevice
* Parameter:
* Return Data:
***********************************************************************************/
- (OBKCmdValues *)postResetDevice:(int)sid {
    NSMutableData *cmdData = [[NSMutableData alloc] init];
    
    int oid = (int) OidForPostReset;
    Byte bytes[2];
    bytes[0] = (Byte) (oid/256 > 256 ? 256:oid/256);
    bytes[1] = (Byte) (oid%256);
    [cmdData appendBytes:bytes length:sizeof(bytes)];
    
    NSData *requestData = [myBleTools stitchingData:BleCmdTypePost withTrans:BleTransTypeRequest andSid:sid data:cmdData];
    OBKDeviceUuid *myUuid = [m_uuidClass getDeviceUuid:BleDeviceBikeComputer withIdType:DeviceUuidWrite andCmdType:BleCmdTypePost];
    OBKCmdValues *cmdValue = [[OBKCmdValues alloc] init];
    cmdValue.oidNumber = oid;
    cmdValue.sidNumber = sid;
    cmdValue.cmdArray = [NSArray arrayWithObject:requestData];
    cmdValue.sendUuid = myUuid;
    return cmdValue;
}


/*-********************************************************************************
* Method: getHistory
* Description: getHistory
* Parameter:
* Return Data:
***********************************************************************************/
- (OBKCmdValues *)getHistory:(int)sid {
    NSMutableData *cmdData = [[NSMutableData alloc] init];
    
    int oid = (int) OidForGetHistory;
    Byte bytes[2];
    bytes[0] = (Byte) (oid/256 > 256 ? 256:oid/256);
    bytes[1] = (Byte) (oid%256);
    [cmdData appendBytes:bytes length:sizeof(bytes)];
    
    NSData *requestData = [myBleTools stitchingData:BleCmdTypeGet withTrans:BleTransTypeRequest andSid:sid data:cmdData];
    OBKDeviceUuid *myUuid = [m_uuidClass getDeviceUuid:BleDeviceBikeComputer withIdType:DeviceUuidWrite andCmdType:BleCmdTypeGet];
    OBKCmdValues *cmdValue = [[OBKCmdValues alloc] init];
    cmdValue.oidNumber = oid;
    cmdValue.sidNumber = sid;
    cmdValue.cmdArray = [NSArray arrayWithObject:requestData];
    cmdValue.sendUuid = myUuid;
    return cmdValue;
}


/*-********************************************************************************
* Method: getFileIsExist
* Description: getFileIsExist
* Parameter:
* Return Data:
***********************************************************************************/
- (OBKCmdValues *)getFileIsExist:(FileGetReq *)fileInfo withSid:(int)sid {
    NSMutableData *cmdData = [[NSMutableData alloc] init];
    
    int oid = (int) OidForGetFile;
    Byte bytes[2];
    bytes[0] = (Byte) (oid/256 > 256 ? 256:oid/256);
    bytes[1] = (Byte) (oid%256);
    [cmdData appendBytes:bytes length:sizeof(bytes)];
    
    NSData *fileData = [fileInfo data];
    [cmdData appendData:fileData];
    
    NSData *requestData = [myBleTools stitchingData:BleCmdTypeGet withTrans:BleTransTypeRequest andSid:sid data:cmdData];
    OBKDeviceUuid *myUuid = [m_uuidClass getDeviceUuid:BleDeviceBikeComputer withIdType:DeviceUuidWrite andCmdType:BleCmdTypeGet];
    OBKCmdValues *cmdValue = [[OBKCmdValues alloc] init];
    cmdValue.oidNumber = oid;
    cmdValue.sidNumber = sid;
    cmdValue.cmdArray = [NSArray arrayWithObject:requestData];
    cmdValue.sendUuid = myUuid;
    return cmdValue;
}


/*-********************************************************************************
* Method: postDeleteFile
* Description: postDeleteFile
* Parameter:
* Return Data:
***********************************************************************************/
- (OBKCmdValues *)postDeleteFile:(FileDeleteReq *)fileInfo withSid:(int)sid {
    NSMutableData *cmdData = [[NSMutableData alloc] init];
    
    int oid = (int) OidForPostDeleteFile;
    Byte bytes[2];
    bytes[0] = (Byte) (oid/256 > 256 ? 256:oid/256);
    bytes[1] = (Byte) (oid%256);
    [cmdData appendBytes:bytes length:sizeof(bytes)];
    
    NSData *fileData = [fileInfo data];
    [cmdData appendData:fileData];
    
    NSData *requestData = [myBleTools stitchingData:BleCmdTypePost withTrans:BleTransTypeRequest andSid:sid data:cmdData];
    OBKDeviceUuid *myUuid = [m_uuidClass getDeviceUuid:BleDeviceBikeComputer withIdType:DeviceUuidWrite andCmdType:BleCmdTypePost];
    OBKCmdValues *cmdValue = [[OBKCmdValues alloc] init];
    cmdValue.oidNumber = oid;
    cmdValue.sidNumber = sid;
    cmdValue.cmdArray = [NSArray arrayWithObject:requestData];
    cmdValue.sendUuid = myUuid;
    return cmdValue;
}


/*-********************************************************************************
* Method: postSendFileInfo
* Description: postSendFileInfo
* Parameter:
* Return Data:
***********************************************************************************/
- (OBKCmdValues *)postSendFileInfo:(FileInfo *)fileInfo withSid:(int)sid {
    NSMutableData *cmdData = [[NSMutableData alloc] init];
    
    int oid = (int) OidForPostFileInfo;
    Byte bytes[2];
    bytes[0] = (Byte) (oid/256 > 256 ? 256:oid/256);
    bytes[1] = (Byte) (oid%256);
    [cmdData appendBytes:bytes length:sizeof(bytes)];
    
    NSData *fileData = [fileInfo data];
    [cmdData appendData:fileData];
    
    NSData *requestData = [myBleTools stitchingData:BleCmdTypePost withTrans:BleTransTypeRequest andSid:sid data:cmdData];
    OBKDeviceUuid *myUuid = [m_uuidClass getDeviceUuid:BleDeviceBikeComputer withIdType:DeviceUuidWrite andCmdType:BleCmdTypePost];
    OBKCmdValues *cmdValue = [[OBKCmdValues alloc] init];
    cmdValue.oidNumber = oid;
    cmdValue.sidNumber = sid;
    cmdValue.cmdArray = [NSArray arrayWithObject:requestData];
    cmdValue.sendUuid = myUuid;
    return cmdValue;
}


/*-********************************************************************************
* Method: postStopSendFile
* Description: postStopSendFile
* Parameter:
* Return Data:
***********************************************************************************/
- (OBKCmdValues *)postStopSendFile:(int)sid {
    NSMutableData *cmdData = [[NSMutableData alloc] init];
    
    int oid = (int) OidForPostStopFile;
    Byte bytes[2];
    bytes[0] = (Byte) (oid/256 > 256 ? 256:oid/256);
    bytes[1] = (Byte) (oid%256);
    [cmdData appendBytes:bytes length:sizeof(bytes)];
    
    NSData *requestData = [myBleTools stitchingData:BleCmdTypePost withTrans:BleTransTypeRequest andSid:sid data:cmdData];
    OBKDeviceUuid *myUuid = [m_uuidClass getDeviceUuid:BleDeviceBikeComputer withIdType:DeviceUuidWrite andCmdType:BleCmdTypePost];
    OBKCmdValues *cmdValue = [[OBKCmdValues alloc] init];
    cmdValue.oidNumber = oid;
    cmdValue.sidNumber = sid;
    cmdValue.cmdArray = [NSArray arrayWithObject:requestData];
    cmdValue.sendUuid = myUuid;
    return cmdValue;
}


/*-********************************************************************************
* Method: getSendFileStatus
* Description: getSendFileStatus
* Parameter:
* Return Data:
***********************************************************************************/
- (OBKCmdValues *)getSendFileStatus:(int)sid {
    NSMutableData *cmdData = [[NSMutableData alloc] init];
    
    int oid = (int) OidForGetFileStatus;
    Byte bytes[2];
    bytes[0] = (Byte) (oid/256 > 256 ? 256:oid/256);
    bytes[1] = (Byte) (oid%256);
    [cmdData appendBytes:bytes length:sizeof(bytes)];
    
    NSData *requestData = [myBleTools stitchingData:BleCmdTypeGet withTrans:BleTransTypeRequest andSid:sid data:cmdData];
    OBKDeviceUuid *myUuid = [m_uuidClass getDeviceUuid:BleDeviceBikeComputer withIdType:DeviceUuidWrite andCmdType:BleCmdTypeGet];
    OBKCmdValues *cmdValue = [[OBKCmdValues alloc] init];
    cmdValue.oidNumber = oid;
    cmdValue.sidNumber = sid;
    cmdValue.cmdArray = [NSArray arrayWithObject:requestData];
    cmdValue.sendUuid = myUuid;
    return cmdValue;
}


/*-********************************************************************************
* Method: getAvailableStorage
* Description: getAvailableStorage
* Parameter:
* Return Data:
***********************************************************************************/
- (OBKCmdValues *)getAvailableStorage:(int)sid {
    NSMutableData *cmdData = [[NSMutableData alloc] init];
    
    int oid = (int) OidForGetStorage;
    Byte bytes[2];
    bytes[0] = (Byte) (oid/256 > 256 ? 256:oid/256);
    bytes[1] = (Byte) (oid%256);
    [cmdData appendBytes:bytes length:sizeof(bytes)];
    
    NSData *requestData = [myBleTools stitchingData:BleCmdTypeGet withTrans:BleTransTypeRequest andSid:sid data:cmdData];
    OBKDeviceUuid *myUuid = [m_uuidClass getDeviceUuid:BleDeviceBikeComputer withIdType:DeviceUuidWrite andCmdType:BleCmdTypeGet];
    OBKCmdValues *cmdValue = [[OBKCmdValues alloc] init];
    cmdValue.oidNumber = oid;
    cmdValue.sidNumber = sid;
    cmdValue.cmdArray = [NSArray arrayWithObject:requestData];
    cmdValue.sendUuid = myUuid;
    return cmdValue;
}


/*-********************************************************************************
* Method: postFileData
* Description: postFileData
* Parameter:
* Return Data:
***********************************************************************************/
- (NSArray *)postFileData:(NSData *)fileData withSid:(int)sid {
    m_filePacketIndex = 0;
    int mySid = sid;
    
    NSMutableArray *packetArray = [[NSMutableArray alloc] init];
    int dataLength = (int)fileData.length;
    int cmdNumber = dataLength/self.maxPacket;
    int lastNumber = dataLength%self.maxPacket;
    if (lastNumber != 0) {
        cmdNumber = cmdNumber + 1;
    }
    
    if (cmdNumber == 1) {
        int lastLong = lastNumber;
        if (lastLong == 0) {
            lastLong = self.maxPacket;
        }
        
        NSMutableData *valueData = [[NSMutableData alloc] init];
        Byte bytes[2];
        bytes[0] = (Byte) (m_filePacketIndex);
        bytes[1] = (Byte) (3);
        [valueData appendBytes:bytes length:sizeof(bytes)];
        [valueData appendData:[fileData subdataWithRange:NSMakeRange(0,lastLong)]];
        [self addFilePacketIndex];
        [packetArray addObject:valueData];
    }
    else {
        for (int i = 0; i < cmdNumber; i++) {
            if (i == 0) {
                NSMutableData *valueData = [[NSMutableData alloc] init];
                Byte bytes[2];
                bytes[0] = (Byte) (m_filePacketIndex);
                bytes[1] = (Byte) (0);
                [valueData appendBytes:bytes length:sizeof(bytes)];
                [valueData appendData:[fileData subdataWithRange:NSMakeRange(i*self.maxPacket,self.maxPacket)]];
                [self addFilePacketIndex];
                [packetArray addObject:valueData];
            }
            else if (i == cmdNumber-1) {
                int lastLong = lastNumber;
                if (lastLong == 0) {
                    lastLong = self.maxPacket;
                }
                
                NSMutableData *valueData = [[NSMutableData alloc] init];
                Byte bytes[2];
                bytes[0] = (Byte) (m_filePacketIndex);
                bytes[1] = (Byte) (2);
                [valueData appendBytes:bytes length:sizeof(bytes)];
                [valueData appendData:[fileData subdataWithRange:NSMakeRange(i*self.maxPacket,lastLong)]];
                [self addFilePacketIndex];
                [packetArray addObject:valueData];
            }
            else {
                NSMutableData *valueData = [[NSMutableData alloc] init];
                Byte bytes[2];
                bytes[0] = (Byte) (m_filePacketIndex);
                bytes[1] = (Byte) (1);
                [valueData appendBytes:bytes length:sizeof(bytes)];
                [valueData appendData:[fileData subdataWithRange:NSMakeRange(i*self.maxPacket,self.maxPacket)]];
                [self addFilePacketIndex];
                [packetArray addObject:valueData];
            }
        }
    }
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < packetArray.count; i++) {
        NSMutableArray *cmdArray = [[NSMutableArray alloc] init];
        NSMutableData *cmdData = [[NSMutableData alloc] init];
        NSData *listData = [packetArray objectAtIndex:i];
        
        int oid = (int) OidForReceiveFile;
        Byte bytes[2];
        bytes[0] = (Byte) (oid/256 > 256 ? 256:oid/256);
        bytes[1] = (Byte) (oid%256);
        [cmdData appendBytes:bytes length:sizeof(bytes)];
        [cmdData appendData:listData];
        NSData *requestData = [myBleTools stitchingData:BleCmdTypePost withTrans:BleTransTypeRequest andSid:sid data:cmdData];

        int requestLength = (int)requestData.length;
        int requestNumber = requestLength/self.bluetoothMTU;
        int endNumber = requestLength%self.bluetoothMTU;
        if (endNumber != 0) {
            requestNumber = requestNumber + 1;
        }
        
        for (int j = 0; j < requestNumber; j++) {
            if (j == requestNumber-1) {
                int valueLong = endNumber;
                if (valueLong == 0) {
                    valueLong = self.bluetoothMTU;
                }
                
                NSData *valueCmd = [requestData subdataWithRange:NSMakeRange(j*self.bluetoothMTU,valueLong)];
                [cmdArray addObject:valueCmd];
            }
            else {
                NSData *valueCmd = [requestData subdataWithRange:NSMakeRange(j*self.bluetoothMTU,self.bluetoothMTU)];
                [cmdArray addObject:valueCmd];
            }
        }
        
        OBKDeviceUuid *myUuid = [m_uuidClass getDeviceUuid:BleDeviceBikeComputer withIdType:DeviceUuidWrite andCmdType:BleCmdTypePost];
        OBKCmdValues *cmdValue = [[OBKCmdValues alloc] init];
        cmdValue.oidNumber = oid;
        cmdValue.sidNumber = mySid;
        cmdValue.cmdArray = cmdArray;
        cmdValue.sendUuid = myUuid;
        mySid = mySid + 1;
        [resultArray addObject:cmdValue];
    }

    return resultArray;
}


@end
