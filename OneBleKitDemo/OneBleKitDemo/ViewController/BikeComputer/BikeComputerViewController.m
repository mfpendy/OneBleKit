/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: BikeComputerViewController.m
* Function : Bike Computer View
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.14
***********************************************************************************/

#import "BikeComputerViewController.h"
#import "ScannerViewController.h"
#import "FitcareBleV10.pbobjc.h"
#import "OBKBleTools.h"

@interface BikeComputerViewController ()<UITableViewDataSource, UITableViewDelegate, ScanViewDelegate, OBKApiBsaeDelegate, OBKApiBikeComputerDelegate> {
    UITableView    *m_bikeTableView;
    NSMutableArray *m_bikeCmdArray;
    UITableView    *m_fitTableView;
    NSMutableArray *m_fitArray;
    OBKBleDevice *m_myDevice;
    OBKApiBikeComputer *m_bikeApi;
    BOOL m_isBleAvailable;
    UIDocumentInteractionController *m_documentController;
    UITextView     *m_content;
    NSMutableDictionary *m_settingMap;
}

@end

@implementation BikeComputerViewController

#pragma mark - ****************************** System ******************************
/*-********************************************************************************
* Method: viewDidLoad
* Description: viewDidLoad
* Parameter:
* Return Data:
***********************************************************************************/
- (void)viewDidLoad {
    [super viewDidLoad];

    m_bikeApi = [[OBKApiBikeComputer alloc] init];
    m_bikeApi.delegate = self;
    m_bikeApi.baseDelegate = self;
    [m_bikeApi setDebugMode:true];
    
    m_settingMap = [[NSMutableDictionary alloc] init];
    m_isBleAvailable = false;
    m_fitArray = [[NSMutableArray alloc] init];
    m_bikeCmdArray = [[NSMutableArray alloc] initWithObjects:
                      @"Get Device Information",
                      @"Set UTC",
                      @"Reset Device",
                      @"Get History",
                      @"Get Fit List",
                      @"Get Setting Info",
                      @"Get Send File Status",
                      @"Get Storage",
                      @"Set Setting Info",
                      @"Stop Send File",
                      nil];
    
    [self loadHeadView];
    [self loadContentView];
}


/*-********************************************************************************
* Method: viewDidDisappear
* Description: viewDidDisappear
* Parameter:
* Return Data:
***********************************************************************************/
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:true];
    
    if (m_bikeApi != nil) {
        [m_bikeApi disconnectBleDevice];
    }
}


#pragma mark - ****************************** View ********************************
/*-********************************************************************************
* Method: loadHeadView
* Description: loadHeadView
* Parameter:
* Return Data:
***********************************************************************************/
- (void)loadHeadView {
    self.centerLabel.text = @"BikeComputer";
    self.statusLabel.hidden = false;
    self.rightButton.hidden = false;
}


/*-********************************************************************************
* Method: loadContentView
* Description: loadContentView
* Parameter:
* Return Data:
***********************************************************************************/
- (void)loadContentView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    footerView.backgroundColor = [UIColor clearColor];
    
    m_bikeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-280)];
    m_bikeTableView.delegate = self;
    m_bikeTableView.dataSource = self;
    m_bikeTableView.backgroundColor = [UIColor whiteColor];
    [m_bikeTableView setTableFooterView:footerView];
    m_bikeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:m_bikeTableView];
    
    m_content = [[UITextView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 200)];
    m_content.backgroundColor = [UIColor lightGrayColor];
    m_content.font = [UIFont systemFontOfSize:16];
    m_content.text = @"";
    m_content.textColor = [UIColor blackColor];
    [m_content setEditable:NO];
    [self.view addSubview:m_content];
    
    m_fitTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-80)];
    m_fitTableView.delegate = self;
    m_fitTableView.dataSource = self;
    m_fitTableView.backgroundColor = [UIColor whiteColor];
    m_fitTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_fitTableView.hidden = true;
    [self.view addSubview:m_fitTableView];
}


