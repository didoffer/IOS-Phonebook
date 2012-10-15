//
//  DetailViewController.m
//  StoryboardTutorial
//
//  Created by Kristoffer Nielsen on 06/03/12.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "Contacts.h"
#import "ViewController.h"

@implementation DetailViewController
@synthesize myimageView;
@synthesize webView;
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
    
    //Display data in the labels
    //crates a string with the initials surrounded in parentheses
    NSString *DISPLAY_INIT = [NSString stringWithFormat:@" (%@)", emp.INIT];
    //adds the DISPLAY_INIT to the EXTERNAL_DISPLAY_NAME 
    lb_name.text = [emp.EXTERNAL_DISPLAY_NAME stringByAppendingString:DISPLAY_INIT];
    lb_BUSINESSAREA_NAME.text = emp.BUSINESSAREA_NAME;
    lb_LOCATION.text = emp.LOCATION;
    lb_TITLE.text =emp.TITLE;
    
    [self checkPhoneNumbers];
    [self progressSpinner1];
    [self webImage];
    self.myimageView.hidden = YES;
  
}
-(void)webImage {
    
    NSString *fullURL = emp.IMAGE_WEB_URL;
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

//if the imageview cant get any imagedata(which means your are not connected to vpn) it displays a image "VPN is required"
- (void)loadImage {
    
    NSString *path =emp.IMAGE_URL; 
    
    NSLog(@"se%@", path);
    imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:path]];
    //NSLog(@"billede data %@",imageData);
    UIImage* image = [[UIImage alloc] initWithData:imageData];
    
    [self performSelectorOnMainThread:@selector(displayImage:) withObject:image waitUntilDone:NO];
    
    if (imageData == NULL) {
        self.webView.hidden = TRUE;
        //self.myimageView.hidden = false;
        //NSLog(@"billede data %@",imageData);
        UIImageView *noContact = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Contact.png"]];
        [self.view addSubview:noContact];
    }
    
}
//display the image
- (void)displayImage:(UIImage *)image {
    [imageView setImage:image];
    
}

- (void)viewDidUnload
{
    lb_BUSINESSAREA_NAME = nil;
    lb_LOCATION = nil;
    imageView = nil;
    lb_name = nil;
    lb_BUSINESSAREA_NAME = nil;
    lb_LOCATION = nil;
    
    [self setBt_mobil:nil];
    [self setBt_phone:nil];
    [self setBt_mobil:nil];
    [self setWebView:nil];
    [self setMyimageView:nil];
    lb_TITLE = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//show progress spinner while loading image
-(void) progressSpinner1{
    
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    
	[self.navigationController.view addSubview:HUD];
    
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = (id)self;
    
    HUD.labelText = @"Loading Contact";
    
	// Show the HUD while the provided method executes in a new thread
	[HUD showWhileExecuting:@selector(loadImage) onTarget:self withObject:nil animated:YES];
    
}

//check if contact has phone number. if so display it on a button for each phone and mobile
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
        
        //-- add picture like logo etc. to the mail text--
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
    ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge_retained CFStringRef)emp.FNAME, nil);  
    ABRecordSetValue(person, kABPersonLastNameProperty,(__bridge_retained CFStringRef) emp.LNAME, nil);  
    ABRecordSetValue(person, kABPersonJobTitleProperty,(__bridge_retained CFStringRef) emp.TITLE, nil);
    ABRecordSetValue(person, kABPersonDepartmentProperty,(__bridge_retained CFStringRef) emp.BUSINESSAREA_NAME, nil);
    ABRecordSetValue(person, kABPersonOrganizationProperty, (__bridge_retained CFStringRef)emp.COMPANY_NAME, nil);
    ABRecordSetValue(person, kABPersonNoteProperty, @"", nil);  
    
    
    // Adding phone numbers  
    ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);  
    ABMultiValueAddValueAndLabel(phoneNumberMultiValue,(__bridge_retained CFStringRef)emp.PHONE ,(__bridge_retained CFStringRef)@"Work", NULL);  
    //ABMultiValueAddValueAndLabel(phoneNumberMultiValue,(__bridge_retained CFStringRef)emp.MOBIL ,(__bridge_retained CFStringRef)@"Terma mobil", NULL);  
    //ABMultiValueAddValueAndLabel(phoneNumberMultiValue,(__bridge_retained CFStringRef)@"" ,(__bridge_retained CFStringRef)@"Private", NULL);  
    ABMultiValueAddValueAndLabel(phoneNumberMultiValue,(__bridge_retained CFStringRef)emp.MOBIL, kABPersonPhoneMobileLabel, NULL);
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
    //ABMultiValueAddValueAndLabel(emailMultiValue,(__bridge_retained CFStringRef)emp.EMAIL, (CFStringRef)@"Terma", NULL);  
    //ABMultiValueAddValueAndLabel(emailMultiValue,(__bridge_retained CFStringRef)@"test@gmail.com", (CFStringRef)@"Private", NULL);  
    ABMultiValueAddValueAndLabel(emailMultiValue,(__bridge_retained CFStringRef)emp.EMAIL, kABWorkLabel, NULL);
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
