//
//  SettingsController.h
//  StoryboardTutorial
//
//  Created by Kristoffer Nielsen on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "VersionControllerDelegate.h"
#import "MBProgressHUD.h"
#import "SettingsControllerDelegate.h"



@interface SettingsController : UIViewController<MBProgressHUDDelegate>{
   
 MBProgressHUD *HUUD;
    SettingsController *settingsController;
}
- (IBAction)bt_upData:(id)sender;
- (IBAction)bt_upApp:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lb_appVersion;
@property (weak, nonatomic) IBOutlet UILabel *lb_newestAppVersion;
@property (weak, nonatomic) IBOutlet UILabel *lb_lastUpdate;


@property (weak, nonatomic) IBOutlet UIButton *bt_upApp;
@property (weak, nonatomic) IBOutlet UIButton *bt_upData;
@property (nonatomic, strong) id <VersionControllerDelegate> vDelegate;






//@property (strong, nonatomic) VersionController* ver;




@property (nonatomic, strong) id <ViewControllerDelegate> viewDelegate;
@property (nonatomic, strong) id <DataControllerDelegate> dcDelegate;
+(NSString*)btPressed;
-(void)dataCheck;
@end
