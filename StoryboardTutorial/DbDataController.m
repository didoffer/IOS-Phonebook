//
//  DbDataController.m
//  StoryboardTutorial
//
//  Created by MacTerma on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DbDataController.h"
#import "sqlite3.h"
#import "Contacts.h"
#import "ViewController.h"

//
@implementation DbDataController {
    NSString       *db;             // Database name string
    sqlite3        *dbh;            // Database handle
    sqlite3_stmt   *stmt_query;     // Select statement handle
    sqlite3_stmt   *stmt_delete;    // Delete statement handle
    sqlite3_stmt   *stmt_insert;    // Insert statement handle
}
@synthesize data;

// Copy a named resource from bundle to Documents/Data
- (NSString *)copyResource:(NSString *)resource ofType:(NSString *)type
{
    NSString *dstDb = nil; 
    // Find path to Sandbox Documents
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // Find named resource in bundle
    NSString *srcDb = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    // Build path to "Data" subdirectory in Sandbox Documents
    NSString *dstDir = [docDir stringByAppendingPathComponent:@"Data"];
    // Build basename to resource in Sandbox Documents/Data
    NSString *dstBase = [dstDir stringByAppendingPathComponent:resource];
    // Append resource extension to build full path to resource "Documents/Data/resource.type"
    dstDb = [dstBase stringByAppendingPathExtension:type];
    
    NSError *error = nil;
    BOOL isDirectory = false;
    // Test if "Data" subdirectory exists in Sandbox "Documents"
    if (![[NSFileManager defaultManager] fileExistsAtPath:dstDir isDirectory:&isDirectory])
    {
        // Create "Data" subdirecotory
        if (![[NSFileManager defaultManager] createDirectoryAtPath:dstDir withIntermediateDirectories:YES attributes:nil error:&error])
            NSLog(@"Error creating directory:%@ \n", [error localizedDescription]);
    }
    
    // Test if named resource exists in Documents/Data
    if (![[NSFileManager defaultManager] fileExistsAtPath:dstDb])
    {
        // Copy the named resource from bundle to Documents/Data
        if (![[NSFileManager defaultManager] copyItemAtPath:srcDb toPath:dstDb error:&error])
            NSLog(@"Error: copying resource:%@\n", [error localizedDescription]);
    }
    
    // Return full path to resource "Documents/Data/resource.type"
    return dstDb;
}

// Housekeeping
// Prepare array to hold data from data storage
// Setup access to data storage
- (id)init
{
    self = [super init];
    if (self) 
    {
        // Copy sqlite database from bundle to Sandbox
        db = [self copyResource:@"Contact" ofType:@"rdb"];
        
        // Open database
        if (sqlite3_open([db UTF8String], &dbh) != SQLITE_OK) 
        {
            NSLog(@"Error:open");
        }
        
        // Reset statements
        stmt_query = nil;
        stmt_delete = nil;
        stmt_insert = nil;
        
        // Allocate array to hold data from data storage       
        data = [[NSMutableArray alloc] init];
    }
    return self;
}

//
- (void)dealloc
{   
    // Cleanup statement handles
    sqlite3_finalize(stmt_query);
    sqlite3_finalize(stmt_delete);
    sqlite3_finalize(stmt_insert);
    
    // Close database
    sqlite3_close(dbh);
}

#pragma mark - DataControllerDelegate 

// Fetch contact objects from data storage
// Return array with contact objects, selected according to SQL statement
- (NSMutableArray *) getAll:(ViewController *)controller
{
        
    ///////////
    if (!stmt_query)  
    {
        // Prepare SQL select statement
        NSString *sql = @"SELECT EXTERNAL_DISPLAY_NAME, FNAME, LNAME, INIT, EMP_NO, EMAIL, BUSINESSAREA_NAME, PHONE, MOBIL, SUPERIOR, LOCATION, IMAGE_URL FROM contacts";
        if (sqlite3_prepare_v2(dbh, [sql UTF8String], -1, &stmt_query, nil) != SQLITE_OK)
        {
            NSLog(@"Error preparing SQL query");
             
            return data;
            
        }
    }
    
    // Reset state of query statement
    sqlite3_reset(stmt_query);  
    // Fetch selected rows in contact table and populate data array
    while (sqlite3_step(stmt_query) == SQLITE_ROW) 
    {
        Contacts *contacts = [[Contacts alloc] init];
        
        // Assign name property with id column in result
        contacts.EXTERNAL_DISPLAY_NAME = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt_query, 0)];
        contacts.FNAME = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt_query, 1)];
        contacts.LNAME = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt_query, 2)];
        // Assign icao property with id column in result
        contacts.INIT = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt_query, 3)];
        // Assign country property with id column in result
        contacts.EMP_NO = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt_query, 4)];
        contacts.EMAIL = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt_query, 5)];
        contacts.BUSINESSAREA_NAME = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt_query, 6)];
        contacts.PHONE = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt_query, 7)];
        contacts.MOBIL = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt_query, 8)];
        contacts.SUPERIOR = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt_query, 9)];
        contacts.LOCATION = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt_query, 10)];
        contacts.IMAGE_URL = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt_query, 11)];
        
        
        // Append Contact object to data array
        [data addObject:contacts];
        //NSLog(@"===> Added Contact %@ %@", contacts.EXTERNAL_DISPLAY_NAME, contacts.INIT);
        
    }
    NSLog(@"size of data: %u", [data count]);
    
    return data;
}


