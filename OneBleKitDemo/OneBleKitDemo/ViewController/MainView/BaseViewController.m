/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: BaseViewController.m
* Function : Main View
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.14
***********************************************************************************/

#import "BaseViewController.h"

@interface BaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

#pragma mark - ****************************** System ******************************
/*-********************************************************************************
* Method: viewDidLoad
* Description: viewDidLoad
* Parameter:
* Return Data:
***********************************************************************************/
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    [self loadDefaultHeadView];
    
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}


#pragma mark - ****************************** View ********************************
/*-********************************************************************************
* Method: loadDefaultHeadView
* Description: loadDefaultHeadView
* Parameter:
* Return Data:
***********************************************************************************/
- (void)loadDefaultHeadView {
    self.defaultHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    self.defaultHeadView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.defaultHeadView];
    
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 16)];
    self.statusLabel.backgroundColor = [UIColor clearColor];
    self.statusLabel.text = @"Device status";
    self.statusLabel.textColor = [UIColor redColor];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.font = [UIFont systemFontOfSize:10];
    self.statusLabel.hidden = true;
    [self.defaultHeadView addSubview:self.statusLabel];
    
    self.centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 50)];
    self.centerLabel.backgroundColor = [UIColor clearColor];
    self.centerLabel.text = @"";
    self.centerLabel.textColor = [UIColor blackColor];
    self.centerLabel.textAlignment = NSTextAlignmentCenter;
    self.centerLabel.font = [UIFont systemFontOfSize:20];
    [self.defaultHeadView addSubview:self.centerLabel];

    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, 80, 50)];
    self.leftButton.backgroundColor = [UIColor clearColor];
    [self.leftButton setImage:[UIImage imageNamed:@"img_app_back.png"] forState:UIControlStateNormal];
    [self.leftButton setImageEdgeInsets:UIEdgeInsetsMake(13, 12, 13, 44)];
    [self.leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.defaultHeadView addSubview:self.leftButton];
    
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-80, 30, 80, 50)];
    self.rightButton.backgroundColor = [UIColor clearColor];
    [self.rightButton setTitle:@"Device" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.hidden = true;
    [self.defaultHeadView addSubview:self.rightButton];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 79, self.view.frame.size.width, 1)];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.defaultHeadView addSubview:self.lineView];
}


#pragma mark - ****************************** Action ******************************
/*-********************************************************************************
* Method: backAction
* Description: backAction
* Parameter:
* Return Data:
***********************************************************************************/
- (void)backAction {
    [self.navigationController popViewControllerAnimated:true];
}


/*-********************************************************************************
* Method: backAction
* Description: backAction
* Parameter:
* Return Data:
***********************************************************************************/
- (void)rightAction {
}


#pragma mark - ****************************** Delegate ****************************
/*-********************************************************************************
* Method: gestureRecognizerShouldBegin
* Description: gestureRecognizerShouldBegin
* Parameter:
* Return Data:
***********************************************************************************/
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if(self.navigationController.childViewControllers.count == 1) {
        return NO;
    }
    return YES;
}


@end
