//
//  SettingsController.h
//  StoryboardTutorial
//
//  Created by MacTerma on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "VersionControllerDelegate.h"
#import "MBProgressHUD.h"


@interface SettingsController : UIViewController{
    
 MBProgressHUD *HUD;
}
- (IBAction)bt_upData:(id)sender;
- (IBAction)bt_upApp:(id)sender;
- (IBAction)bt_test:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *bt_upApp;
@property (weak, nonatomic) IBOutlet UIButton *bt_upData;
@property (weak, nonatomic) IBOutlet UIButton *bt_test;





//@property (strong, nonatomic) VersionController* ver;



@property (nonatomic, strong) id <VersionControllerDelegate> vDelegate;
@property (nonatomic, strong) id <ViewControllerDelegate> viewDelegate;


@end
