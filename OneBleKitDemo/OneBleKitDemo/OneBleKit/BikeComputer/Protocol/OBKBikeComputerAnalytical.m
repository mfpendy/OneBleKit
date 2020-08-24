/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKBikeComputerAnalytical.m
* Function : BikeComputer Analytical
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.15
***********************************************************************************/

#import "OBKBikeComputerAnalytical.h"
#import "OBKDeviceUuid.h"
#import "OBKBikeComputerCmd.h"
#import "OBKFileOperate.h"
#import "OBKBikeComputerFile.h"
#import "OBKFormatTools.h"

#define BUFER_LENGTH_GET  1024
#define BUFER_LENGTH_POST 1024
#define BUFER_LENGTH_PUSH 1024

@implementation OBKBikeComputerAnalytical{
    OBKBleTools *m_myBleTools;
    NSMutableData *m_getDataBufer;
    NSMutableData *m_postDataBufer;
    NSMutableData *m_pushDataBufer;
    NSMutableData *m_fileData;
    OBKBikeComputerFile *m_fileInfo;
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
    m_myBleTools = [[OBKBleTools alloc] init];
    m_getDataBufer = [[NSMutableData alloc] init];
    m_postDataBufer = [[NSMutableData alloc] init];
    m_pushDataBufer = [[NSMutableData alloc] init];
    m_fileData = [[NSMutableData alloc] init];
    m_fileInfo = [[OBKBikeComputerFile alloc] init];
    return self;
}


/*-********************************************************************************
* Method: appendDataValue
* Description: appendDataValue
* Parameter:
* Return Data:
***********************************************************************************/
- (void)appendDataValue:(NSData*)valueData withType:(BleCmdType)type {
    if (type == BleCmdTypeGet) {
        [m_getDataBufer appendData:valueData];
        if (m_getDataBufer.length > BUFER_LENGTH_GET) {
            [m_getDataBufer replaceBytesInRange:NSMakeRange(0, m_getDataBufer.length) withBytes:NULL length:0];
        }
    }
    else if (type == BleCmdTypePost) {
        [m_postDataBufer appendData:valueData];
        if (m_postDataBufer.length > BUFER_LENGTH_POST) {
            [m_postDataBufer replaceBytesInRange:NSMakeRange(0, m_postDataBufer.length) withBytes:NULL length:0];
        }
    }
    else if (type == BleCmdTypePush) {
        [m_pushDataBufer appendData:valueData];
        if (m_pushDataBufer.length > BUFER_LENGTH_PUSH) {
            [m_pushDataBufer replaceBytesInRange:NSMakeRange(0, m_pushDataBufer.length) withBytes:NULL length:0];
        }
    }
}


