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
@synthesize bt_upData;




@synthesize ver,vDelegate;
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
    
[self versionCheck];
    self.title = @"Settings";
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    
    
    
    
    [self setBt_upApp:nil];
    [self setBt_upData:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)bt_upData:(id)sender {
    
    /*
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
        
        
        [self.viewDelegate flushdb];
        
        //sectionedListContent = nil;
        //filteredTableData = nil;
        
        [self.viewDelegate getWebserviceData];
        
      //  [self.viewDelegate.tableview reloadData];

}*/
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
@end

