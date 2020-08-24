/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKApiBikeComputer.h
* Function : BikeComputer Api
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.15
***********************************************************************************/

#import <Foundation/Foundation.h>
#import "OBKBikeComputerFile.h"
#import "OBKApiBase.h"

@protocol OBKApiBikeComputerDelegate <NSObject>

- (void)bikeComputerInfo:(DeviceInfo *)deviceInfo andDevice:(id)bleDevice;

- (void)bikeFitList:(NSArray *)fitArray andDevice:(id)bleDevice;

- (void)bikeSettingInfo:(NSDictionary *)setMap andDevice:(id)bleDevice;

- (void)bikeFitData:(OBKBikeComputerFile *)fitData andDevice:(id)bleDevice;

- (void)bikeSendFileStatus:(FileTransStatusGetRsp *)transStatus andDevice:(id)bleDevice;

- (void)bikeAvailableStorage:(StorageGetRsp *)storage andDevice:(id)bleDevice;

@end


@interface OBKApiBikeComputer : OBKApiBase

@property(assign,nonatomic)id <OBKApiBikeComputerDelegate> delegate;

- (void)getDeviceInformation;

- (void)setUtc:(UtcInfo *)utcInfo;

- (void)resetDevice;

- (void)getHistory;

- (void)getFitList;

- (void)getSettingJson;

- (void)getFitFileData:(NSString *)fitName;

- (void)deleteFile:(NSString *)fileName;

- (void)setSettingInfo:(NSDictionary *)setMap;

- (void)stopSendFile;

- (void)sendFileStatus;

- (void)getAvailableStorage;

@end