#pragma mark - ****************************** Interface ***************************
/*-********************************************************************************
* Method: getDeviceInformation
* Description: getDeviceInformation
* Parameter:
* Return Data:
***********************************************************************************/
- (void)receiveBleData:(CBCharacteristic *)characteristic {
    NSData *valueData = characteristic.value;
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:OBK_CHARACTERISTIC_GET]]) {
        if ([m_myBleTools getPackageStatus:valueData] == BlePackageOK) {
            [m_getDataBufer replaceBytesInRange:NSMakeRange(0, m_getDataBufer.length) withBytes:NULL length:0];
            [self appendDataValue:valueData withType:BleCmdTypeGet];
            [self analyticalData:m_getDataBufer];
        }
        else if ([m_myBleTools getPackageStatus:valueData] == BlePackageStart) {
            [m_getDataBufer replaceBytesInRange:NSMakeRange(0, m_getDataBufer.length) withBytes:NULL length:0];
            [self appendDataValue:valueData withType:BleCmdTypeGet];
        }
        else if ([m_myBleTools getPackageStatus:valueData] == BlePackageEnd) {
            [self appendDataValue:valueData withType:BleCmdTypeGet];
            if ([m_myBleTools getPackageStatus:m_getDataBufer] == BlePackageOK) {
                [self analyticalData:m_getDataBufer];
            }
            else {
                [m_getDataBufer replaceBytesInRange:NSMakeRange(0, m_getDataBufer.length) withBytes:NULL length:0];
            }
        }
        else if ([m_myBleTools getPackageStatus:valueData] == BlePackageCenter) {
            [self appendDataValue:valueData withType:BleCmdTypeGet];
        }
    }
    else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:OBK_CHARACTERISTIC_POST]]) {
        if ([m_myBleTools getPackageStatus:valueData] == BlePackageOK) {
            [m_postDataBufer replaceBytesInRange:NSMakeRange(0, m_postDataBufer.length) withBytes:NULL length:0];
            [self appendDataValue:valueData withType:BleCmdTypePost];
            [self analyticalData:m_postDataBufer];
        }
        else if ([m_myBleTools getPackageStatus:valueData] == BlePackageStart) {
            [m_postDataBufer replaceBytesInRange:NSMakeRange(0, m_postDataBufer.length) withBytes:NULL length:0];
            [self appendDataValue:valueData withType:BleCmdTypePost];
        }
        else if ([m_myBleTools getPackageStatus:valueData] == BlePackageEnd) {
            [self appendDataValue:valueData withType:BleCmdTypePost];
            if ([m_myBleTools getPackageStatus:m_postDataBufer] == BlePackageOK) {
                [self analyticalData:m_postDataBufer];
            }
            else {
                [m_postDataBufer replaceBytesInRange:NSMakeRange(0, m_postDataBufer.length) withBytes:NULL length:0];
            }
        }
        else if ([m_myBleTools getPackageStatus:valueData] == BlePackageCenter) {
            [self appendDataValue:valueData withType:BleCmdTypePost];
        }
    }
    else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:OBK_CHARACTERISTIC_PUSH]]) {
        if ([m_myBleTools getPackageStatus:valueData] == BlePackageOK) {
            [m_pushDataBufer replaceBytesInRange:NSMakeRange(0, m_pushDataBufer.length) withBytes:NULL length:0];
            [self appendDataValue:valueData withType:BleCmdTypePush];
            [self analyticalData:m_pushDataBufer];
        }
        else if ([m_myBleTools getPackageStatus:valueData] == BlePackageStart) {
            [m_pushDataBufer replaceBytesInRange:NSMakeRange(0, m_pushDataBufer.length) withBytes:NULL length:0];
            [self appendDataValue:valueData withType:BleCmdTypePush];
        }
        else if ([m_myBleTools getPackageStatus:valueData] == BlePackageEnd) {
            [self appendDataValue:valueData withType:BleCmdTypePush];
            if ([m_myBleTools getPackageStatus:m_pushDataBufer] == BlePackageOK) {
                [self analyticalData:m_pushDataBufer];
            }
            else {
                [m_pushDataBufer replaceBytesInRange:NSMakeRange(0, m_pushDataBufer.length) withBytes:NULL length:0];
            }
        }
        else if ([m_myBleTools getPackageStatus:valueData] == BlePackageCenter) {
            [self appendDataValue:valueData withType:BleCmdTypePush];
        }
    }
}


