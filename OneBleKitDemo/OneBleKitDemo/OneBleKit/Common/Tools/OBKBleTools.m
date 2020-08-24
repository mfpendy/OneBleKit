/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKBleTools.m
* Function : Ble Tools
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.11
***********************************************************************************/

#import "OBKBleTools.h"

@implementation OBKBleTools


/*-********************************************************************************
* Method: getValueData
* Description: getValueData
* Parameter:
* Return Data:
***********************************************************************************/
- (OBKAnalyValues *)getValueData:(NSData *)value {
    NSMutableData *resultData = [[NSMutableData alloc] init];
    const uint8_t *cmdByte = (const uint8_t *)value.bytes;
    uint16_t length = (uint16_t)value.length;
    
    int byte0 = cmdByte[0] & 0xFF;
    int byte3 = cmdByte[3] & 0xFF;
    int byte4 = cmdByte[4] & 0xFF;
    
    int msgId = [self getBitNumber:byte0 withStart:6 andEnd:7];
    int transId = [self getBitNumber:byte0 withStart:4 andEnd:5];
    int sid = [self getBitNumber:byte0 withStart:0 andEnd:3];
    int oid = byte4 + (byte3<<8);
    
    for (int i = 5; i < length-2; i++) {
        int value = cmdByte[i];
        Byte bytes[1];
        bytes[0] = (Byte) (value);
        [resultData appendBytes:bytes length:sizeof(bytes)];
    }
    
    OBKAnalyValues *myAnalyValues = [[OBKAnalyValues alloc] init];
    myAnalyValues.oidNumber = oid;
    myAnalyValues.sidNumber = sid;
    myAnalyValues.cmdType = msgId;
    myAnalyValues.transType = transId;
    myAnalyValues.valueData = resultData;
    return myAnalyValues;
}


/*-********************************************************************************
* Method: isCRCCheckSucceed
* Description: isCRCCheckSucceed
* Parameter:
* Return Data:
***********************************************************************************/
- (BOOL)isCRCCheckSucceed:(NSData *)value {
    NSMutableData *resultData = [[NSMutableData alloc] init];
    const uint8_t *cmdByte = (const uint8_t *)value.bytes;
    uint16_t length = (uint16_t)value.length;
    for (int i = 0; i < length-2; i++) {
        int value = cmdByte[i];
        Byte bytes[1];
        bytes[0] = (Byte) (value);
        [resultData appendBytes:bytes length:sizeof(bytes)];
    }
    
    NSData *crcData = [self CheckCRCData:resultData];
    
    if ([value isEqualToData:crcData]) {
        return true;
    }
    else {
        return false;
    }
}


/*-********************************************************************************
* Method: stitchingData
* Description: Stitching Data
* Parameter:
* Return Data:
***********************************************************************************/
- (NSData *)stitchingData:(BleCmdType)cmdType withTrans:(BleTransType)transType andSid:(int)sid data:(NSData *)value {
    NSMutableData *resultData = [[NSMutableData alloc] init];
    
    int cmdTypeNumber = (int) cmdType;
    int transTypeNumber = (int) transType;
    int cmdLength = 5 + (int) value.length;
    
    Byte bytes[3];
    bytes[0] = (Byte) (cmdTypeNumber*64 + transTypeNumber*16 + sid);
    bytes[1] = (Byte) (cmdLength/256 > 256 ? 256:cmdLength/256);
    bytes[2] = (Byte) (cmdLength%256);
    [resultData appendBytes:bytes length:sizeof(bytes)];
    [resultData appendData:value];
    
    NSData *requestData = [self CheckCRCData:resultData];
    requestData = [self translationData:requestData isSend:true];
    requestData = [self baleCmdData:requestData isSend:true];
    return requestData;
}


/*-********************************************************************************
* Method: CheckCRCData
* Description: Check CRC Data
* Parameter:
* Return Data:
***********************************************************************************/
- (NSData *)CheckCRCData:(NSData *)cmdData {
    NSMutableData *resultData = [[NSMutableData alloc] initWithData:cmdData];
    const uint8_t *byte = (const uint8_t *)cmdData.bytes;
    uint16_t length = (uint16_t)cmdData.length;
    
    uint32_t size = length;
    uint16_t const * p_crc = 0;
    uint16_t crc = (p_crc == NULL) ? 0xFFFF : *p_crc;
    for (uint32_t i = 0; i < size; i++){
        crc  = (uint8_t)(crc >> 8) | (crc << 8);
        crc ^= byte[i];
        crc ^= (uint8_t)(crc & 0xFF) >> 4;
        crc ^= (crc << 8) << 4;
        crc ^= ((crc & 0xFF) << 4) << 1;
    }
    
    Byte bytes[2];
    bytes[0] = (Byte) (crc >> 8);
    bytes[1] = (Byte) (crc);

    [resultData appendBytes:bytes length:sizeof(bytes)];
    return resultData;
}


