/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKBikeComputerProtocol.m
* Function : BikeComputer Protocol
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.14
***********************************************************************************/

#import "OBKBikeComputerProtocol.h"
#import "OBKBikeComputerFile.h"
#import "OBKDateTools.h"

@implementation OBKBikeComputerProtocol {
    OBKBikeComputerCmd *m_cmdClass;
    OBKBikeComputerAnalytical *m_analyClass;
    OBKCmdSender *m_cmdSender;
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
    m_cmdClass = [[OBKBikeComputerCmd alloc] init];
    m_analyClass = [[OBKBikeComputerAnalytical alloc] init];
    m_analyClass.delegate = self;
    m_cmdSender = [[OBKCmdSender alloc] init];
    m_cmdSender.delegate = self;
    return self;
}


/*-********************************************************************************
* Method: dealloc
* Description: dealloc
* Parameter:
* Return Data:
***********************************************************************************/
- (void)dealloc {
    m_analyClass.delegate = nil;
    m_analyClass = nil;
    m_cmdSender.delegate = nil;
    m_cmdSender= nil;
}


#pragma mark - ****************************** Base Protocol ***********************
/*-********************************************************************************
* Method: receiveBleCmd
* Description: receiveBleCmd
* Parameter:
* Return Data:
***********************************************************************************/
- (void)receiveBleCmd:(int)cmdId withObject:(id)object {
    BikeComputerCmdId bikeCmd = (BikeComputerCmdId) cmdId;
    if (bikeCmd == BikeComputerGetDeviceInfo) {
        OBKCmdValues *cmdValue = [m_cmdClass getDeviceInformation:[m_cmdSender getSidNumber]];
        [m_cmdSender insertQueueData:cmdValue];
    }
    else if (bikeCmd == BikeComputerPostUtcInfo) {
        UtcInfo *utcInfo = (UtcInfo *) object;
        OBKCmdValues *cmdValue = [m_cmdClass postUtcInfo:utcInfo withSid:[m_cmdSender getSidNumber]];
        [m_cmdSender insertQueueData:cmdValue];
    }
    else if (bikeCmd == BikeComputerPostReset) {
        OBKCmdValues *cmdValue = [m_cmdClass postResetDevice:[m_cmdSender getSidNumber]];
        [m_cmdSender insertQueueData:cmdValue];
    }
    else if (bikeCmd == BikeComputerGetHistory) {
        OBKCmdValues *cmdValue = [m_cmdClass getHistory:[m_cmdSender getSidNumber]];
        [m_cmdSender insertQueueData:cmdValue];
    }
    else if (bikeCmd == BikeComputerGetFile) {
        FileGetReq *myFile = (FileGetReq *) object;
        OBKCmdValues *cmdValue = [m_cmdClass getFileIsExist:myFile withSid:[m_cmdSender getSidNumber]];
        [m_cmdSender insertQueueData:cmdValue];
    }
    else if (bikeCmd == BikeComputerPostDeleteFile) {
        FileDeleteReq *myFile = (FileDeleteReq *) object;
        OBKCmdValues *cmdValue = [m_cmdClass postDeleteFile:myFile withSid:[m_cmdSender getSidNumber]];
        [m_cmdSender insertQueueData:cmdValue];
    }
    else if (bikeCmd == BikeComputerPostStopFile) {
        OBKCmdValues *cmdValue = [m_cmdClass postStopSendFile:[m_cmdSender getSidNumber]];
        [m_cmdSender insertQueueData:cmdValue];
    }
    else if (bikeCmd == BikeComputerGetFileStatus) {
        OBKCmdValues *cmdValue = [m_cmdClass getSendFileStatus:[m_cmdSender getSidNumber]];
        [m_cmdSender insertQueueData:cmdValue];
    }
    else if (bikeCmd == BikeComputerGetStorage) {
        OBKCmdValues *cmdValue = [m_cmdClass getAvailableStorage:[m_cmdSender getSidNumber]];
        [m_cmdSender insertQueueData:cmdValue];
    }
    else if (bikeCmd == BikeComputerPostFileInfo) {
        OBKBikeComputerFile *fileData = (OBKBikeComputerFile *) object;
        
        FileInfo *myFile = [[FileInfo alloc] init];
        myFile.fileName = fileData.fileName;
        myFile.fileSize = fileData.size;
        NSLog(@"myFile is %@",myFile);
        OBKCmdValues *cmdValue = [m_cmdClass postSendFileInfo:myFile withSid:[m_cmdSender getSidNumber]];
        [m_cmdSender insertQueueData:cmdValue];
        
        NSArray *cmdArray = [m_cmdClass postFileData:fileData.fitData withSid:[m_cmdSender getSidNumber]];
        for (int i = 0; i < cmdArray.count; i++) {
            [m_cmdSender insertQueueData:[cmdArray objectAtIndex:i]];
            if (i != cmdArray.count-1) {
                [m_cmdSender getSidNumber];
            }
        }
    }
}


