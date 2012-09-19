//
//  ViewController.h
//  StoryboardTutorial
//
//  Created by Kurry Tran on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DataControllerDelegate.h"
#import "DbDataController.h"
#import "DetailViewController.h"
#import "MBProgressHUD.h"
#import "VersionControllerDelegate.h"
#import "VersionController.h"
#import "ViewControllerDelegate.h"
#import "SettingsController.h"

@class Reachability;

@interface ViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate, MBProgressHUDDelegate, UISearchBarDelegate, ViewControllerDelegate ,UISearchDisplayDelegate>{
    MBProgressHUD *HUD;
    ViewController *viewController;
    Reachability* internetReachable;
    Reachability* hostReachable;
  
@private
    
    NSArray  *sectionedListContent;  // The content filtered into alphabetical sections.
  
    
    NSXMLParser *xmlParser;
    NSString *currentElement;
    NSInteger depth;
    NSInteger *test;

       
    NSMutableString *FNAME;
    NSMutableString *LNAME;
    NSMutableString *INIT;
    NSMutableString *EMP_NO;
    NSMutableString *EMAIL;
    NSMutableString *BUSINESSAREA_NAME;
    NSMutableString *PHONE;
    NSMutableString *MOBIL;
    NSMutableString *SUPERIOR;
    NSMutableString *LOCATION;
    NSMutableString *IMAGE_URL;
    NSMutableString *IMAGE_WEB_URL;
    NSMutableString *EXTERNAL_DISPLAY_NAME;
    
    NSMutableArray *databaseData;
    NSMutableArray *contactList;
    NSMutableArray *contactNamesArray;
    NSMutableArray *contactNamesArrayEXTERNAL_DISPLAY_NAME;
    NSMutableArray *contactNamesArrayFNAME;
    NSMutableArray *contactNamesArrayLNAME;
    NSMutableArray *contactNamesArrayEMAIL;
    NSMutableArray *contactNamesArrayPHONE;
    NSMutableArray *contactNamesArrayINIT;
    NSMutableArray *contactNamesArrayEMP_NO;
    NSMutableArray *contactNamesArrayBUSINESSAREA_NAME;
    NSMutableArray *contactNamesArrayMOBIL;
    NSMutableArray *contactNamesArraySUPERIOR;
    NSMutableArray *contactNamesArrayLOCATION;
    NSMutableArray *contactNamesArrayIMAGE_URL;
    NSMutableArray *contactNamesArrayIMAGE_WEB_URL;
    
   	
    
}



@property(strong)NSMutableArray *contactList;// The master content.
@property (nonatomic, readonly) NSArray *sectionedListContent;
@property(strong, retain)NSMutableArray *contactNamesArray;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(strong)NSMutableArray *filteredTableData; // The content filtered as a result of a search.
@property (nonatomic, assign) bool isFiltered;

@property (strong, nonatomic) DbDataController *WebService;

- (IBAction)bt_update:(id)sender;



@property (strong, nonatomic) VersionController* ver;

@property (nonatomic, strong) id <DataControllerDelegate> dcDelegate;
@property (nonatomic, strong) id <VersionControllerDelegate> vDelegate;

- (void)getContactsFromDB;

-(void)getData:(UIViewController *)controller;



@end
