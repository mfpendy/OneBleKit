/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: ScannerViewController.h
* Function : Scanner View
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.14
***********************************************************************************/

#import "BaseViewController.h"
#import "ShowTools.h"

@protocol ScanViewDelegate <NSObject>
- (void)postDevice:(OBKBleDevice *)myDevice;
@end

@interface ScannerViewController : BaseViewController

@property(assign,nonatomic) id <ScanViewDelegate> delegate;

@end
