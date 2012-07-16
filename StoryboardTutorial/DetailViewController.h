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

@interface DetailViewController : UIViewController <UIAlertViewDelegate,MFMailComposeViewControllerDelegate, ABNewPersonViewControllerDelegate> {
    NSString *state;
    NSString *capital;
    NSString *phone;
    NSString *mobil;
    NSString *email;
    NSString *name;
    NSString *location;
    NSString *superior;
    NSString *emp_no;
    NSString *init;
    NSString * business_area_name;
   
    
    IBOutlet UILabel *lb_name;
    IBOutlet UILabel *lb_phone;
    IBOutlet UILabel *lb_mobil;
    
    
    
    
    
}
- (IBAction)bt_addcontact:(id)sender;

- (IBAction)bt_sendmail:(id)sender;
- (IBAction)bt_call:(id)sender;
- (IBAction)bt_sendmsg:(id)sender;

@property(nonatomic, retain) IBOutlet UIButton *email_bt;
@property (nonatomic, retain)NSString *phone, *mobil, *email, *name, *location, *superior, *emp_no, *init, *business_area_name;
@property (nonatomic, retain)IBOutlet UILabel *lb_name, *lb_phone, *lb_mobil;
@end
