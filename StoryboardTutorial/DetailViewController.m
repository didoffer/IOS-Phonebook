//
//  DetailViewController.m
//  StoryboardTutorial
//
//  Created by Kurry Tran on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "Contacts.h"
#import "ViewController.h"

@implementation DetailViewController
@synthesize lb_name, lb_mobil, lb_phone, email_bt,emp;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lb_name.text = emp.EXTERNAL_DISPLAY_NAME;
    lb_phone.text = emp.PHONE;
    lb_mobil.text = emp.MOBIL;
    
    //change text of a button
    //[email_bt setTitle:email forState:UIControlStateNormal];
    
    
}


- (void)viewDidUnload
{
   
   
    
    lb_name = nil;
    lb_phone = nil;
    lb_mobil = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)goToMailApp
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@""];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:emp.EMAIL, nil];
        [mailer setToRecipients:toRecipients];
        
        //UIImage *myImage = [UIImage imageNamed:@"mercantec.jpg"];
        //NSData *imageData = UIImagePNGRepresentation(myImage);
        //[mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"mercantec"];	
        
        NSString *emailBody = @"";
        [mailer setMessageBody:emailBody isHTML:NO];
        
        // only for iPad
        //mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        
        [self presentModalViewController:mailer animated:YES];
        
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" 
                                                        message:@"Your device doesn't support the composer sheet" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        [alert show];
        
    }
    
    }

- (void)addContact {  
    // Creating new entry  
    ABAddressBookRef addressBook = ABAddressBookCreate();  
    ABRecordRef person = ABPersonCreate();  
    
    // Setting basic properties  
    ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge_retained CFStringRef)emp.EXTERNAL_DISPLAY_NAME, nil);  
    ABRecordSetValue(person, kABPersonLastNameProperty,(__bridge_retained CFStringRef) @"", nil);  
    ABRecordSetValue(person, kABPersonJobTitleProperty,(__bridge_retained CFStringRef) @"", nil);  
    ABRecordSetValue(person, kABPersonDepartmentProperty,(__bridge_retained CFStringRef) @"", nil);  
    ABRecordSetValue(person, kABPersonOrganizationProperty, (__bridge_retained CFStringRef)emp.BUSINESSAREA_NAME, nil);  
    ABRecordSetValue(person, kABPersonNoteProperty, @"", nil);  
    
    
    // Adding phone numbers  
    ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);  
    ABMultiValueAddValueAndLabel(phoneNumberMultiValue,(__bridge_retained CFStringRef)emp.PHONE ,(__bridge_retained CFStringRef)@"Terma", NULL);  
    ABMultiValueAddValueAndLabel(phoneNumberMultiValue,(__bridge_retained CFStringRef)emp.MOBIL ,(__bridge_retained CFStringRef)@"Terma mobil", NULL);  
    ABMultiValueAddValueAndLabel(phoneNumberMultiValue,(__bridge_retained CFStringRef)@"+45 23232323" ,(__bridge_retained CFStringRef)@"Private", NULL);  
    ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);  
    CFRelease(phoneNumberMultiValue);  
    
    /* Adding url  
    ABMutableMultiValueRef urlMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);  
    ABMultiValueAddValueAndLabel(urlMultiValue, @"http://www.fuerteint.com", kABPersonHomePageLabel, NULL);  
    ABRecordSetValue(person, kABPersonURLProperty, urlMultiValue, nil);  
    CFRelease(urlMultiValue);*/  
    
    // Adding emails  
    ABMutableMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);  
    ABMultiValueAddValueAndLabel(emailMultiValue,(__bridge_retained CFStringRef)emp.EMAIL, (CFStringRef)@"Terma", NULL);  
    ABMultiValueAddValueAndLabel(emailMultiValue,(__bridge_retained CFStringRef)@"test@gmail.com", (CFStringRef)@"Private", NULL);  
    ABRecordSetValue(person, kABPersonURLProperty, emailMultiValue, nil);  
    CFRelease(emailMultiValue);  
    
    /* Adding address  
    ABMutableMultiValueRef addressMultipleValue = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);  
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];  
    [addressDictionary setObject:@"8-15 Dereham Place" forKey:(NSString *)kABPersonAddressStreetKey];  
    [addressDictionary setObject:@"London" forKey:(NSString *)kABPersonAddressCityKey];  
    [addressDictionary setObject:@"EC2A 3HJ" forKey:(NSString *)kABPersonAddressZIPKey];  
    [addressDictionary setObject:@"United Kingdom" forKey:(NSString *)kABPersonAddressCountryKey];  
    [addressDictionary setObject:@"gb" forKey:(NSString *)kABPersonAddressCountryCodeKey];  
    ABMultiValueAddValueAndLabel(addressMultipleValue, addressDictionary, kABHomeLabel, NULL);  
      
    ABRecordSetValue(person, kABPersonAddressProperty, addressMultipleValue, nil);  
    CFRelease(addressMultipleValue);  */
    
    // Adding person to the address book  
    ABAddressBookAddRecord(addressBook, person, nil);  
    CFRelease(addressBook);  
    
    // Creating view controller for a new contact  
    ABNewPersonViewController *c = [[ABNewPersonViewController alloc] init];  
    [c setNewPersonViewDelegate:self];  
    [c setDisplayedPerson:person];  
    CFRelease(person);  
    [self.navigationController pushViewController:c animated:YES];  
     
}  
//If user wants to save the contact 
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person {  
    if (person) {  
        ABAddressBookRef addressBook = ABAddressBookCreate();  
        ABAddressBookAddRecord(addressBook, person, nil);  
        ABAddressBookSave(addressBook, nil);  
        CFRelease(addressBook);  
    }  
    [self.navigationController popViewControllerAnimated:YES];  
}  

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Local"])
    {
        NSLog(@"Calling %@", emp.PHONE);
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", emp.PHONE]]];
    }
    else if([title isEqualToString:@"Mobile"])
    {
        NSLog(@"Calling %@",emp.MOBIL);
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", emp.MOBIL]]];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void) mailComposeController:(MFMailComposeViewController*) controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed");
            break;
            
            
        default:
             NSLog(@"Mail not sent");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)bt_addcontact:(id)sender {
    [self addContact];
}

- (IBAction)bt_sendmail:(id)sender {
    [self goToMailApp];
    }

- (IBAction)bt_call:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Call!"
                                                      message:@"Choose which number to call"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:nil];
    
    [message addButtonWithTitle:@"Local"];
    [message addButtonWithTitle:@"Mobile"];
    
    [message show];
   
}

- (IBAction)bt_sendmsg:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", emp.MOBIL]]];
}
@end
