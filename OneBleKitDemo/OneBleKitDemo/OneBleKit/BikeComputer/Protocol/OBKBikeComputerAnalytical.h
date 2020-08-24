/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKBikeComputerAnalytical.h
* Function : BikeComputer Analytical
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.15
***********************************************************************************/

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "FitcareBleV10.pbobjc.h"
#import "OBKBleTools.h"

typedef enum {
    BikeResultDeviceInfo = 0,
    BikeResultFitList = 1,
    BikeResultSettingJson = 2,
    BikeResultFitData = 3,
    BikeResultFileStatus = 4,
    BikeResultGetStorage = 5,
} BikeComputerResultId;


@protocol OBKBikeAnalyticalDelegate <NSObject>

- (void)receiveDataAck:(OBKAnalyValues *)dataValue;

- (void)analyticalResult:(id)resultData withResultNumber:(BikeComputerResultId)resultId;

@end



@interface OBKBikeComputerAnalytical : NSObject

@property(assign,nonatomic)id <OBKBikeAnalyticalDelegate> delegate;

- (void)receiveBleData:(CBCharacteristic *)characteristic;

@end
