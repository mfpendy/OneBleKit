/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKBikeComputerProtocol.h
* Function : BikeComputer Protocol
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.14
***********************************************************************************/

#import "OBKProtocolBase.h"
#import "OBKBikeComputerCmd.h"
#import "OBKBikeComputerAnalytical.h"
#import "OBKCmdSender.h"

typedef enum {
    BikeComputerGetDeviceInfo = 1,
    BikeComputerPostUtcInfo = 2,
    BikeComputerPostReset = 3,
    BikeComputerGetHistory = 21,
    BikeComputerGetFile = 41,
    BikeComputerPostDeleteFile = 42,
    BikeComputerPostFileInfo = 43,
    BikeComputerPostStopFile = 45,
    BikeComputerGetFileStatus = 50,
    BikeComputerGetStorage = 51,
} BikeComputerCmdId;


@interface OBKBikeComputerProtocol : OBKProtocolBase <OBKCmdSenderDelegate, OBKBikeAnalyticalDelegate>

@end
