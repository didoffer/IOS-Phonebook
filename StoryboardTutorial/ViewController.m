//
//  ViewController.m
//  StoryboardTutorial
//
//  Created by Kristoffer Nielsen on 06/03/12.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "DbDataController.h"
#import "Contacts.h"
#import "Reachability.h"
#import "VersionController.h"
#import "SettingsController.h"




@interface ViewController() 
-(void) showCurrentDepth;

@end

@interface NSArray (SSArrayOfArrays)
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
@end

@implementation NSArray (SSArrayOfArrays)

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
}

@end

@interface NSMutableArray (SSArrayOfArrays)
// If idx is beyond the bounds of the reciever, this method automatically extends the reciever to fit with empty subarrays.
- (void)addObject:(id)anObject toSubarrayAtIndex:(NSUInteger)idx;
@end

@implementation NSMutableArray (SSArrayOfArrays)

- (void)addObject:(id)anObject toSubarrayAtIndex:(NSUInteger)idx
{
    while ([self count] <= idx) {
        [self addObject:[NSMutableArray array]];
    }
    
    [[self objectAtIndex:idx] addObject:anObject];
}

@end

@implementation ViewController


@synthesize dcDelegate,contactList,contactNamesArray,filteredTableData,isFiltered,searchBar, sectionedListContent, WebService,ver,vDelegate,setDelegate;

NSURLConnection *theConnection;
NSURLConnection *myConnection;
NSMutableData *receivedData;
NSString *nextContact;
NSString* xml;
NSString *dump;
UIWindow *window;
NSString *upBtPressed;

//Request data from url connection
- (void)getWebserviceData{
    
    NSLog(@"data startede");
        //Start progress spinner
   window = [[[UIApplication sharedApplication] windows] lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelText = @"Loading...";    
    
        receivedData = [[NSMutableData alloc] init];
        
        NSURL *myURL = [NSURL URLWithString:@"http://intranet2.terma.com/Phonebook/TermaService.svc/employees"];
        
        NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
        
        theConnection = [[NSURLConnection alloc] initWithRequest:myRequest delegate:self];
    
    
    if (theConnection){
        receivedData = [NSMutableData data];}
    else
    {}
    

    
}
//Load data from database. If non exists then start getting data from getWebserviceData
- (void)getData:(UIViewController *)controller;
{    
    [self getContactsFromDB];
   
    NSLog(@"size of databaseData: %u", [contactList count]);
    
    viewController = (ViewController *)controller;
    
    
    
    if ([contactList count] <1 ) {
    
               
        
        [self flushdb];
        
        sectionedListContent = nil;
        filteredTableData = nil;
        
        [self getWebserviceData];
        
        [self.tableView reloadData];
        
    }
    
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //NSLog(@"data: %@", dump);
    [receivedData setLength:0];
    
}
//append received data to data
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
    //NSLog(@"Added: %@", receivedData);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
      UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Nerwork error!"
                                                      message:@"Not connected to VPN"
                                                   delegate:self
                                        cancelButtonTitle:@"OK"
                                      otherButtonTitles: nil];
    [message show];
    //Stop progress spinner
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [MBProgressHUD hideHUDForView:window animated:YES];

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
        [self.vDelegate getWebserviceVersion];
        //NSLog(@" here is the data: %@", xml);
    }
    
    [self getContactsFromDB];
   
   
}



-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    depth = 0;
    currentElement = nil;
}
// xml parse error
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                      message:@"Error downloading content"
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles: nil];
    [message show];

    NSLog(@"Error: %@", [parseError localizedDescription]);
}



