/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKBikeComputerFile.h
* Function : BikeComputer File
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.19
***********************************************************************************/
#import "OBKBikeComputerFile.h"

@implementation OBKBikeComputerFile

#pragma mark - ****************************** System ******************************
/*-********************************************************************************
* Method: init
* Description: init
* Parameter:
* Return Data:
***********************************************************************************/
- (id)init {
    self.size = 0;
    self.fileName = [[NSString alloc] init];
    self.fitData = [[NSData alloc] init];
    return self;
}

@end
