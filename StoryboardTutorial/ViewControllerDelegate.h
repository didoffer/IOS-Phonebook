//
//  ViewControllerDelegate.h
//  StoryboardTutorial
//
//  Created by MacTerma on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ViewControllerDelegate <NSObject>
-(void) getWebserviceData;
-(void) flushdb;
-(void)refreshDataTable;
-(void) getContactsFromDB;


@end