// parse through the xml data for every start Employee element with child items
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
    else if ([currentElement isEqualToString:@"FNAME"]) {
        FNAME = [[NSMutableString alloc]init];
    }
    else if ([currentElement isEqualToString:@"LNAME"]) {
        LNAME = [[NSMutableString alloc]init];
    }
    
    else if ([currentElement isEqualToString:@"INIT"]) {
        INIT = [[NSMutableString alloc]init];
    }
    
    else if ([currentElement isEqualToString:@"TITLE"]) {
        TITLE = [[NSMutableString alloc]init];
    }
    else if ([currentElement isEqualToString:@"EMAIL"]) {
        EMAIL = [[NSMutableString alloc]init];
    }
    else if ([currentElement isEqualToString:@"BUSINESSAREA_NAME"]) {
        BUSINESSAREA_NAME = [[NSMutableString alloc]init];
    }
    
    else if ([currentElement isEqualToString:@"COMPANY_NAME"]){
        COMPANY_NAME = [[NSMutableString alloc]init];
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
    else if ([currentElement isEqualToString:@"IMAGE_URL"]) {
        IMAGE_URL = [[NSMutableString alloc]init];
    }
    else if ([currentElement isEqualToString:@"IMAGE_WEB_URL"]) {
        IMAGE_WEB_URL = [[NSMutableString alloc]init];
    }
    
    else if ([currentElement isEqualToString:@"EXTERNAL_DISPLAY_NAME"]) {
        EXTERNAL_DISPLAY_NAME = [[NSMutableString alloc]init];
    }
    
}
// Ends a employee element and insert it into the database
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"Employee"]) {
        --depth;
        [self showCurrentDepth];
        //NSLog(@"test  %@ %@ %@ %@", EXTERNAL_DISPLAY_NAME, INIT, PHONE, MOBIL);
        //Database insert function
        [self.dcDelegate insert_into_contacts_db:EXTERNAL_DISPLAY_NAME:FNAME:LNAME:INIT:EMP_NO:EMAIL:BUSINESSAREA_NAME:PHONE:MOBIL:SUPERIOR:LOCATION:IMAGE_URL:IMAGE_WEB_URL:TITLE:COMPANY_NAME];
        
    }
    
}
// takes the xml apart for every current element to get individual data
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    if ([currentElement isEqualToString:@"EMP_NO"]) 
        [EMP_NO appendString:string];
    if ([currentElement isEqualToString:@"FNAME"]) 
        [FNAME appendString:string];
    if ([currentElement isEqualToString:@"LNAME"]) 
        [LNAME appendString:string];
    if ([currentElement isEqualToString:@"INIT"]) 
        [INIT appendString:string];
    if ([currentElement isEqualToString:@"TITLE"])
        [TITLE appendString:string];
    if ([currentElement isEqualToString:@"EMAIL"]) 
        [EMAIL appendString:string];
    if ([currentElement isEqualToString:@"BUSINESSAREA_NAME"]) 
        [BUSINESSAREA_NAME appendString:string];
    if ([currentElement isEqualToString:@"COMPANY_NAME"])
        [COMPANY_NAME appendString:string];
    if ([currentElement isEqualToString:@"PHONE"])
        [PHONE appendString:string];
    if ([currentElement isEqualToString:@"MOBIL"]) 
        [MOBIL appendString:string];
    if ([currentElement isEqualToString:@"SUPERIOR"]) 
        [SUPERIOR appendString:string];
    if ([currentElement isEqualToString:@"LOCATION"]) 
        [LOCATION appendString:string];
    if ([currentElement isEqualToString:@"IMAGE_URL"]) 
        [IMAGE_URL appendString:string];
    if ([currentElement isEqualToString:@"IMAGE_WEB_URL"]) 
        [IMAGE_WEB_URL appendString:string];
    if ([currentElement isEqualToString:@"EXTERNAL_DISPLAY_NAME"]) 
        [EXTERNAL_DISPLAY_NAME appendString:string];
    
    //NSLog(@" here is the TITLE: %@", TITLE);
    //NSLog(@" here is the COMPANY: %@", COMPANY_NAME);
    
    
}
-(void)showCurrentDepth{
    //NSLog(@"current %@", depth);
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    
    
}

//Truncate database
- (void)flushdb
{
    NSLog(@"delete startede");
    [self.dcDelegate flush_contacts_db];
    [self.tableView reloadData];
}