#pragma mark - ****************************** Action ******************************
/*-********************************************************************************
* Method: backAction
* Description: backAction
* Parameter:
* Return Data:
***********************************************************************************/
- (void)backAction {
    if (m_fitTableView.hidden) {
        [self.navigationController popViewControllerAnimated:true];
    }
    else {
        m_fitTableView.hidden = true;
        self.centerLabel.text = @"BikeComputer";
        self.statusLabel.hidden = false;
        self.rightButton.hidden = false;
    }
}

/*-********************************************************************************
* Method: chooseDevice
* Description: chooseDevice
* Parameter:
* Return Data:
***********************************************************************************/
- (void)rightAction {
    ScannerViewController *scannerView = [[ScannerViewController alloc] init];
    scannerView.delegate = self;
    [self.navigationController pushViewController:scannerView animated:YES];
}


#pragma mark - ****************************** Scan Delegate ***********************
/*-********************************************************************************
* Method: postDevice
* Description: postDevice
* Parameter:
* Return Data:
***********************************************************************************/
- (void)postDevice:(OBKBleDevice *)myDevice {
    m_myDevice = myDevice;
    if (m_isBleAvailable) {
        [m_bikeApi connectBleDevice:m_myDevice.uuidString andIdType:DeviceIdUUID];
    }
}


#pragma mark - ****************************** BLE Delegate ************************
/*-********************************************************************************
* Method: bleConnectError
* Description: bleConnectError
* Parameter:
* Return Data:
***********************************************************************************/
- (void)bleConnectError:(id)errorInfo andDevice:(id)bleDevice {
}


/*-********************************************************************************
* Method: bleConnectError
* Description: bleConnectError
* Parameter:
* Return Data:
***********************************************************************************/
- (void)bleConnectStatus:(DeviceBleStatus)status andDevice:(id)bleDevice {
    if (status == DeviceBleIsOpen) {
        m_isBleAvailable = true;
        if (m_myDevice != nil) {
            [m_bikeApi connectBleDevice:m_myDevice.uuidString andIdType:DeviceIdUUID];
        }
    }
    
    self.statusLabel.text = [ShowTools showDeviceStatus:status];
}


/*-********************************************************************************
* Method: bleConnectError
* Description: bleConnectError
* Parameter:
* Return Data:
***********************************************************************************/
- (void)bikeComputerInfo:(DeviceInfo *)deviceInfo andDevice:(id)bleDevice{
    m_content.text = [NSString stringWithFormat:@"%@",deviceInfo];
}


/*-********************************************************************************
* Method: bikeFitList
* Description: bikeFitList
* Parameter:
* Return Data:
***********************************************************************************/
- (void)bikeFitList:(NSArray *)fitArray andDevice:(id)bleDevice {
    for (int i = 0; i <fitArray.count; i++) {
        OBKBikeComputerFile *resultFile = [fitArray objectAtIndex:i];
        NSLog(@"name:%@---size:%i",resultFile.fileName, resultFile.size);
    }
    
    if (fitArray.count > 0) {
        [m_fitArray removeAllObjects];
        [m_fitArray addObjectsFromArray:fitArray];
        self.centerLabel.text = @"FitFile";
        self.statusLabel.hidden = true;
        self.rightButton.hidden = true;
        m_fitTableView.hidden = false;
        [m_fitTableView reloadData];
    }
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Fit File" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

/*-********************************************************************************
* Method: bikeSettingJson
* Description: bikeSettingJson
* Parameter:
* Return Data:
***********************************************************************************/
- (void)bikeSettingInfo:(NSDictionary *)setMap andDevice:(id)bleDevice {
    m_content.text = [NSString stringWithFormat:@"%@",setMap];
    [m_settingMap removeAllObjects];
    [m_settingMap addEntriesFromDictionary:setMap];
}


/*-********************************************************************************
* Method: bikeFitData
* Description: bikeFitData
* Parameter:
* Return Data:
***********************************************************************************/
- (void)bikeFitData:(OBKBikeComputerFile *)fitData andDevice:(id)bleDevice {
    for (int i = 0; i < m_fitArray.count; i++) {
        OBKBikeComputerFile *listFile = [m_fitArray objectAtIndex:i];
        if ([listFile.fileName isEqualToString:fitData.fileName]) {
            [m_fitArray replaceObjectAtIndex:i withObject:fitData];
            break;
        }
    }
    
    [m_fitTableView reloadData];
}


/*-********************************************************************************
* Method: bikeSendFileStatus
* Description: bikeSendFileStatus
* Parameter:
* Return Data:
***********************************************************************************/
- (void)bikeSendFileStatus:(FileTransStatusGetRsp *)transStatus andDevice:(id)bleDevice {
    if (transStatus.fileTransStatus == FileTransStatus_FileTransStatusTrans) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Is sending sile，Please try again later." message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    m_content.text = [NSString stringWithFormat:@"%@",transStatus];
}

/*-********************************************************************************
* Method: bikeAvailableStorage
* Description: bikeAvailableStorage
* Parameter:
* Return Data:
***********************************************************************************/
- (void)bikeAvailableStorage:(StorageGetRsp *)storage andDevice:(id)bleDevice {
    m_content.text = [NSString stringWithFormat:@"%@",storage];
}


#pragma mark - ****************************** Back Delegate ***********************
/*-********************************************************************************
* Method: gestureRecognizerShouldBegin
* Description: gestureRecognizerShouldBegin
* Parameter:
* Return Data:
***********************************************************************************/
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if(m_fitTableView.hidden) {
        return YES;
    }
    else {
        return false;
    }
}


