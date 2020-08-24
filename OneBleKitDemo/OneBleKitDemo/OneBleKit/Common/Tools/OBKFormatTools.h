/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKFormatTools.h
* Function : Format Tools
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.22
***********************************************************************************/

#import <Foundation/Foundation.h>

@interface OBKFormatTools : NSObject

- (NSDictionary *)dataToMap:(NSData *)valueData;

- (NSData *)mapToData:(NSDictionary *)jsonMap;

@end
