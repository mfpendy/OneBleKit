/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKBikeComputerCmd.h
* Function : BikeComputer Cmd
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.15
***********************************************************************************/

#import <Foundation/Foundation.h>
#import "FitcareBleV10.pbobjc.h"
#import "OBKCmdValues.h"

typedef enum {
    OidForGetDeviceInfo = 1,
    OidForPostUtcInfo = 2,
    OidForPostReset = 3,
    OidForGetHistory = 21,
    OidForGetFile = 41,
    OidForPostDeleteFile = 42,
    OidForPostFileInfo = 43,
    OidForReceiveFile = 44,
    OidForPostStopFile = 45,
    OidForGetFileStatus = 50,
    OidForGetStorage = 51,
} BikeComputerOid;

@interface OBKBikeComputerCmd : NSObject

@property(assign,nonatomic) int maxPacket;

@property(assign,nonatomic) int bluetoothMTU;

// Ack Commond
- (OBKCmdValues *)ackCommond:(int)sid withOid:(int)oid andCmdType:(BleCmdType)cmdType;

// Get Device Information
- (OBKCmdValues *)getDeviceInformation:(int)sid;

// Post Utc Info
- (OBKCmdValues *)postUtcInfo:(UtcInfo *)utcInfo withSid:(int)sid;

// Post Reset device
- (OBKCmdValues *)postResetDevice:(int)sid;

// Get History
- (OBKCmdValues *)getHistory:(int)sid;

// Get File Is Exist
- (OBKCmdValues *)getFileIsExist:(FileGetReq *)fileInfo withSid:(int)sid;

// Post Delete File
- (OBKCmdValues *)postDeleteFile:(FileDeleteReq *)fileInfo withSid:(int)sid;

// Post Send File Info
- (OBKCmdValues *)postSendFileInfo:(FileInfo *)fileInfo withSid:(int)sid;

// Post Stop Send File
- (OBKCmdValues *)postStopSendFile:(int)sid;

// Get Send File Status
- (OBKCmdValues *)getSendFileStatus:(int)sid;

// Get Available Storage
- (OBKCmdValues *)getAvailableStorage:(int)sid;

// Post File Data
- (NSArray *)postFileData:(NSData *)fileData withSid:(int)sid;

@end
