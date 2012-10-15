//
//  Contacts.h
//  indextable test with database
//
//  Created by Kristoffer Nielsen on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface Contacts : NSObject{
    
    NSString *EXTERNAL_DISPLAY_NAME;
    NSString *FNAME;
    NSString *LNAME;
    NSString *INIT ;
    NSString *TITLE;
    NSString *EMP_NO;
    NSString *EMAIL;
    NSString *BUSINESSAREA_NAME;
    NSString *COMPANY_NAME;
    NSString *PHONE ;
    NSString *MOBIL ;
    NSString *SUPERIOR ;
    NSString *LOCATION ;
    NSString *IMAGE_URL;
    NSString *IMAGE_WEB_URL;
}

@property (nonatomic, copy) NSString *EXTERNAL_DISPLAY_NAME;
@property (nonatomic, copy) NSString *FNAME;
@property (nonatomic, copy) NSString *LNAME;
@property (nonatomic, copy) NSString *INIT;
@property (nonatomic, copy) NSString *TITLE;
@property (nonatomic, copy) NSString *EMP_NO;
@property (nonatomic, copy) NSString *EMAIL;
@property (nonatomic, copy) NSString *BUSINESSAREA_NAME;
@property (nonatomic, copy) NSString *COMPANY_NAME;
@property (nonatomic, copy) NSString *PHONE;
@property (nonatomic, copy) NSString *MOBIL;
@property (nonatomic, copy) NSString *SUPERIOR;
@property (nonatomic, copy) NSString *LOCATION;
@property (nonatomic, copy) NSString *IMAGE_URL;
@property (nonatomic, copy) NSString *IMAGE_WEB_URL;


@end
