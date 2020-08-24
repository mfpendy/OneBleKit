/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKCmdSender.h
* Function : Cmd Sender
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.18
***********************************************************************************/

#import <Foundation/Foundation.h>
#import "OBKCmdValues.h"

@protocol OBKCmdSenderDelegate <NSObject>

- (void)sendBleCmdData:(OBKCmdValues *)cmdValue;

@end


@interface OBKCmdSender : NSObject

@property(assign,nonatomic)id <OBKCmdSenderDelegate> delegate;

- (int)getSidNumber;

- (void)insertQueueData:(OBKCmdValues *)cmdValue;

- (void)sendCmdSuseed:(int)sid;

@end
