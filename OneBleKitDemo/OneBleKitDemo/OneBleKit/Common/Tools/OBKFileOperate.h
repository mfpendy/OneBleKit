/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKFileOperate.h
* Function : File Operate
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.19
***********************************************************************************/

#import <Foundation/Foundation.h>

@interface OBKFileOperate : NSObject {
    NSData       *m_data;
    NSArray      *m_array;
    NSDictionary *m_dictionary;
    NSString     *m_string;
}

- (NSString *)fileInBundle:(NSString *)fileName withType:(NSString *)typeName;

- (NSString *)dataFilePath:(NSString *)fileName;

- (BOOL)saveDataToFile:(NSData *)dataData withName:(NSString *)fileName;

- (BOOL)saveArrayToFile:(NSArray *)arrayData withName:(NSString *)fileName;

- (BOOL)saveDictionaryToFile:(NSDictionary *)dictionaryData withName:(NSString *)fileName;

- (BOOL)saveStringToFile:(NSString *)stringData withName:(NSString *)fileName;

- (NSData *)getDataFromFile:(NSString *)fileName;

- (NSArray *)getArrayFromFile:(NSString *)fileName;

- (NSDictionary *)getDctionaryFromFile:(NSString *)fileName;

- (NSString *)getStringFromFile:(NSString *)fileName;

@end
