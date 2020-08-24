/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: ViewController.m
* Function : Main View
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.11
***********************************************************************************/

#import "ViewController.h"
#import "BikeComputerViewController.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate> {
    UITableView    *m_deviceTypeTableView;
    NSMutableArray *m_deviceTypeArray;
}

@end

@implementation ViewController

#pragma mark - ****************************** System ******************************
/*-********************************************************************************
* Method: viewDidLoad
* Description: viewDidLoad
* Parameter:
* Return Data:
***********************************************************************************/
- (void)viewDidLoad {
    [super viewDidLoad];

    m_deviceTypeArray = [[NSMutableArray alloc] initWithObjects:
                         @"BikeComputer",
                         nil];
    
    [self loadHeadView];
    [self loadContentView];
}


#pragma mark - ****************************** View ********************************
/*-********************************************************************************
* Method: loadHeadView
* Description: loadHeadView
* Parameter:
* Return Data:
***********************************************************************************/
- (void)loadHeadView {
    self.leftButton.hidden = true;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *nowVerString = [NSString stringWithFormat:@"%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    self.centerLabel.text = [NSString stringWithFormat:@"OneBleKit V%@",nowVerString];
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
    
    m_deviceTypeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-80)];
    m_deviceTypeTableView.delegate = self;
    m_deviceTypeTableView.dataSource = self;
    m_deviceTypeTableView.backgroundColor = [UIColor clearColor];
    [m_deviceTypeTableView setTableFooterView:footerView];
    m_deviceTypeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:m_deviceTypeTableView];
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
    return m_deviceTypeArray.count;
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
    
    UILabel *info1Lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-20, 50)];
    info1Lab.textAlignment = NSTextAlignmentLeft;
    info1Lab.font = [UIFont systemFontOfSize:15];
    info1Lab.textColor = [UIColor blackColor];
    info1Lab.text = [NSString stringWithFormat:@"%@",[m_deviceTypeArray objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:info1Lab];
    
    UIImageView *nextImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-32, 17, 16, 16)];
    nextImg.backgroundColor = [UIColor clearColor];
    nextImg.image = [UIImage imageNamed:@"img_app_next.png"];
    [cell.contentView addSubview:nextImg];
    
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
    
    if (myRow == 0) {
        BikeComputerViewController *bikeComputerView = [[BikeComputerViewController alloc] init];
        [self.navigationController pushViewController:bikeComputerView animated:YES];
    }
}


@end