/*-********************************************************************************
* Method: analyticalData
* Description: analyticalData
* Parameter:
* Return Data:
***********************************************************************************/
- (void)analyticalData:(NSData *)valueData {
    NSData *resultData = [[NSData alloc] initWithData:valueData];
    resultData = [m_myBleTools baleCmdData:valueData isSend:false];
    resultData = [m_myBleTools translationData:resultData isSend:false];
    if ([m_myBleTools isCRCCheckSucceed:resultData]) {
        OBKAnalyValues *analyValue = [m_myBleTools getValueData:resultData];
        [analyValue logClass];
        [self.delegate receiveDataAck:analyValue];
        
        if (analyValue.oidNumber == OidForGetDeviceInfo) {
            DeviceInfo *deviceInfo = [DeviceInfo parseFromData:analyValue.valueData error:nil];
            [self.delegate analyticalResult:deviceInfo withResultNumber:BikeResultDeviceInfo];
        }
        else if (analyValue.oidNumber == OidForGetFile) {
            FileGetRsp *fileExit = [FileGetRsp parseFromData:analyValue.valueData error:nil];
            NSLog(@"fileExit is %@",fileExit);
        }
        else if (analyValue.oidNumber == OidForPostFileInfo) {
            FileInfo  *fileInfo = [FileInfo parseFromData:analyValue.valueData error:nil];
            m_fileInfo.fileName = fileInfo.fileName;
            m_fileInfo.size = fileInfo.fileSize;
            NSLog(@"fileInfo is %@",fileInfo);
        }
        else if (analyValue.oidNumber == OidForReceiveFile) {
            NSData *fileData = [[NSData alloc] initWithData:analyValue.valueData];
            const uint8_t *fileByte = (const uint8_t *)fileData.bytes;
            uint16_t length = (uint16_t)fileData.length;
            int byte1 = fileByte[1] & 0xFF;
            
            NSLog(@"byte1 is %i", byte1);
            NSMutableData *resultData = [[NSMutableData alloc] init];
            for (int i = 2; i < length; i++) {
                int value = fileByte[i];
                Byte bytes[1];
                bytes[0] = (Byte) (value);
                [resultData appendBytes:bytes length:sizeof(bytes)];
            }
            
            if (byte1 == 0) {
                [m_fileData replaceBytesInRange:NSMakeRange(0, m_fileData.length) withBytes:NULL length:0];
                [m_fileData appendData:resultData];
            }
            else if (byte1 == 1) {
                [m_fileData appendData:resultData];
            }
            else if (byte1 == 2) {
                [m_fileData appendData:resultData];
                m_fileInfo.fitData = m_fileData;
                [self analyticalFile:m_fileInfo];
            }
            else if (byte1 == 3) {
                [m_fileData replaceBytesInRange:NSMakeRange(0, m_fileData.length) withBytes:NULL length:0];
                [m_fileData appendData:resultData];
                m_fileInfo.fitData = m_fileData;
                [self analyticalFile:m_fileInfo];
            }
        }
        else if (analyValue.oidNumber == OidForGetFileStatus) {
            FileTransStatusGetRsp *sendInfoStatus = [FileTransStatusGetRsp parseFromData:analyValue.valueData error:nil];
            [self.delegate analyticalResult:sendInfoStatus withResultNumber:BikeResultFileStatus];
        }
        else if (analyValue.oidNumber == OidForGetStorage) {
            StorageGetRsp *storageInfo = [StorageGetRsp  parseFromData:analyValue.valueData error:nil];
            [self.delegate analyticalResult:storageInfo withResultNumber:BikeResultGetStorage];
        }
    }
    else {
        NSLog(@"Check Number is error !!!");
    }
}


/*-********************************************************************************
* Method: analyticalFile
* Description: analyticalFile
* Parameter:
* Return Data:
***********************************************************************************/
- (void)analyticalFile:(OBKBikeComputerFile *)valueFile {
    if ([valueFile.fileName isEqualToString:@"filelist.txt"]) {
        NSString *fileList = [[NSString alloc] initWithData:valueFile.fitData encoding:NSUTF8StringEncoding];
        NSMutableArray *fileArray = [[NSMutableArray alloc] init];
        
        NSArray *listArray = [fileList componentsSeparatedByString:@"\r\n"];
        for (int i = 0; i < listArray.count; i++) {
            NSString *fileString = [listArray objectAtIndex:i];
            NSArray *fileInfo = [fileString componentsSeparatedByString:@" "];
            if (fileInfo.count == 2) {
                OBKBikeComputerFile *fileMap = [[OBKBikeComputerFile alloc] init];
                fileMap.fileName = [fileInfo objectAtIndex:0];
                fileMap.size = [[fileInfo objectAtIndex:1] intValue];
                [fileArray addObject:fileMap];
            }
        }
        
        [self.delegate analyticalResult:fileArray withResultNumber:BikeResultFitList];
    }
    else if ([valueFile.fileName isEqualToString:@"Setting.json"]) {
        if (valueFile.fitData.length == valueFile.size) {
            NSLog(@"Setting is %i",(int) valueFile.fitData.length);
            OBKFormatTools *formatTools = [[OBKFormatTools alloc] init];
            NSDictionary *setMap = [formatTools dataToMap:valueFile.fitData];
            [self.delegate analyticalResult:setMap withResultNumber:BikeResultSettingJson];
        }
    }
    else {
        OBKBikeComputerFile *resultFile = [[OBKBikeComputerFile alloc] init];
        resultFile.fileName = valueFile.fileName;
        resultFile.size = valueFile.size;
        resultFile.fitData = valueFile.fitData;
        [self.delegate analyticalResult:resultFile withResultNumber:BikeResultFitData];
    }
}


@end
