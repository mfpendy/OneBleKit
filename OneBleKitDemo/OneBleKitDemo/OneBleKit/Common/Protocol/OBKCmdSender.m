/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: OBKCmdSender.m
* Function : Cmd Sender
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.18
***********************************************************************************/

#import "OBKCmdSender.h"

#define CMD_SENDER_COUNT 4

@implementation OBKCmdSender {
    int m_sidNumber;
    NSMutableArray *m_cmdQueueArray;
    OBKCmdValues *m_buferData;
    OBKCmdValues *m_againData;
    int m_againNumber;
    NSTimer *m_timeOutTimer;
}

#pragma mark - ****************************** System ******************************
/*-********************************************************************************
* Method: init
* Description: init
* Parameter:
* Return Data:
***********************************************************************************/
- (id)init {
    self = [super init];
    m_sidNumber = -1;
    m_againNumber = 0;
    m_cmdQueueArray = [[NSMutableArray alloc] init];
    m_againData = [[OBKCmdValues alloc] init];
    [self startTimer];
    return self;
}


/*-********************************************************************************
* Method: dealloc
* Description: dealloc
* Parameter:
* Return Data:
***********************************************************************************/
- (void)dealloc {
    if (m_timeOutTimer != nil) {
        [m_timeOutTimer invalidate];
        m_timeOutTimer = nil;
    }
}


/*-********************************************************************************
* Method: startTimer
* Description: startTimer
* Parameter:
* Return Data:
***********************************************************************************/
- (void)startTimer {
    [m_timeOutTimer invalidate];
    m_timeOutTimer = nil;
    m_timeOutTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                    target:self
                                                  selector:@selector(sendAgain)
                                                  userInfo:nil
                                                   repeats:YES];
}


/*-********************************************************************************
* Method: sendAgain
* Description: sendAgain
* Parameter:
* Return Data:
***********************************************************************************/
- (void)sendAgain {
    if (m_buferData != nil) {
        NSLog(@"sendAgain %@",m_buferData);
        [m_timeOutTimer invalidate];
        m_timeOutTimer = nil;
        [self sendBandCmd:m_buferData];
    }
}


#pragma mark - ****************************** Interface ***************************
/*-********************************************************************************
* Method: getSidNumber
* Description: getSidNumber
* Parameter:
* Return Data:
***********************************************************************************/
- (int)getSidNumber {
    if (m_sidNumber == 15) {
        m_sidNumber = 0;
    }
    else {
        m_sidNumber = m_sidNumber + 1;
    }
    
    if (m_sidNumber == -1) {
        m_sidNumber = 0;
    }
    
    return m_sidNumber;
}


/*-********************************************************************************
* Method: insertQueueData
* Description: insertQueueData
* Parameter:
* Return Data:
***********************************************************************************/
- (void)insertQueueData:(OBKCmdValues *)cmdValue {
    [m_cmdQueueArray addObject:cmdValue];
    [self setBuferData];
}


/*-********************************************************************************
* Method: setBuferData
* Description: setBuferData
* Parameter:
* Return Data:
***********************************************************************************/
- (void)setBuferData {
    if (m_buferData == nil && m_cmdQueueArray.count > 0) {
        m_buferData = [[OBKCmdValues alloc] init];
        [m_buferData setValue:[m_cmdQueueArray objectAtIndex:0]];
        [m_cmdQueueArray removeObjectAtIndex:0];
        [self sendBandCmd:m_buferData];
    }
}


/*-********************************************************************************
* Method: setBuferData
* Description: setBuferData
* Parameter:
* Return Data:
***********************************************************************************/
- (void)sendBandCmd:(OBKCmdValues *)cmdValue {
    if ([m_againData isEqualValue:cmdValue]) {
        if (m_againNumber == CMD_SENDER_COUNT) {
            [m_timeOutTimer invalidate];
            m_timeOutTimer = nil;
            m_buferData = nil;
            [self setBuferData];
            m_againNumber = 0;
            return;
        }
        m_againNumber++;
    }
    [m_againData setValue:cmdValue];
    
    [self.delegate sendBleCmdData:cmdValue];
    [self startTimer];
}


/*-********************************************************************************
* Method: sendCmdSuseed
* Description: sendCmdSuseed
* Parameter:
* Return Data:
***********************************************************************************/
- (void)sendCmdSuseed:(int)sid {
    [m_timeOutTimer invalidate];
    m_timeOutTimer = nil;
    m_buferData = nil;
    [self setBuferData];
    m_againNumber = 0;
}


@end