#pragma mark - ****************************** Delegate ****************************
/*-********************************************************************************
* Method: numberOfSectionsInTableView
* Description: numberOfSectionsInTableView
* Parameter:
* Return Data:
***********************************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


/*-********************************************************************************
* Method: numberOfRowsInSection
* Description: numberOfRowsInSection
* Parameter:
* Return Data:
***********************************************************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == m_bikeTableView) {
        return m_bikeCmdArray.count;
    }
    else {
        return m_fitArray.count;
    }
}


/*-********************************************************************************
* Method: heightForRowAtIndexPath
* Description: heightForRowAtIndexPath
* Parameter:
* Return Data:
***********************************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


/*-********************************************************************************
* Method: heightForHeaderInSection
* Description: heightForHeaderInSection
* Parameter:
* Return Data:
***********************************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}


/*-********************************************************************************
* Method: viewForHeaderInSection
* Description: viewForHeaderInSection
* Parameter:
* Return Data:
***********************************************************************************/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIView *lineB = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
    lineB.backgroundColor = [UIColor clearColor];
    [headView addSubview:lineB];
    
    return headView;
}


/*-********************************************************************************
* Method: cellForRowAtIndexPath
* Description: cellForRowAtIndexPath
* Parameter:
* Return Data:
***********************************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellString = @"MainViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
    }
    
    for (id view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
    if (tableView == m_bikeTableView) {
        UILabel *info1Lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-20, 50)];
        info1Lab.textAlignment = NSTextAlignmentLeft;
        info1Lab.font = [UIFont systemFontOfSize:15];
        info1Lab.textColor = [UIColor blackColor];
        info1Lab.text = [NSString stringWithFormat:@"%@",[m_bikeCmdArray objectAtIndex:indexPath.row]];
        [cell.contentView addSubview:info1Lab];
        
        UIImageView *nextImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-32, 17, 16, 16)];
        nextImg.backgroundColor = [UIColor clearColor];
        nextImg.image = [UIImage imageNamed:@"img_app_next.png"];
        [cell.contentView addSubview:nextImg];
    }
    else if (tableView == m_fitTableView) {
        OBKBikeComputerFile *resultFile = [m_fitArray objectAtIndex:indexPath.row];
        
        UILabel *info1Lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-20, 50)];
        info1Lab.textAlignment = NSTextAlignmentLeft;
        info1Lab.font = [UIFont systemFontOfSize:15];
        info1Lab.textColor = [UIColor blackColor];
        info1Lab.text = [NSString stringWithFormat:@"%@ (%i)",resultFile.fileName,resultFile.size];
        [cell.contentView addSubview:info1Lab];
        
        if (resultFile.fitData.length > 0) {
            info1Lab.textColor = [UIColor blueColor];
        }
    }
    
    UIView *myLine = [[UIView alloc] initWithFrame:CGRectMake(0, 49, self.view.frame.size.width, 1)];
    myLine.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:myLine];
    
    return cell;
}


/*-********************************************************************************
* Method: didSelectRowAtIndexPath
* Description: didSelectRowAtIndexPath
* Parameter:
* Return Data:
***********************************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int myRow = (int)indexPath.row;
    
    if (tableView == m_bikeTableView) {
        if (m_bikeApi.isConnected) {
            if (myRow == 0) {
                [m_bikeApi getDeviceInformation];
            }
            else if (myRow == 1) {
                OBKDateTools *dataTool = [[OBKDateTools alloc] init];
                UtcInfo *myUtc = [[UtcInfo alloc] init];
                myUtc.tiemZone = (double)[dataTool getTimeZoneNumber:[NSDate date]] / 3600.0;
                myUtc.utc = [dataTool dateToTimestamp:[NSDate date]];
                [m_bikeApi setUtc:myUtc];
            }
            else if (myRow == 2) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reset Device" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *downAction = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self->m_bikeApi resetDevice];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:downAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else if (myRow == 3) {
                [m_bikeApi getHistory];
            }
            else if (myRow == 4) {
                [m_bikeApi getFitList];
            }
            else if (myRow == 5) {
                [m_bikeApi getSettingJson];
            }
            else if (myRow == 6) {
                [m_bikeApi sendFileStatus];
            }
            else if (myRow == 7) {
                [m_bikeApi getAvailableStorage];
            }
            else if (myRow == 8) {
                if (m_settingMap.allKeys.count == 0) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Please Get Setting Info First" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                    return;
                }
                [self getAgeUi];
            }
            else if (myRow == 9) {
                [m_bikeApi stopSendFile];
            }
        }
    }
    else if (tableView == m_fitTableView) {
        if (m_bikeApi.isConnected) {
            OBKBikeComputerFile *resultFile = [m_fitArray objectAtIndex:indexPath.row];
            if (resultFile.fitData.length == 0) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:resultFile.fileName message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *downAction = [UIAlertAction actionWithTitle:@"DownLoad" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self->m_bikeApi getFitFileData:resultFile.fileName];
                }];
                UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self->m_bikeApi deleteFile:resultFile.fileName];
                    [self->m_fitArray removeObjectAtIndex:indexPath.row];
                    [self->m_fitTableView reloadData];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:downAction];
                [alertController addAction:deleteAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:resultFile.fileName message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *downAction = [UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self shareLog:resultFile];
                }];
                UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self->m_bikeApi deleteFile:resultFile.fileName];
                    [self->m_fitArray removeObjectAtIndex:indexPath.row];
                    [self->m_fitTableView reloadData];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:downAction];
                [alertController addAction:deleteAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    }
    
}


- (void)getAgeUi {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"age" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *inputField = alertController.textFields.firstObject;
        NSString *maxString = inputField.text;
        NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] initWithDictionary:[self->m_settingMap objectForKey:@"user_profile"]];
        [userProfile setObject:[NSNumber numberWithInt:[maxString intValue]] forKey:@"age"];
        [self->m_settingMap setObject:userProfile forKey:@"user_profile"];
        [self->m_bikeApi setSettingInfo:self->m_settingMap];
        self->m_content.text = [NSString stringWithFormat:@"%@",self->m_settingMap];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)shareLog:(OBKBikeComputerFile *)fileData {
    OBKFileOperate *myFile = [[OBKFileOperate alloc] init];
    [myFile saveDataToFile:fileData.fitData withName:fileData.fileName];
    NSString *fileString = [myFile dataFilePath:fileData.fileName];
    NSURL *filePath = [NSURL fileURLWithPath:fileString];
    m_documentController = [UIDocumentInteractionController interactionControllerWithURL:filePath];
    m_documentController.UTI = @"public.text";
    [m_documentController presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
}



@end
