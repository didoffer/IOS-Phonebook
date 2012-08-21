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
@synthesize bt_mobil,bt_phone;

@synthesize lb_name, lb_LOCATION, lb_BUSINESSAREA_NAME,emp;

NSData* imageData;

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



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //What data to show in the labels
    lb_name.text = emp.EXTERNAL_DISPLAY_NAME;
    lb_BUSINESSAREA_NAME.text = emp.BUSINESSAREA_NAME;
    lb_LOCATION.text = emp.LOCATION;
    [self checkPhoneNumbers];
    [self progressSpinner1];
    //[self loadImage];
    
      
    
}
      
     
- (void)loadImage {
    NSString *path =[NSString stringWithFormat:@"http://intranet.terma.com/phonebook/images/employee_images/thumbnail/%@",emp.INIT, @"-%@",emp.EMP_NO,@"-01.jpg"]; 
    path = [path stringByAppendingFormat:@"-%@", emp.EMP_NO];
    path =[path stringByAppendingFormat:@"-01.jpg"];
    NSLog(@"se%@", path);
         imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:path]];
   
         UIImage* image = [[UIImage alloc] initWithData:imageData];
         
         [self performSelectorOnMainThread:@selector(displayImage:) withObject:image waitUntilDone:NO];
    
    
     }
     
     - (void)displayImage:(UIImage *)image {
         [imageView setImage:image];
     }

- (void)viewDidUnload
{
   
    lb_name = nil;
    lb_BUSINESSAREA_NAME = nil;
    lb_LOCATION = nil;
    [self setBt_mobil:nil];
    [self setBt_phone:nil];
    [self setBt_mobil:nil];
    lb_BUSINESSAREA_NAME = nil;
    lb_LOCATION = nil;
    imageView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) progressSpinner1{
    
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    
	[self.navigationController.view addSubview:HUD];
    
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
    
    HUD.labelText = @"Loading Contactlist";
    
	// Show the HUD while the provided method executes in a new thread
	[HUD showWhileExecuting:@selector(loadImage) onTarget:self withObject:nil animated:YES];
  
}

-(void) checkPhoneNumbers
{
    if (emp.PHONE.length < 1 ) {
        [bt_phone setTitle:@"No phone number" forState:UIControlStateNormal];
    }
    else {
        [bt_phone setTitle:emp.PHONE forState:UIControlStateNormal];
    }
    
    if (emp.MOBIL.length < 1 ) {
        [bt_mobil setTitle:@"No mobile number" forState:UIControlStateNormal];
    }
    else {
        [bt_mobil setTitle:emp.MOBIL forState:UIControlStateNormal];
    }


}
// Open mail cient which runs when user tabs the send mail button
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

// returns in a log message when the user chooses to either cancel, save, send or the mail for some reason cant be send
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
    //close the mail client
    [self dismissModalViewControllerAnimated:YES];
}


// add contact to the internal phonebook 
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
    
    //Adding picture to contact
    CFDataRef dr =CFDataCreate(NULL, [imageData bytes], [imageData length]);
    ABPersonSetImageData(person, dr, nil);
    
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

// call button which promts you which number to call, phone or mobil
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

//button action add contact
- (IBAction)bt_addcontact:(id)sender {
    [self addContact];
}
//button action send mail
- (IBAction)bt_sendmail:(id)sender {
    [self goToMailApp];
    }
//button action make phone call
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
//button action send text message
- (IBAction)bt_sendmsg:(id)sender {
    if (emp.MOBIL.length < 1) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No mobile number"
                                                          message:@"You can't send a text message to a contact with no mobile number"
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", emp.MOBIL]]];
        NSLog(@"Message send to %@", emp.MOBIL);
    }
    
}
//button action make phone call to local number
- (IBAction)bt_phone:(id)sender {
    NSLog(@"Calling %@", emp.PHONE);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", emp.PHONE]]];
}
//button action make phone call to mobile number
- (IBAction)bt_mobil:(id)sender {
    NSLog(@"Calling %@",emp.MOBIL);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", emp.MOBIL]]];
}
@end
