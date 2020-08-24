/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKCmdValues.m
* Function : Cmd Values
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.18
***********************************************************************************/

#import "OBKCmdValues.h"

@implementation OBKCmdValues

#pragma mark - ****************************** System ******************************
/*-********************************************************************************
* Method: init
* Description: init
* Parameter:
* Return Data:
***********************************************************************************/
- (id)init {
    self.oidNumber = 0;
    self.sidNumber = 0;
    self.cmdArray = [[NSArray alloc] init];
    self.sendUuid = [[OBKDeviceUuid alloc] init];
    return self;
}


/*-********************************************************************************
* Method: setValue
* Description: setValue
* Parameter:
* Return Data:
***********************************************************************************/
- (void)setValue:(OBKCmdValues *)newVlaue {
    self.oidNumber = newVlaue.oidNumber;
    self.sidNumber = newVlaue.sidNumber;
    self.cmdArray = newVlaue.cmdArray;
    self.sendUuid = newVlaue.sendUuid;
}


/*-********************************************************************************
* Method: isEqualValue
* Description: isEqualValue
* Parameter:
* Return Data:
***********************************************************************************/
- (BOOL)isEqualValue:(OBKCmdValues *)newVlaue {
    if (newVlaue.cmdArray.count != self.cmdArray.count) {
        return false;
    }
    
    BOOL isAllSame = TRUE;
    for (int i = 0; i < self.cmdArray.count; i++) {
        NSData *myData = [self.cmdArray objectAtIndex:i];
        NSData *newData = [newVlaue.cmdArray objectAtIndex:i];
        if (![myData isEqualToData:newData]) {
            isAllSame = false;
            break;
        }
    }
    
    if (self.oidNumber == newVlaue.oidNumber && self.sidNumber == newVlaue.sidNumber && isAllSame) {
        return true;
    }
    return false;
}


@end
