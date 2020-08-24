/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKCmdValues.h
* Function : Cmd Values
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.18
***********************************************************************************/

#import <Foundation/Foundation.h>
#import "OBKDeviceUuid.h"

@interface OBKCmdValues : NSObject

@property (assign, nonatomic) int oidNumber;
@property (assign, nonatomic) int sidNumber;
@property (strong, nonatomic) NSArray *cmdArray;
@property (strong, nonatomic) OBKDeviceUuid *sendUuid;

- (void)setValue:(OBKCmdValues *)newVlaue;

- (BOOL)isEqualValue:(OBKCmdValues *)newVlaue;

@end