//For every employee in contactlist addobjects to each of the array's
- (void)getContactsFromDB
{
    
    [filteredTableData removeAllObjects];
    [contactList removeAllObjects];
    
    NSLog(@"I was here contact...");
    contactList = [[NSMutableArray alloc]init];
    contactList = [self.dcDelegate getAll:self];
    NSLog(@"size: %u", [contactList count]);
    
    //Initialize Arrays
    contactNamesArray      = [[NSMutableArray alloc] init];
    contactNamesArrayEXTERNAL_DISPLAY_NAME = [[NSMutableArray alloc] init];
    contactNamesArrayFNAME = [[NSMutableArray alloc] init];
    contactNamesArrayLNAME = [[NSMutableArray alloc] init];
    contactNamesArrayINIT = [[NSMutableArray alloc] init];
    contactNamesArrayTITLE = [[NSMutableArray alloc]init];
    contactNamesArrayEMP_NO = [[NSMutableArray alloc] init]; 
    contactNamesArrayEMAIL = [[NSMutableArray alloc] init];
    contactNamesArrayBUSINESSAREA_NAME = [[NSMutableArray alloc] init];
    contactNamesArrayCOMPANY_NAME = [[NSMutableArray alloc]init];
    contactNamesArrayPHONE = [[NSMutableArray alloc] init];
    contactNamesArrayMOBIL = [[NSMutableArray alloc] init];
    contactNamesArraySUPERIOR = [[NSMutableArray alloc] init];
    contactNamesArrayLOCATION = [[NSMutableArray alloc] init];
    contactNamesArrayIMAGE_URL = [[NSMutableArray alloc] init];
    contactNamesArrayIMAGE_WEB_URL =[[NSMutableArray alloc] init];
    
    
    
    //Loop through contactlist after contacts and add info to the arrays
    for (Contacts *contact in contactList)
    {
        
        //NSLog(@"EXTERNAL_DISPLAY_NAME: %@, INIT: %@, EMP_NO: %@, EMAIL: %@, BUSINESSAREA_NAME: %@, PHONE: %@, MOBIL: %@, SUPERIOR: %@, LOCATION: %@", contact.EXTERNAL_DISPLAY_NAME, contact.INIT, contact.EMP_NO, contact.EMAIL, contact.BUSINESSAREA_NAME, contact.PHONE, contact.MOBIL, contact.SUPERIOR, contact.LOCATION);
        
        nextContact = [NSString stringWithFormat:@"%@", contact.EXTERNAL_DISPLAY_NAME];
        
        //NSLog(@"Added: %@", nextContact);
        
        [contactNamesArray addObject:nextContact];
        [contactNamesArrayEXTERNAL_DISPLAY_NAME addObject:contact.EXTERNAL_DISPLAY_NAME];
        [contactNamesArrayFNAME addObject:contact.FNAME];
        [contactNamesArrayLNAME addObject:contact.LNAME];
        [contactNamesArrayINIT addObject:contact.INIT];
        [contactNamesArrayTITLE addObject:contact.TITLE];
        [contactNamesArrayEMP_NO addObject:contact.EMP_NO];
        [contactNamesArrayEMAIL addObject:contact.EMAIL];
        [contactNamesArrayBUSINESSAREA_NAME addObject:contact.BUSINESSAREA_NAME];
        [contactNamesArrayCOMPANY_NAME addObject:contact.COMPANY_NAME];
        [contactNamesArrayPHONE addObject:contact.PHONE];
        [contactNamesArrayMOBIL addObject:contact.MOBIL];
        [contactNamesArraySUPERIOR addObject:contact.SUPERIOR];
        [contactNamesArrayLOCATION addObject:contact.LOCATION];
        [contactNamesArrayIMAGE_URL addObject:contact.IMAGE_URL];
        [contactNamesArrayIMAGE_WEB_URL addObject:contact.IMAGE_WEB_URL];
        
    }
    
       NSLog(@"count: %u", [contactNamesArray count]);
    
    //Creates array "sectionedListContent" to hold grouped data from contactlist
    NSMutableArray *sections = [NSMutableArray array];
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    for (Contacts *contact in contactList) {
        NSInteger section = [collation sectionForObject:contact collationStringSelector:@selector(EXTERNAL_DISPLAY_NAME)];
        [sections addObject:contact toSubarrayAtIndex:section];
    }
    
    NSInteger section = 0;
    for (section = 0; section < [sections count]; section++) {
        NSArray *sortedSubarray = [collation sortedArrayFromArray:[sections objectAtIndex:section]
                                          collationStringSelector:@selector(EXTERNAL_DISPLAY_NAME)];
        [sections replaceObjectAtIndex:section withObject:sortedSubarray];
    }
    sectionedListContent = sections;
    
    //Dismiss progress spinner
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [MBProgressHUD hideHUDForView:window animated:YES];
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
   
        
    }



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
    

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Setting back button text to "back" instead of the table title "Terma Employees"
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                  initWithTitle: @"Back" 
                                  style: UIBarButtonItemStyleBordered
                                  target: nil action:nil];
    
    
    
    [self.navigationItem setBackBarButtonItem: backButton];
           
    // Set table view title
    self.title = @"Terma Employees";
    searchBar.delegate = (id)self;
    //initialize dcDelegate dbdataController. REMEMBER TO PLACE FUNCTIONS AFTER THIS OR ELSE THERE ISN'T ANY DB CONNECTION
    self.dcDelegate = [[DbDataController alloc] init];
    //Get contacts from database
    [self getContactsFromDB];
    //initialize
    upBtPressed = [SettingsController btPressed];
    //initialize
    self.vDelegate =[[VersionController alloc]init];
    
    
    
}


