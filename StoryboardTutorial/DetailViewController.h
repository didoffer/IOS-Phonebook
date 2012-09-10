//
//  DetailViewController.h
//  StoryboardTutorial
//
//  Created by Kurry Tran on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "AddressBook/AddressBook.h"
#import "AddressBookUI/AddressBookUI.h"
#import "Contacts.h"
#import "MBProgressHUD.h"
@interface DetailViewController : UIViewController <UIAlertViewDelegate,MFMailComposeViewControllerDelegate, ABNewPersonViewControllerDelegate> {
    
    MBProgressHUD *HUD;
    // labels
    IBOutlet UILabel *lb_name;
    
    IBOutlet UILabel *lb_BUSINESSAREA_NAME;
    
    IBOutlet UILabel *lb_LOCATION;
    
    IBOutlet UIImageView *imageView;
    
    
    
    
}
//actions for the buttons
- (IBAction)bt_addcontact:(id)sender;
- (IBAction)bt_sendmail:(id)sender;
- (IBAction)bt_sendmsg:(id)sender;
- (IBAction)bt_phone:(id)sender;
- (IBAction)bt_mobil:(id)sender;


@property (weak, nonatomic) IBOutlet UIImageView *myimageView;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) Contacts* emp;
@property (weak, nonatomic) IBOutlet UIButton *bt_mobil;
@property (weak, nonatomic) IBOutlet UIButton *bt_phone;
@property (nonatomic, retain)IBOutlet UILabel *lb_name, *lb_BUSINESSAREA_NAME, *lb_LOCATION;
@end
