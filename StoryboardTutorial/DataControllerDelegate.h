//
//  DataControllerDelegate.h
//  indextable test with database
//
//  Created by MacTerma on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ViewController;
@class Contacts;

@protocol DataControllerDelegate <NSObject>

- (NSMutableArray *) getAll:(ViewController *)controller;
- (void)flush_contacts_db;
- (void)insert_into_contacts_db:(NSString *)EXTERNAL_DISPLAY_NAME:(NSString *)FNAME:(NSString *)LNAME:(NSString *)INIT:(NSString *)EMP_NO:(NSString *)EMAIL: (NSString *)BUSINESSAREA_NAME: (NSString *)PHONE: (NSString *)MOBIL: (NSString *)SUPERIOR: (NSString *)LOCATION:(NSString *)IMAGE_URL:(NSString *)IMAGE_WEB_URL;

@end
