//
//  SettingsController.m
//  StoryboardTutorial
//
//  Created by Kristoffer Nielsen on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsController.h"
#import "Reachability.h"

@interface SettingsController ()

@end

@implementation SettingsController
@synthesize bt_upApp;
@synthesize bt_upData,viewDelegate;
@synthesize vDelegate,dcDelegate,lb_appVersion;

NSString *updates;
NSString *dataUpdates;
NSString *version;
NSString *newestVersion;
NSString *dateString;
static NSString* btPress = nil;

//recieves from a methode in versionController a respons if newere data exsist. If so change the button text so the user know new data is available
-(void)dataCheck{
    
    dataUpdates =[VersionController dataupdate];
    
    NSLog(@"Er der nye data? %@", dataUpdates);
    if (dataUpdates ==@"YES") {
        [bt_upData setTitle:@"Update phonebook" forState:UIControlStateNormal];
    }
    else {
        [bt_upData setTitle:@"Your phonebook is up to date" forState:UIControlStateNormal];
    }

}

//If newere app version exists change button title to "update to version", if not "Your software is up to date"
-(void)versionCheck{
    version =[VersionController showVersion];
    updates = [VersionController update];
    newestVersion =[VersionController ShowNewestVersion];
    
    NSLog(@"SKAL JEG OPDATERE App'en %@",updates);
    if (updates ==@"YES") {
        [bt_upApp setTitle:@"Update to version" forState:UIControlStateNormal];
        _lb_newestAppVersion.text = newestVersion;
        
    }
    else {
        [bt_upApp setTitle:@"Your software is up to date" forState:UIControlStateNormal];
    }


}
//Get the date and time
-(void)getSystemDate{
    
    // get the current date
    NSDate *date = [NSDate date];
    
    // format it
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // convert it to a string
    dateString = [dateFormat stringFromDate:date];
    
    }
//load the date and time from NSUserDefault and display it on a label 
-(void)showDate{
    [self getDate];
    _lb_lastUpdate.text = dateString;
}
//Save the date and time into NSUserDefault 
-(void) saveDate{
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    [data setValue:dateString forKey:@"Date"];
    NSLog(@"saved date: %@",dateString);
    [data synchronize];
    NSLog(@"date saved");
}
//load data and time from NSUserDefault
-(void) getDate{
    NSUserDefaults *data =[NSUserDefaults standardUserDefaults];
    dateString = [data stringForKey:@"Date"];
    NSString *dataString =[NSString stringWithFormat:@"%@", dateString];
    NSLog(@"Har hentet dato værdien fra NSUserDefault %@", dataString);
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dcDelegate = [[DbDataController alloc] init];
    self.viewDelegate =[[ViewController alloc]init];
    [self versionCheck];
    //[self dataCheck];
    [self showDate];
    self.title = @"Settings";
    
    //Get app version and write it to label
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    lb_appVersion.text = version;
    
    
  
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self dataCheck];
    self.vDelegate =[[VersionController alloc]init];
    [self.vDelegate getDbDataVersion];
}


- (void)viewDidUnload
{
    [self setLb_appVersion:nil];
    [self setLb_newestAppVersion:nil];
    [self setLb_lastUpdate:nil];
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
        Reachability *netReach = [Reachability reachabilityWithHostname:@"saturn2.terma.com"];
        NetworkStatus netStatus = [netReach currentReachabilityStatus];
        
        //if the app can reach saturn which means you are connected to vpn do the following:
        if (netStatus==ReachableViaWWAN) {
            [self updatefunc];
        }
         else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Nerwork error!"
                                                          message:@"No VPN connection"
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
        [message show];
        
        NSLog(@"kan ikke nå saturn");
    }
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
        
        Reachability *netReach = [Reachability reachabilityWithHostname:@"saturn2.terma.com"];
        NetworkStatus netStatus = [netReach currentReachabilityStatus];
        
        //if the app can reach saturn which means you are connected to vpn do the following:
        if (netStatus==ReachableViaWiFi) {
            NSLog(@"kan nå saturn med wifi");
            [self updatefunc];
            [self getSystemDate];
            [self saveDate];
            }
        else {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Nerwork error!"
                                                              message:@"No VPN connection"
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
            [message show];

            NSLog(@"kan ikke nå saturn");
        }
        
               }
}
-(void) updatefunc{
    // if network is reachable flush db and redirects to ViewController view for data update
    [self.dcDelegate flush_contacts_db];
    btPress =@"btpressed";
    
    
    ViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    [self.navigationController pushViewController:view animated:YES];
    

}

//string that returns the value of btPress so the value can be used in another class
+(NSString*)btPressed{
    return btPress;
}


// Update App button action
- (IBAction)bt_upApp:(id)sender {
    //Check if newere version exist(ref.VersionController.m). If so open webpage with download link
    if (updates ==@"YES") {
        
        NSURL *url = [NSURL URLWithString:@"http://intranet2.terma.com/apps/phonebook.html"];
        
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

