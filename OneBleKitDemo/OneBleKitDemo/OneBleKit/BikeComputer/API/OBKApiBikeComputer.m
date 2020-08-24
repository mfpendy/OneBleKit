/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKApiBikeComputer.m
* Function : BikeComputer Api
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.15
***********************************************************************************/

#import "OBKApiBikeComputer.h"
#import "OBKFormatTools.h"

@implementation OBKApiBikeComputer

#pragma mark - ****************************** System ******************************
/*-********************************************************************************
* Method: init
* Description: init
* Parameter:
* Return Data:
***********************************************************************************/
- (id)init {
    self = [super init];
    self.deviceType = BleDeviceBikeComputer;
    [self.bleManager setBleDeviceType:BleDeviceBikeComputer];
    return self;
}


#pragma mark - ****************************** Interface ***************************
/*-********************************************************************************
* Method: getDeviceInformation
* Description: getDeviceInformation
* Parameter:
* Return Data:
***********************************************************************************/
- (void)getDeviceInformation {
    [self.bleManager receiveApiCmd:BikeComputerGetDeviceInfo withObject:nil];
}


/*-********************************************************************************
* Method: setUtc
* Description: setUtc
* Parameter:
* Return Data:
***********************************************************************************/
- (void)setUtc:(UtcInfo *)utcInfo {
    [self.bleManager receiveApiCmd:BikeComputerPostUtcInfo withObject:utcInfo];
}


/*-********************************************************************************
* Method: resetDevice
* Description: resetDevice
* Parameter:
* Return Data:
***********************************************************************************/
- (void)resetDevice {
    [self.bleManager receiveApiCmd:BikeComputerPostReset withObject:nil];
}


/*-********************************************************************************
* Method: getHistory
* Description: getHistory
* Parameter:
* Return Data:
***********************************************************************************/
- (void)getHistory {
    [self.bleManager receiveApiCmd:BikeComputerGetHistory withObject:nil];
}


/*-********************************************************************************
* Method: getFitList
* Description: getFitList
* Parameter:
* Return Data:
***********************************************************************************/
- (void)getFitList {
    FileGetReq *myFile = [[FileGetReq alloc] init];
    myFile.fileName = @"filelist.txt";
    [self.bleManager receiveApiCmd:BikeComputerGetFile withObject:myFile];
}


/*-********************************************************************************
* Method: getSettingJson
* Description: getSettingJson
* Parameter:
* Return Data:
***********************************************************************************/
- (void)getSettingJson {
    FileGetReq *myFile = [[FileGetReq alloc] init];
    myFile.fileName = @"Setting.json";
    [self.bleManager receiveApiCmd:BikeComputerGetFile withObject:myFile];
}


/*-********************************************************************************
* Method: getFitFileData
* Description: getFitFileData
* Parameter:
* Return Data:
***********************************************************************************/
- (void)getFitFileData:(NSString *)fitName {
    FileGetReq *myFile = [[FileGetReq alloc] init];
    myFile.fileName = fitName;
    [self.bleManager receiveApiCmd:BikeComputerGetFile withObject:myFile];
}


/*-********************************************************************************
* Method: deleteFile
* Description: deleteFile
* Parameter:
* Return Data:
***********************************************************************************/
- (void)deleteFile:(NSString *)fileName {
    FileDeleteReq *myFile = [[FileDeleteReq alloc] init];
    myFile.fileName = fileName;
    [self.bleManager receiveApiCmd:BikeComputerPostDeleteFile withObject:myFile];
}


/*-********************************************************************************
* Method: setSettingInfo
* Description: setSettingInfo
* Parameter:
* Return Data:
***********************************************************************************/
- (void)setSettingInfo:(NSDictionary *)setMap {
    OBKFormatTools *formatTools = [[OBKFormatTools alloc] init];
    NSData *jsonData = [formatTools mapToData:setMap];
    
    OBKBikeComputerFile *flieInfo = [[OBKBikeComputerFile alloc] init];
    flieInfo.fileName = @"Setting.json";
    flieInfo.size = (int) jsonData.length;
    flieInfo.fitData = jsonData;
    
    [self.bleManager receiveApiCmd:BikeComputerPostFileInfo withObject:flieInfo];
}


/*-********************************************************************************
* Method: stopSendFile
* Description: stopSendFile
* Parameter:
* Return Data:
***********************************************************************************/
- (void)stopSendFile {
    [self.bleManager receiveApiCmd:BikeComputerPostStopFile withObject:nil];
}


/*-********************************************************************************
* Method: sendFileStatus
* Description: sendFileStatus
* Parameter:
* Return Data:
***********************************************************************************/
- (void)sendFileStatus {
    [self.bleManager receiveApiCmd:BikeComputerGetFileStatus withObject:nil];
}


/*-********************************************************************************
* Method: getAvailableStorage
* Description: getAvailableStorage
* Parameter:
* Return Data:
***********************************************************************************/
- (void)getAvailableStorage {
    [self.bleManager receiveApiCmd:BikeComputerGetStorage withObject:nil];
}


#pragma mark - ****************************** Ble Delegate ************************
/*-********************************************************************************
* Method: bleResultData
* Description: bleResultData
* Parameter:
* Return Data:
***********************************************************************************/
- (void)bleResultData:(id)resultData withResultId:(int)resultId andDevice:(id)bleDevice {
    BikeComputerResultId resultIdNumber = (BikeComputerResultId) resultId;
    if (resultIdNumber == BikeResultDeviceInfo) {
        [self.delegate bikeComputerInfo:(DeviceInfo *)resultData andDevice:self];
    }
    else if (resultIdNumber == BikeResultFitList) {
        [self.delegate bikeFitList:(NSArray *)resultData andDevice:self];
    }
    else if (resultIdNumber == BikeResultSettingJson) {
        [self.delegate bikeSettingInfo:(NSDictionary *)resultData andDevice:self];
    }
    else if (resultIdNumber == BikeResultFitData) {
        [self.delegate bikeFitData:(OBKBikeComputerFile *)resultData andDevice:self];
    }
    else if (resultIdNumber == BikeResultFileStatus) {
        [self.delegate bikeSendFileStatus:(FileTransStatusGetRsp *)resultData andDevice:self];
    }
    else if (resultIdNumber == BikeResultGetStorage) {
        [self.delegate bikeAvailableStorage:(StorageGetRsp *)resultData andDevice:self];
    }
}

@end