// number of section i table view. If seraching return only searched data else return data table in sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isFiltered)
	{
        return 1;
    }
	else
	{
        return [self.sectionedListContent count];
    }
}

// Number og rows (contacts) in sections
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
	 If the requesting table view is the search, return the count of the filtered list, otherwise return the count of the main list.
	 */
	if (isFiltered)
	{
        return [self.filteredTableData count];
    }
	else
	{
        return [[self.sectionedListContent objectAtIndex:section] count];
    }
}

// Creations of cell design
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    //}
    
    // Inserts either the search result or full contactlist data into the tableview  
    Contacts* emp =nil;
    if(isFiltered)
        emp = [filteredTableData objectAtIndex:indexPath.row];
    else
        emp = [self.sectionedListContent objectAtIndexPath:indexPath];
    
    // What data to show in the table view at label text and subtitle. (This could be any data)
    cell.textLabel.text = emp.EXTERNAL_DISPLAY_NAME;
    cell.detailTextLabel.text = emp.INIT;
    
    
    // Configure the cell...
    
    //---------- CELL BACKGROUND IMAGE -----------------------------
    //UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
    
    ///UIImage *image = [UIImage imageNamed:@"LightGrey.png"];
    
    //imageView.image = image;
    
    //cell.backgroundView = imageView;
    
    //[[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    
    //[[cell detailTextLabel] setBackgroundColor:[UIColor clearColor]];
    
    
    
    //Cell Arrow 
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
    
    
    
}
-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}
// search bar function that runs when user types in search field
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    
    
    if(text.length == 0)
    {
        
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        filteredTableData = [[NSMutableArray alloc] init];
        
        for (Contacts* emp in contactList)
        {
            //In this case we are searching for employee name,initials and local phone number. (Add others if nessesary like phone, mobil ect.)
            NSRange nameRange = [emp.EXTERNAL_DISPLAY_NAME rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [emp.INIT rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange phoneRange = [emp.PHONE rangeOfString:text options:NSCaseInsensitiveSearch];

            if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound || phoneRange.location != NSNotFound)
            {
                [filteredTableData addObject:emp];
            }	
        }
    }
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData)
                                     withObject:nil
                                  waitUntilDone:NO];
}

// If user tabs the search button on the keyboard the keyboard dissapears
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self.searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailsForIndexPath:indexPath];
}

// parsing data to detailview controller when a employee in the tableview is selected
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailsForIndexPath:indexPath];
    
    DetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    
    [self.searchBar resignFirstResponder];
    
    Contacts *emp = nil;
    
    if(isFiltered)
    {
        emp = [filteredTableData objectAtIndex:indexPath.row];
        
    }
    else
    {
        emp = [self.sectionedListContent objectAtIndexPath:indexPath];
    }
    
    detail.emp = emp;
    
    
    [self.navigationController pushViewController:detail animated:YES]; 
}


-(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
{
    
}


//table cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
    
}
// Set title for header contact in section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (isFiltered) {
        return nil;
    } else {
        return [[self.sectionedListContent objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }
}
// creates the alphabet section titles
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (isFiltered) {
        return nil;
    } else {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
                [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    }
}
// creates the alphabet section titles
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (isFiltered) {
        return 0;
    } else {
        if (index == 0) {
            // search item
            [tableView scrollRectToVisible:[[tableView tableHeaderView] bounds] animated:NO];
            return -1;
        } else {
            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
        }
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    self.filteredTableData = nil;
    sectionedListContent = nil;
    [self setSearchBar:nil];
   
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    
        [super viewWillAppear:animated];
    if ([upBtPressed  isEqual:@"btpressed"]) {
        
    }
    else{
        [self.vDelegate getWebserviceVersion];
    }
    
    

    
    //[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
  
    [super viewDidAppear:animated];
   
    //ref. to btpressed see SettingsController.m
    if ([upBtPressed  isEqual:@"btpressed"]) {
        [self getData:self];
        [self.tableView reloadData];
        [self.vDelegate saveDbDataVersion];
        //[self.vDelegate getWebserviceVersion];
        //[self.vDelegate getDbDataVersion];
        
    }
        
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    	[super viewWillDisappear:animated];
        upBtPressed =nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
   
}



@end