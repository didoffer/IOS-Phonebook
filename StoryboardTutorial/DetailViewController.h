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

@interface DetailViewController : UIViewController <UIAlertViewDelegate,MFMailComposeViewControllerDelegate, ABNewPersonViewControllerDelegate> {
    
   
    // labels
    IBOutlet UILabel *lb_name;
    IBOutlet UILabel *lb_phone;
    IBOutlet UILabel *lb_mobil;
    
    
    
    
    
}
//actions for the buttons
- (IBAction)bt_addcontact:(id)sender;
- (IBAction)bt_sendmail:(id)sender;
- (IBAction)bt_call:(id)sender;
- (IBAction)bt_sendmsg:(id)sender;

@property(nonatomic, retain) IBOutlet UIButton *email_bt;
@property (strong, nonatomic) Contacts* emp;
@property (nonatomic, retain)IBOutlet UILabel *lb_name, *lb_phone, *lb_mobil;
@end
