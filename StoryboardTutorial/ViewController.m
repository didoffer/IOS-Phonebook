//
//  ViewController.m
//  StoryboardTutorial
//
//  Created by Kurry Tran on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "DbDataController.h"
#import "Contacts.h"

@interface ViewController() 
-(void) showCurrentDepth;
@end

@implementation ViewController


@synthesize dcDelegate,contactList,contactNamesArray,filteredTableDate,searchBar,isFiltered;

NSURLConnection *theConnection;
NSURLConnection *myConnection;
NSMutableData *receivedData;
NSString *nextContact;
NSString* xml;
NSString *dump;


//Request data from url connection
- (void)getData
{
    receivedData = [[NSMutableData alloc] init];
    
    NSURL *myURL = [NSURL URLWithString:@"http://midvm1.terma.com/kbni2/PubsService.svc/employees"];
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
    
    theConnection = [[NSURLConnection alloc] initWithRequest:myRequest delegate:self];
    
    if (theConnection)
        receivedData = [NSMutableData data];
    else
    {}
}

- (void)flushdb
{
    //Truncate database
    [self.dcDelegate flush_contacts_db];
}

//For every employee in contactlist addobjects to tableview
- (void)getContactsFromDB
{
    
    NSLog(@"I was here contact...");
    contactList = [[NSMutableArray alloc]init];
    contactList = [self.dcDelegate getAll:self];
    
    NSLog(@"size: %u", [contactList count]);
    
    //Initialize Arrays
    contactNamesArray      = [[NSMutableArray alloc] init];
    contactNamesArrayEXTERNAL_DISPLAY_NAME = [[NSMutableArray alloc] init];
    contactNamesArrayINIT = [[NSMutableArray alloc] init];
    contactNamesArrayEMP_NO = [[NSMutableArray alloc] init]; 
    contactNamesArrayEMAIL = [[NSMutableArray alloc] init];
    contactNamesArrayBUSINESSAREA_NAME = [[NSMutableArray alloc] init];
    contactNamesArrayPHONE = [[NSMutableArray alloc] init];
    contactNamesArrayMOBIL = [[NSMutableArray alloc] init];
    contactNamesArraySUPERIOR = [[NSMutableArray alloc] init];
    contactNamesArrayLOCATION = [[NSMutableArray alloc] init];
    
    //NSMutableArray *contactNamesArray =  [[NSMutableArray alloc] init];
    
    //Loop through contactlist after contacts and add info to the arrays
    for (Contacts *contact in contactList)
    {
        
        //NSLog(@"EXTERNAL_DISPLAY_NAME: %@, INIT: %@, EMP_NO: %@, EMAIL: %@, BUSINESSAREA_NAME: %@, PHONE: %@, MOBIL: %@, SUPERIOR: %@, LOCATION: %@", contact.EXTERNAL_DISPLAY_NAME, contact.INIT, contact.EMP_NO, contact.EMAIL, contact.BUSINESSAREA_NAME, contact.PHONE, contact.MOBIL, contact.SUPERIOR, contact.LOCATION);
        
        nextContact = [NSString stringWithFormat:@"%@", contact.EXTERNAL_DISPLAY_NAME];
        
        NSLog(@"Added: %@", nextContact);
        
        [contactNamesArray addObject:nextContact];
        [contactNamesArrayEXTERNAL_DISPLAY_NAME addObject:contact.EXTERNAL_DISPLAY_NAME];
        [contactNamesArrayINIT addObject:contact.INIT];
        [contactNamesArrayEMP_NO addObject:contact.EMP_NO];
        [contactNamesArrayEMAIL addObject:contact.EMAIL];
        [contactNamesArrayBUSINESSAREA_NAME addObject:contact.BUSINESSAREA_NAME];
        [contactNamesArrayPHONE addObject:contact.PHONE];
        [contactNamesArrayMOBIL addObject:contact.MOBIL];
        [contactNamesArraySUPERIOR addObject:contact.SUPERIOR];
        [contactNamesArrayLOCATION addObject:contact.LOCATION];
       
    }
    
    // If Array is empty, then insert "Dummy"
    if ([contactNamesArray count] < 1)
    {
        [contactNamesArray addObject:@"No contacts"];
        [contactNamesArrayEMAIL addObject:@""];
        [contactNamesArrayINIT addObject:@""];
        [contactNamesArrayEMP_NO addObject:@""];
        [contactNamesArrayPHONE addObject:@""];
        [contactNamesArrayMOBIL addObject:@""];
        [contactNamesArraySUPERIOR addObject:@""];
        [contactNamesArrayLOCATION addObject:@""];
        [contactNamesArrayBUSINESSAREA_NAME addObject:@""];
    }
    NSLog(@"count: %u", [contactNamesArray count]);
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //NSLog(@"data: %@", dump);
    [receivedData setLength:0];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
    //NSLog(@"Added: %@", receivedData);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}
// if it get connection to the url it starts parsing xml (try the NSlog further down the function to see the parsed xml data)
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (theConnection) {
        xml = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        xmlParser = [[NSXMLParser alloc] initWithData:[xml dataUsingEncoding:NSUTF8StringEncoding]];
        [xmlParser setDelegate:self];
        [xmlParser setShouldProcessNamespaces:NO];
        [xmlParser setShouldReportNamespacePrefixes:NO];
        [xmlParser setShouldResolveExternalEntities:NO];
        [xmlParser parse];
        NSLog(@" here is the data: %@", xml);
    }
    
}
-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    
    depth = 0;
    currentElement = nil;
   
    
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Error: %@", [parseError localizedDescription]);
}




