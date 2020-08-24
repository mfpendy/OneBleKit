/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKFormatTools.m
* Function : Format Tools
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.22
***********************************************************************************/

#import "OBKFormatTools.h"

@implementation OBKFormatTools

/*-********************************************************************************
* Method: jsonToMap
* Description: Json To Map
* Parameter:
* Return Data:
***********************************************************************************/
- (NSDictionary *)dataToMap:(NSData *)valueData {
    if (valueData == nil) {
        return nil;
    }
    NSError *err;
    NSDictionary *resultMap = [NSJSONSerialization JSONObjectWithData:valueData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        return nil;
    }
    return resultMap;
}


/*-********************************************************************************
* Method: mapToData
* Description: mapToData
* Parameter:
* Return Data:
***********************************************************************************/
- (NSData *)mapToData:(NSDictionary *)jsonMap {
    if ([NSJSONSerialization isValidJSONObject:jsonMap]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonMap options:NSJSONWritingPrettyPrinted error:nil];
        return jsonData;
    }
    return nil;
}


@end
