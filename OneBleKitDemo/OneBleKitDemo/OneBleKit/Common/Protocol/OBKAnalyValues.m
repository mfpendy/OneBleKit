/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKAnalyValues.m
* Function : Analy Values
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.18
***********************************************************************************/

#import "OBKAnalyValues.h"

@implementation OBKAnalyValues

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
    self.cmdType = BleCmdTypeGet;
    self.transType = BleTransTypeResponse;
    self.valueData = [[NSData alloc] init];
    return self;
}


/*-********************************************************************************
* Method: setValue
* Description: setValue
* Parameter:
* Return Data:
***********************************************************************************/
- (void)logClass {
    NSLog(@"%i-%i-%i-%i-%@",self.oidNumber,self.sidNumber,self.cmdType,self.transType,self.valueData);
}

@end
