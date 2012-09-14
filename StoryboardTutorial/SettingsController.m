//
//  SettingsController.m
//  StoryboardTutorial
//
//  Created by MacTerma on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsController.h"
#import "Reachability.h"

@interface SettingsController ()

@end

@implementation SettingsController
@synthesize bt_test;
@synthesize bt_upApp;
@synthesize bt_upData,viewDelegate;




@synthesize vDelegate;
NSString *updates;
-(void)versionCheck{
    updates = [VersionController update];
    NSLog(@"SKAL JEG OPDATERE %@",updates);
    if (updates ==@"YES") {
        [bt_upApp setTitle:@"New Update" forState:UIControlStateNormal];
    }
    else {
        [bt_upApp setTitle:@"No updates available" forState:UIControlStateNormal];
    }


}

- (void)viewDidLoad
{
    self.viewDelegate =[[ViewController alloc]init];
    
    
[self versionCheck];
    self.title = @"Settings";
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    
    
    
    
    [self setBt_upApp:nil];
    [self setBt_upData:nil];
    [self setBt_test:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)bt_upData:(id)sender {
        
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    
    [reach startNotifier];
    NetworkStatus status =[reach currentReachabilityStatus];
    
    
    if (status == NotReachable) {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Nerwork error!"
                                                          message:@"No network connection"
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
        [message show];
    }
    
    
    
    else if (status == ReachableViaWWAN) {
        UIAlertView *alerview = [[UIAlertView alloc] initWithTitle:@"WARNING!"
                                                           message:@"You connected via 3G. Do you want to update anyway?"
                                                          delegate:self
                                                 cancelButtonTitle:@"No"
                                                 otherButtonTitles:@"Yes", nil];
        [alerview show];}
    
    else if (status == ReachableViaWiFi) {
        
        //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:SettingsController. animated:YES];
        //hud.labelText = @"Loading...";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Updating" 
                                                        message:@"Data updating" 
                                                       delegate:nil 
                                              cancelButtonTitle:nil 
                                              otherButtonTitles: nil];
        [alert show];

        
        [self.viewDelegate flushdb];    
        
 
        [self.viewDelegate getWebserviceData];
        
        
        [alert dismissWithClickedButtonIndex:0 animated:TRUE];
               
        
         
       }
}
- (IBAction)bt_upApp:(id)sender {
    if (updates ==@"YES") {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update" 
                                                        message:@"App updated" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        [alert show];
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No updates" 
                                                        message:@"No new updates is available" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        [alert show];
        
    }
}

- (IBAction)bt_test:(id)sender {
      [self.viewDelegate refreshDataTable];
}
@end

