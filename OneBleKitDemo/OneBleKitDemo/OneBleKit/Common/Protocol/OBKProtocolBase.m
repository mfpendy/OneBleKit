/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKProtocolBase.m
* Function : Base Protocol
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.14
***********************************************************************************/

#import "OBKProtocolBase.h"

@implementation OBKProtocolBase

#pragma mark - ****************************** Interface ***************************
/*-********************************************************************************
* Method: receiveBleCmd
* Description: receiveBleCmd
* Parameter:
* Return Data:
***********************************************************************************/
- (void)receiveBleCmd:(int)cmdId withObject:(id)object {
}


/*-********************************************************************************
* Method: receiveBleData
* Description: receiveBleData
* Parameter:
* Return Data:
***********************************************************************************/
- (void)receiveBleData:(CBCharacteristic *)characteristic {
}


/*-********************************************************************************
* Method: setResponseMaxByte
* Description: setResponseMaxByte
* Parameter:
* Return Data:
***********************************************************************************/
- (void)setResponseMaxByte:(int)responseMax noResponseMaxByte:(int)noResponseMax {
}


/*-********************************************************************************
* Method: bleErrorDisconnected
* Description: bleErrorDisconnected
* Parameter:
* Return Data:
***********************************************************************************/
- (void)bleErrorDisconnected {
}


@end
