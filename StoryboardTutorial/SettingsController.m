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
@synthesize bt_upApp;
@synthesize bt_upData,viewDelegate;
@synthesize vDelegate,dcDelegate;

NSString *updates;
static NSString* btPress = nil;

//If newere version exists change button title to "update", if not "no updates"
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
    [super viewDidLoad];
    self.dcDelegate = [[DbDataController alloc] init];
    self.viewDelegate =[[ViewController alloc]init];
    [self versionCheck];
    self.title = @"Settings";
    
    
  
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setBt_upApp:nil];
    [self setBt_upData:nil];
   
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//3G alertview where you can choose to update or not
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"No"])
    {
        //Cancel
    }
    else if([title isEqualToString:@"Yes"])
    {
         [self.dcDelegate flush_contacts_db];
        btPress =@"btpressed";
       //Redirect to viewcontroller view
        ViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        
        [self.navigationController pushViewController:view animated:YES];
        
    }
    
}

// Update data button action
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
        
        // if network is reachable flush db and redirects to ViewController view for data update
        [self.dcDelegate flush_contacts_db];
        btPress =@"btpressed";
            
        ViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        
        [self.navigationController pushViewController:view animated:YES];
              
       }
}
//string that returns the value of btPress so the value can be used in another class
+(NSString*)btPressed{
    return btPress;
}


// Update App button action
- (IBAction)bt_upApp:(id)sender {
    //Check if newere version exist(ref.VersionController.m). If so open webpage with download link
    if (updates ==@"YES") {
        
        NSURL *url = [NSURL URLWithString:@"http://midvm1.terma.com/kbni2/phonebook/main.html"];
        
        if (![[UIApplication sharedApplication] openURL:url])
            
            NSLog(@"%@%@",@"Failed to open url:",[url description]);
        
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


@end