/*-********************************************************************************
* Method: translationData
* Description: translation Data
* Parameter:
* Return Data:
***********************************************************************************/
- (NSData *)translationData:(NSData *)cmdData isSend:(BOOL)isSend {
    NSMutableData *resultData = [[NSMutableData alloc] init];
    const uint8_t *cmdByte = (const uint8_t *)cmdData.bytes;
    uint16_t length = (uint16_t)cmdData.length;
    
    if (isSend) {
        for (int i = 0; i < length; i++) {
            int value = cmdByte[i];
            if (value == 125 || value == 126 || value == 127) {
                Byte bytes[2];
                bytes[0] = (Byte) (125);
                bytes[1] = (Byte) (value-124);
                [resultData appendBytes:bytes length:sizeof(bytes)];
            }
            else {
                Byte bytes[1];
                bytes[0] = (Byte) (value);
                [resultData appendBytes:bytes length:sizeof(bytes)];
            }
        }
    }
    else {
        BOOL isNextOn = true;
        for (int i = 0; i < length; i++) {
            if (isNextOn) {
                int value = cmdByte[i];
                if (value == 125 && i != length-1) {
                    int valueNext = cmdByte[i+1];
                    if (valueNext>0 && valueNext<4) {
                        isNextOn = false;
                        Byte bytes[1];
                        bytes[0] = (Byte) (value+valueNext-1);
                        [resultData appendBytes:bytes length:sizeof(bytes)];
                    }
                }
                else {
                    Byte bytes[1];
                    bytes[0] = (Byte) (value);
                    [resultData appendBytes:bytes length:sizeof(bytes)];
                }
            }
            else {
                isNextOn = true;
            }
        }
    }

    return resultData;
}


/*-********************************************************************************
* Method: baleCmdData
* Description: bale Cmd Data
* Parameter:
* Return Data:
***********************************************************************************/
- (NSData *)baleCmdData:(NSData *)cmdData isSend:(BOOL)isSend {
    NSMutableData *resultData = [[NSMutableData alloc] init];
    const uint8_t *cmdByte = (const uint8_t *)cmdData.bytes;
    uint16_t length = (uint16_t)cmdData.length;
    
    if (isSend) {
        Byte bytesSatrt[1];
        bytesSatrt[0] = (Byte) (126);
        [resultData appendBytes:bytesSatrt length:sizeof(bytesSatrt)];
        [resultData appendBytes:cmdByte length:length];
        
        Byte bytesEnd[1];
        bytesEnd[0] = (Byte) (127);
        [resultData appendBytes:bytesEnd length:sizeof(bytesEnd)];
    }
    else {
        for (int i = 1; i < length-1; i++) {
            int value = cmdByte[i];
            Byte bytes[1];
            bytes[0] = (Byte) (value);
            [resultData appendBytes:bytes length:sizeof(bytes)];
        }
    }
    
    return resultData;
}


/*-********************************************************************************
* Method: getPackageStatus
* Description: getPackageStatus
* Parameter:
* Return Data:
***********************************************************************************/
- (BlePackageStatus)getPackageStatus:(NSData *)cmdData {
    const uint8_t *cmdByte = (const uint8_t *)cmdData.bytes;
    
    if (cmdData.length > 1) {
        int startByte = cmdByte[0] & 0xFF;
        int endByte = cmdByte[cmdData.length-1] & 0xFF;
        if (startByte == 126 && endByte == 127) {
            return BlePackageOK;
        }
        else if (startByte == 126 && endByte != 127) {
            return BlePackageStart;
        }
        else if (startByte != 126 && endByte == 127) {
            return BlePackageEnd;
        }
        else {
            return BlePackageCenter;
        }
    }
    
    return BlePackageNil;
}


/*-********************************************************************************
* Method: getPackageStatus
* Description: getPackageStatus
* Parameter:
* Return Data:
***********************************************************************************/
- (int)getBitNumber:(int)dataNumber withStart:(int)start andEnd:(int)stop {
    if (start < 0 || start > 15) {
        return 0;
    }
    
    if (stop < 0 || stop > 15) {
        return 0;
    }
    
    if (start > stop) {
        return 0;
    }
    
    int resultNumber = (dataNumber & (0xFFFF >> (15 - stop))) >> start;
    return resultNumber;
}


@end