/*-********************************************************************************
* Method: receiveBleData
* Description: receiveBleData
* Parameter:
* Return Data:
***********************************************************************************/
- (void)receiveBleData:(CBCharacteristic *)characteristic {
    [m_analyClass receiveBleData:characteristic];
}


/*-********************************************************************************
* Method: setResponseMaxByte
* Description: setResponseMaxByte
* Parameter:
* Return Data:
***********************************************************************************/
- (void)setResponseMaxByte:(int)responseMax noResponseMaxByte:(int)noResponseMax {
    m_cmdClass.bluetoothMTU = noResponseMax;
}


/*-********************************************************************************
* Method: bleErrorDisconnected
* Description: bleErrorDisconnected
* Parameter:
* Return Data:
***********************************************************************************/
- (void)bleErrorDisconnected {
}


#pragma mark - ****************************** Send Delegate ***********************
/*-********************************************************************************
* Method: sendBleCmdData
* Description: sendBleCmdData
* Parameter:
* Return Data:
***********************************************************************************/
- (void)sendBleCmdData:(OBKCmdValues *)cmdValue {
    for (int i = 0; i < cmdValue.cmdArray.count; i++) {
        [self.delegate writeBleByte:[cmdValue.cmdArray objectAtIndex:i] withUuid:cmdValue.sendUuid isResponse:true andDevice:self];
    }
}


#pragma mark - ****************************** Analy Delegate **********************
/*-********************************************************************************
* Method: receiveDataAck
* Description: receiveDataAck
* Parameter:
* Return Data:
***********************************************************************************/
- (void)receiveDataAck:(OBKAnalyValues *)dataValue {
    if (dataValue.transType != BleTransTypeAck) {
        OBKCmdValues *cmdValue = [m_cmdClass ackCommond:dataValue.sidNumber withOid:dataValue.oidNumber andCmdType:dataValue.cmdType];
        for (int i = 0; i < cmdValue.cmdArray.count; i++) {
            [self.delegate writeBleByte:[cmdValue.cmdArray objectAtIndex:i] withUuid:cmdValue.sendUuid isResponse:true andDevice:self];
        }
    }
    [m_cmdSender sendCmdSuseed:dataValue.sidNumber];
}


/*-********************************************************************************
* Method: receiveDataAck
* Description: receiveDataAck
* Parameter:
* Return Data:
***********************************************************************************/
- (void)analyticalResult:(id)resultData withResultNumber:(BikeComputerResultId)resultId {
    if (resultId == BikeResultDeviceInfo) {
        DeviceInfo *deviceInfo = (DeviceInfo *)resultData;
        if (deviceInfo.fileTransSize == FileTransSize_FileTransSize256) {
            m_cmdClass.maxPacket = 256;
        }
        else if (deviceInfo.fileTransSize == FileTransSize_FileTransSize512) {
            m_cmdClass.maxPacket = 512;
        }
        else if (deviceInfo.fileTransSize == FileTransSize_FileTransSize1024) {
            m_cmdClass.maxPacket = 1024;
        }
        else {
            m_cmdClass.maxPacket = 128;
        }
    }
    [self.delegate analyticalBleData:resultData withResultId:resultId andDevice:self];
}


@end
