/*-********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: AppDelegate.m
* Function : AppDelegate
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.08.11
***********************************************************************************/

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/*-********************************************************************************
* Method: didFinishLaunchingWithOptions
* Description: didFinishLaunchingWithOptions
* Parameter:
* Return Data:
***********************************************************************************/
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ViewController *mainView = [[ViewController alloc] init];
    UINavigationController *mianNav = [[UINavigationController alloc] initWithRootViewController:mainView];
    self.window.rootViewController = mianNav;
    
    return YES;
}


/*-********************************************************************************
* Method: applicationWillResignActive
* Description: applicationWillResignActive
* Parameter:
* Return Data:
***********************************************************************************/
- (void)applicationWillResignActive:(UIApplication *)application {
}


/*-********************************************************************************
* Method: applicationDidEnterBackground
* Description: applicationDidEnterBackground
* Parameter:
* Return Data:
***********************************************************************************/
- (void)applicationDidEnterBackground:(UIApplication *)application {
}


/*-********************************************************************************
* Method: applicationWillEnterForeground
* Description: applicationWillEnterForeground
* Parameter:
* Return Data:
***********************************************************************************/
- (void)applicationWillEnterForeground:(UIApplication *)application {
}


/*-********************************************************************************
* Method: applicationDidBecomeActive
* Description: applicationDidBecomeActive
* Parameter:
* Return Data:
***********************************************************************************/
- (void)applicationDidBecomeActive:(UIApplication *)application {
}


/*-********************************************************************************
* Method: applicationWillTerminate
* Description: applicationWillTerminate
* Parameter:
* Return Data:
***********************************************************************************/
- (void)applicationWillTerminate:(UIApplication *)application {
}


@end
