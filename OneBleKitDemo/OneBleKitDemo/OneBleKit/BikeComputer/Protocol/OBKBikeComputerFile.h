/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKBikeComputerFile.h
* Function : BikeComputer File
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.19
***********************************************************************************/

#import <Foundation/Foundation.h>

@interface OBKBikeComputerFile : NSObject

@property (assign, nonatomic) int size;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSData *fitData;

@end