/************/
// Flush all contacts
- (void)flush_contacts_db
{
    //Initialize data AGAIN so the array is empty when you update
    data = [[NSMutableArray alloc] init];
    
    if (!stmt_delete)  {
        // Prepare SQL delete statement (once)
        NSString *sql = @"DELETE FROM contacts";

        if (sqlite3_prepare_v2(dbh, [sql UTF8String], -1, &stmt_delete, NULL) != SQLITE_OK) {
            NSLog(@"Error:prepare:%@", sqlite3_errmsg(dbh));
            return;
        }
    }
    
    NSLog(@"### Start of DELETE ###");
    // Reset state of delete statement
    sqlite3_reset(stmt_delete);  
    // Execute (step) delete statement
    if (sqlite3_step(stmt_delete) == SQLITE_ERROR) {
        NSLog(@"Error:delete:%@", sqlite3_errmsg(dbh));
        return;
    }
    
     NSLog(@"size of database: %u", [data count]);
    NSLog(@"### End of DELETE ###");
    
}

- (void)insert_into_contacts_db:(NSString *)EXTERNAL_DISPLAY_NAME:(NSString *)FNAME:(NSString *)LNAME:(NSString *)INIT:(NSString *)EMP_NO:(NSString *)EMAIL: (NSString *)BUSINESSAREA_NAME: (NSString *)PHONE: (NSString *)MOBIL: (NSString *)SUPERIOR: (NSString *)LOCATION: (NSString *)IMAGE_URL
{

        NSString *sql = [NSString stringWithFormat: @"INSERT INTO contacts (EXTERNAL_DISPLAY_NAME, FNAME, LNAME, INIT, EMP_NO, EMAIL, BUSINESSAREA_NAME, PHONE, MOBIL, SUPERIOR, LOCATION, IMAGE_URL) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", EXTERNAL_DISPLAY_NAME, FNAME, LNAME, INIT, EMP_NO, EMAIL, BUSINESSAREA_NAME, PHONE, MOBIL, SUPERIOR, LOCATION, IMAGE_URL];
        if (sqlite3_prepare_v2(dbh, [sql UTF8String], -1, &stmt_insert, NULL) != SQLITE_OK) {
            NSLog(@"Error:prepare:%@", sqlite3_errmsg(dbh));
            return;
        }


    
    //NSLog(@"### Start of INSERT ###");
    // Reset state of delete statement
    sqlite3_reset(stmt_insert); 
    // Execute (step) delete statement
    if (sqlite3_step(stmt_insert) == SQLITE_DONE) {
        //NSLog(@"DONE %@", EXTERNAL_DISPLAY_NAME);
    } else {
        //NSLog(@"Error:delete:%@", sqlite3_errmsg(dbh));
    }
        
    //NSLog(@"### End of INSERT ###");
}

/*
 // Insert into database
 - (void)insert_into_contacts_db2:(NSString *)first_name:(NSString *)last_name:(NSString *)Phone:(NSString *)email
 {
 
 if (!stmt_insert)  {
 // Prepare SQL insert statement (once)
 NSString *sql = [NSString stringWithFormat: @"INSERT INTO contacts (first_name, last_name, phone, email) VALUES(%@, %@, %@, %@)", first_name, last_name, Phone, email];
 if (sqlite3_prepare_v2(dbh, [sql UTF8String], -1, &stmt_insert, NULL) != SQLITE_OK) {
 NSLog(@"Error:prepare:%@", sqlite3_errmsg(dbh));
 return;
 }
 }
 
 //    // Reset state of delete statement
 //    sqlite3_reset(stmt_delete);  
 //    // Execute (step) delete statement
 //    if (sqlite3_step(stmt_delete) == SQLITE_ERROR) {
 //        NSLog(@"Error:delete:%@", sqlite3_errmsg(dbh));
 //        return;
 //    }
 
 // Insert all Airfield objects in array into table
 for (Contacts *contacts in data) {
 // Reset state of insert statement
 sqlite3_reset(stmt_insert);      
 
 // Bind first name to statement
 //sqlite3_bind_int(stmt_insert, 1, contacts.first_name);
 sqlite3_bind_text(stmt_insert, 1, [contacts.first_name UTF8String], strlen([contacts.first_name UTF8String]), SQLITE_STATIC);
 // Bind last name to statement
 sqlite3_bind_text(stmt_insert, 2, [contacts.last_name UTF8String], strlen([contacts.last_name UTF8String]), SQLITE_STATIC);
 // Bind phone to statement
 sqlite3_bind_text(stmt_insert, 3, [contacts.phone UTF8String], strlen([contacts.phone UTF8String]), SQLITE_STATIC);
 // Bind email to statement
 sqlite3_bind_text(stmt_insert, 3, [contacts.email UTF8String], strlen([contacts.email UTF8String]), SQLITE_STATIC);
 //etc., etc.
 
 //Execute (step) insert statement
 sqlite3_step(stmt_insert);
 
 }
 
 }
 }
 */
/************/


/*
 // Add Airfield object to array. 
 // Insert new object into data storage.
 - (void) insert:(SecondViewController *)controller contact:(Contact *)contact
 {
 [data addObject:contact];
 [self setAll]; 
 }
 
 
 // Update Airfield object in data storage.
 - (void) update:(SecondViewController *)controller atIndex:(int)index
 {
 [self setAll];
 }
 
 // Delete Airfield object from data storage
 // Remove Airfield object from array
 - (void) remove:(SecondViewController *)controller atIndex:(int)index
 {
 [data removeObjectAtIndex:index];
 [self setAll];
 }
 */
@end

