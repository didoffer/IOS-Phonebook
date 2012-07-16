//
//  Contacts.h
//  indextable test with database
//
//  Created by MacTerma on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface Contacts : NSObject{
    
    NSString *EXTERNAL_DISPLAY_NAME;
    NSString *INIT ;
    NSString *EMP_NO;
    NSString *EMAIL;
    NSString *BUSINESSAREA_NAME;
    NSString *PHONE ;
    NSString *MOBIL ;
    NSString *SUPERIOR ;
    NSString *LOCATION ;
}

@property (nonatomic, copy) NSString *EXTERNAL_DISPLAY_NAME;
@property (nonatomic, copy) NSString *INIT;
@property (nonatomic, copy) NSString *EMP_NO;
@property (nonatomic, copy) NSString *EMAIL;
@property (nonatomic, copy) NSString *BUSINESSAREA_NAME;
@property (nonatomic, copy) NSString *PHONE;
@property (nonatomic, copy) NSString *MOBIL;
@property (nonatomic, copy) NSString *SUPERIOR;
@property (nonatomic, copy) NSString *LOCATION;


@end
