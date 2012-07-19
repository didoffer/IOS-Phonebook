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


@interface ViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate, MBProgressHUDDelegate, UISearchBarDelegate, UISearchDisplayDelegate>{
    MBProgressHUD *HUD;

@private
    
    
    
   
    
    
    NSMutableDictionary *EMPLOYEE;
    NSXMLParser *xmlParser;
    NSString *currentElement;
    NSInteger depth;
    NSMutableString *currentname;

   
    
    
    
    NSMutableString *INIT;
    NSMutableString *EMP_NO;
    NSMutableString *EMAIL;
    NSMutableString *BUSINESSAREA_NAME;
    NSMutableString *PHONE;
    NSMutableString *MOBIL;
    NSMutableString *SUPERIOR;
    NSMutableString *LOCATION;
    NSMutableString *EXTERNAL_DISPLAY_NAME;
    
    
    NSMutableArray *contactList;
    NSMutableArray *contactNamesArray;
    NSMutableArray *contactNamesArrayEXTERNAL_DISPLAY_NAME;
    NSMutableArray *contactNamesArrayEMAIL;
    NSMutableArray *contactNamesArrayPHONE;
    NSMutableArray *contactNamesArrayINIT;
    NSMutableArray *contactNamesArrayEMP_NO;
    NSMutableArray *contactNamesArrayBUSINESSAREA_NAME;
    NSMutableArray *contactNamesArrayMOBIL;
    NSMutableArray *contactNamesArraySUPERIOR;
    NSMutableArray *contactNamesArrayLOCATION;
    
    
    
}

@property(strong, retain)NSMutableArray *contactList;

@property(strong, retain)NSMutableArray *contactNamesArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(strong, retain)NSMutableArray *filteredTableData;

@property (nonatomic, assign) bool isFiltered;

@property (nonatomic, strong) id <DataControllerDelegate> dcDelegate;
- (void)getContactsFromDB;



@end