-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    currentElement = [elementName copy];
    
    if ([currentElement isEqualToString:@"Employee"]) {
        ++depth;
        [self showCurrentDepth];
    }
    else if ([currentElement isEqualToString:@"EMP_NO"]) {
        EMP_NO = [[NSMutableString alloc]init];
    }
    else if ([currentElement isEqualToString:@"INIT"]) {
        INIT = [[NSMutableString alloc]init];
    }
    else if ([currentElement isEqualToString:@"EMAIL"]) {
        EMAIL = [[NSMutableString alloc]init];
    }
    else if ([currentElement isEqualToString:@"BUSINESSAREA_NAME"]) {
        BUSINESSAREA_NAME = [[NSMutableString alloc]init];
    }
    else if ([currentElement isEqualToString:@"PHONE"]) {
        PHONE = [[NSMutableString alloc]init];
    }
    else if ([currentElement isEqualToString:@"MOBIL"]) {
        MOBIL = [[NSMutableString alloc]init];
    }
    else if ([currentElement isEqualToString:@"SUPERIOR"]) {
        SUPERIOR = [[NSMutableString alloc]init];
    }
    else if ([currentElement isEqualToString:@"LOCATION"]) {
        LOCATION = [[NSMutableString alloc]init];
    }
    else if ([currentElement isEqualToString:@"EXTERNAL_DISPLAY_NAME"]) {
        EXTERNAL_DISPLAY_NAME = [[NSMutableString alloc]init];
    }

}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"Employee"]) {
        --depth;
        [self showCurrentDepth];
        NSLog(@"test  %@ %@ %@ %@", EXTERNAL_DISPLAY_NAME, INIT, PHONE, MOBIL);
        //[self showCurrentDepth];
        [self.dcDelegate insert_into_contacts_db:EXTERNAL_DISPLAY_NAME:INIT:EMP_NO:EMAIL:BUSINESSAREA_NAME:PHONE:MOBIL:SUPERIOR:LOCATION];
        //currentElement =nil;
        //[self.dcDelegate flush_contacts_db];
    }
       
}
// takes the xml apart for every current element to get individual data
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    if ([currentElement isEqualToString:@"EMP_NO"]) 
        [EMP_NO appendString:string];
    if ([currentElement isEqualToString:@"INIT"]) 
        [INIT appendString:string];
    if ([currentElement isEqualToString:@"EMAIL"]) 
        [EMAIL appendString:string];
    if ([currentElement isEqualToString:@"BUSINESSAREA_NAME"]) 
        [BUSINESSAREA_NAME appendString:string];
    if ([currentElement isEqualToString:@"PHONE"]) 
        [PHONE appendString:string];
    if ([currentElement isEqualToString:@"MOBIL"]) 
        [MOBIL appendString:string];
    if ([currentElement isEqualToString:@"SUPERIOR"]) 
        [SUPERIOR appendString:string];
    if ([currentElement isEqualToString:@"LOCATION"]) 
        [LOCATION appendString:string];
    if ([currentElement isEqualToString:@"EXTERNAL_DISPLAY_NAME"]) 
        [EXTERNAL_DISPLAY_NAME appendString:string];
    
    //NSLog(@" here is the contact: %@", EXTERNAL_DISPLAY_NAME);
    //NSLog(@" here is the contact: %@", LOCATION);
    
    
}
-(void)showCurrentDepth{
    //NSLog(@"current %@", depth);
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{

       
}


-(void) progressSpinner{
    
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    
	[self.navigationController.view addSubview:HUD];
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
    
    HUD.labelText = @"Loading";
	
	// Show the HUD while the provided method executes in a new thread
	[HUD showWhileExecuting:@selector(getContactsFromDB) onTarget:self withObject:nil animated:YES];
    
    //[self.tableView reloadData];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self flushdb];
    [self progressSpinner];
     self.dcDelegate = [[DbDataController alloc] init];
    [self getData];
    //[self getContactsFromDB];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [super viewDidLoad];
        
	// Do any additional setup after loading the view, typically from a nib.
    //[self. selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return 1;
   	return [contactList count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [contactList count];
    

    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return [contactNamesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    //}
    
    Contacts *contact;
        
        contact = [contactList objectAtIndex:indexPath.row];
    
        // Configure the cell...
    
    //---------- CELL BACKGROUND IMAGE -----------------------------
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
    
    UIImage *image = [UIImage imageNamed:@"LightGrey.png"];
    
    imageView.image = image;
    
    cell.backgroundView = imageView;
    
    [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    
    [[cell detailTextLabel] setBackgroundColor:[UIColor clearColor]];
   
    cell.textLabel.text = contact.EXTERNAL_DISPLAY_NAME;
    
    //subtitle
    NSString *subtitle = [contactNamesArrayINIT objectAtIndex:indexPath.row];
    
    cell.detailTextLabel.text = subtitle ;

    //Arrow 
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
// parsing data to detailview controller when employee in the tableview is selected
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    detail.email = [contactNamesArrayEMAIL objectAtIndex:indexPath.row];
    detail.phone = [contactNamesArrayPHONE objectAtIndex:indexPath.row];
    detail.mobil = [contactNamesArrayMOBIL objectAtIndex:indexPath.row];
    detail.name = [contactNamesArrayEXTERNAL_DISPLAY_NAME objectAtIndex:indexPath.row];
    detail.location = [contactNamesArrayLOCATION objectAtIndex:indexPath.row];
    detail.superior = [contactNamesArraySUPERIOR objectAtIndex:indexPath.row];
    detail.emp_no = [contactNamesArrayEMP_NO objectAtIndex:indexPath.row];
    detail.init = [contactNamesArrayINIT objectAtIndex:indexPath.row];
    detail.business_area_name = [contactNamesArrayBUSINESSAREA_NAME objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detail animated:YES];
    
}

//----------------------TABLEVIEWCELL HEIGHT -------------------------------------------

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	
	
	
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	[tempArray addObject:@"A"];
	[tempArray addObject:@"B"];
	[tempArray addObject:@"C"];
	[tempArray addObject:@"D"];
	[tempArray addObject:@"E"];
	[tempArray addObject:@"F"];
	[tempArray addObject:@"G"];
	[tempArray addObject:@"H"];
	[tempArray addObject:@"I"];
	[tempArray addObject:@"J"];
	[tempArray addObject:@"K"];
	[tempArray addObject:@"L"];
	[tempArray addObject:@"M"];
	[tempArray addObject:@"N"];
	[tempArray addObject:@"O"];
	[tempArray addObject:@"P"];
	[tempArray addObject:@"Q"];
	[tempArray addObject:@"R"];
	[tempArray addObject:@"S"];
	[tempArray addObject:@"T"];
	[tempArray addObject:@"U"];
	[tempArray addObject:@"V"];
	[tempArray addObject:@"X"];
	[tempArray addObject:@"Y"];
	[tempArray addObject:@"Z"];
	[tempArray addObject:@"Æ"];
    [tempArray addObject:@"Ø"];
    [tempArray addObject:@"Å"];
    
	return tempArray;
}


- (void)viewDidUnload
{
   
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
