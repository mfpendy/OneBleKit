/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKFileOperate.m
* Function : File Operate
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.19
***********************************************************************************/

#import "OBKFileOperate.h"

@implementation OBKFileOperate

/*-********************************************************************************
* Method: fileInBundle
* Description: file In Bundle
* Parameter:
* Return Data:
***********************************************************************************/
- (NSString *)fileInBundle:(NSString *)fileName withType:(NSString *)typeName {
    if (![fileName isMemberOfClass:[NSNull class]] &&
        fileName != nil &&
        ![typeName isMemberOfClass:[NSNull class]] &&
        typeName != nil) {
        return [[NSBundle mainBundle] pathForResource:fileName ofType:typeName];
    }
    else {
        return nil;
    }
}


/*-********************************************************************************
* Method: dataFilePath
* Description: data File Path
* Parameter:
* Return Data:
***********************************************************************************/
- (NSString *)dataFilePath:(NSString *)fileName {
    if (![fileName isMemberOfClass:[NSNull class]] && fileName != nil) {
        if (fileName.length != 0) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            return [documentsDirectory stringByAppendingPathComponent:fileName];
        }
        else {
            return nil;
        }
    }
    else {
        return nil;
    }
}

/*-********************************************************************************
* Method: saveDataToFile
* Description: save Data To File
* Parameter:
* Return Data:
***********************************************************************************/
- (BOOL)saveDataToFile:(NSData *)dataData withName:(NSString *)fileName {
    if ([self dataFilePath:fileName] != nil &&
        dataData != nil &&
        ![dataData isMemberOfClass:[NSNull class]]) {
        if (dataData.length != 0) {
            [dataData writeToFile:[self dataFilePath:fileName] atomically:YES];
            return YES;
        }
        else {
            return YES;
        }
    }
    else {
        return NO;
    }
}

/*-********************************************************************************
* Method: saveArrayToFile
* Description: save Array To File
* Parameter:
* Return Data:
***********************************************************************************/
- (BOOL)saveArrayToFile:(NSArray *)arrayData withName:(NSString *)fileName {
    if ([self dataFilePath:fileName] != nil &&
        arrayData != nil &&
        ![arrayData isMemberOfClass:[NSNull class]]) {
        if (arrayData.count != 0) {
            [arrayData writeToFile:[self dataFilePath:fileName] atomically:YES];
            return YES;
        }
        else {
            [arrayData writeToFile:[self dataFilePath:fileName] atomically:YES];
            return YES;
        }
    }
    else {
        return NO;
    }
}

/*-********************************************************************************
* Method: saveDictionaryToFile
* Description: save Dictionary To File
* Parameter:
* Return Data:
***********************************************************************************/
- (BOOL)saveDictionaryToFile:(NSDictionary *)dictionaryData withName:(NSString *)fileName {
    if ([self dataFilePath:fileName] != nil &&
        dictionaryData != nil &&
        ![dictionaryData isMemberOfClass:[NSNull class]]) {
        if (dictionaryData.allKeys.count != 0) {
            [dictionaryData writeToFile:[self dataFilePath:fileName] atomically:YES];
            return YES;
        }
        else {
            return YES;
        }
    }
    else {
        return NO;
    }
}

/*-********************************************************************************
* Method: saveStringToFile
* Description: save String To File
* Parameter:
* Return Data:
***********************************************************************************/
- (BOOL)saveStringToFile:(NSString *)stringData withName:(NSString *)fileName {
    if ([self dataFilePath:fileName] != nil &&
        stringData != nil &&
        ![stringData isMemberOfClass:[NSNull class]]) {
        if (stringData.length != 0) {
            [stringData writeToFile:[self dataFilePath:fileName]
                         atomically:YES
                           encoding:NSUTF8StringEncoding
                              error:nil];
            return YES;
        }
        else {
            return YES;
        }
    }
    else {
        return NO;
    }
}

/*-********************************************************************************
* Method: getDataFromFile
* Description: get Data From File
* Parameter:
* Return Data:
***********************************************************************************/
- (NSData *)getDataFromFile:(NSString *)fileName {
    NSString *filePath = [self dataFilePath:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        m_data = [[NSData alloc] initWithContentsOfFile:filePath];
        return m_data;
    }
    else {
        return nil;
    }
}

/*-********************************************************************************
* Method: getArrayFromFile
* Description: get Array From File
* Parameter:
* Return Data:
***********************************************************************************/
- (NSArray *)getArrayFromFile:(NSString *)fileName {
    NSString *filePath = [self dataFilePath:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        m_array = [[NSArray alloc] initWithContentsOfFile:filePath];
        return m_array;
    }
    else {
        return nil;
    }
}

/*-********************************************************************************
* Method: getDctionaryFromFile
* Description: get Dctionary From File
* Parameter:
* Return Data:
***********************************************************************************/
- (NSDictionary *)getDctionaryFromFile:(NSString *)fileName {
    NSString *filePath = [self dataFilePath:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        m_dictionary = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        return m_dictionary;
    }
    else {
        return nil;
    }
}

/*-********************************************************************************
* Method: getStringFromFile
* Description: get String From File
* Parameter:
* Return Data:
***********************************************************************************/
- (NSString *)getStringFromFile:(NSString *)fileName {
    NSString *filePath = [self dataFilePath:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        m_string = [[NSString alloc] initWithContentsOfFile:filePath
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
        return m_string;
    }
    else {
        return nil;
    }
}


@end
