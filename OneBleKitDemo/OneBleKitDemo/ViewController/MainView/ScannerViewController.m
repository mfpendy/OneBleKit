/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: ScannerViewController.m
* Function : Scanner View
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.14
***********************************************************************************/

#import "ScannerViewController.h"

@interface ScannerViewController ()<UITableViewDataSource, UITableViewDelegate, OBKBleScannerDelegate> {
    UITableView    *m_deviceTableView;
    NSMutableArray *m_deviceArray;
    OBKBleScanner  *m_bleScanner;
    NSTimer        *m_reloadTimer;
    int m_chooseRow;
}

@end

@implementation ScannerViewController

#pragma mark - ****************************** System ******************************
/*-********************************************************************************
* Method: viewDidLoad
* Description: viewDidLoad
* Parameter:
* Return Data:
***********************************************************************************/
- (void)viewDidLoad {
    [super viewDidLoad];

    m_chooseRow = -1;
    m_deviceArray = [[NSMutableArray alloc] init];
    m_bleScanner = [[OBKBleScanner alloc] init];
    m_bleScanner.delegate = self;
    m_bleScanner.limitRssi = -70;
    
    [self loadHeadView];
    [self loadContentView];
    
    m_reloadTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                       target:self
                                                     selector:@selector(reloadTable)
                                                     userInfo:nil
                                                      repeats:YES];
    [m_reloadTimer fire];
}


/*-********************************************************************************
* Method: viewWillDisappear
* Description: viewWillDisappear
* Parameter:
* Return Data:
***********************************************************************************/
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:true];
    
    if (m_bleScanner != nil) {
        [m_bleScanner stopScanBleDevice];
    }
    
    if (m_reloadTimer != nil) {
        [m_reloadTimer invalidate];
        m_reloadTimer = nil;
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
    self.centerLabel.text = @"Devices";
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
    
    m_deviceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-80)];
    m_deviceTableView.delegate = self;
    m_deviceTableView.dataSource = self;
    m_deviceTableView.backgroundColor = [UIColor clearColor];
    [m_deviceTableView setTableFooterView:footerView];
    m_deviceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:m_deviceTableView];
}


#pragma mark - ****************************** Action ******************************
/*-********************************************************************************
* Method: reloadTable
* Description: reloadTable
* Parameter:
* Return Data:
***********************************************************************************/
- (void)reloadTable {
    [m_deviceTableView reloadData];
}


#pragma mark - ****************************** Ble Delegate ************************
/*-********************************************************************************
* Method: phoneBleStatus
* Description: phoneBleStatus
* Parameter:
* Return Data:
***********************************************************************************/
- (void)phoneBleStatus:(BOOL)isPoweredOn {
    if (isPoweredOn) {
        [m_bleScanner startScanBleDevice];
    }
}


/*-********************************************************************************
* Method: scanDeviceResult
* Description: scanDeviceResult
* Parameter:
* Return Data:
***********************************************************************************/
- (void)scanDeviceResult:(NSArray *)devices {
    [m_deviceArray removeAllObjects];
    [m_deviceArray addObjectsFromArray:devices];
}


#pragma mark - ****************************** Table Delegate **********************
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
    return m_deviceArray.count;
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
    static NSString *cellString = @"ScanViewCell";
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
    
    OBKBleDevice *myDevice = [m_deviceArray objectAtIndex:indexPath.row];
    UILabel *info1Lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-20, 50)];
    info1Lab.textAlignment = NSTextAlignmentLeft;
    info1Lab.font = [UIFont systemFontOfSize:15];
    info1Lab.textColor = [UIColor blackColor];
    info1Lab.text = [NSString stringWithFormat:@"%@   %i",myDevice.name,myDevice.rssi];
    [cell.contentView addSubview:info1Lab];
    
    if (m_chooseRow == indexPath.row) {
        UIImageView *chooseImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-32, 17, 16, 16)];
        chooseImg.backgroundColor = [UIColor clearColor];
        chooseImg.image = [UIImage imageNamed:@"img_app_choose.png"];
        [cell.contentView addSubview:chooseImg];
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
    
    if (m_chooseRow == -1) {
        m_chooseRow = myRow;
        [m_deviceTableView reloadData];
        
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            OBKBleDevice *myDevice = [self->m_deviceArray objectAtIndex:indexPath.row];
            [self.delegate postDevice:myDevice];
            [self.navigationController popViewControllerAnimated:true];
        });
    }
}

@end
