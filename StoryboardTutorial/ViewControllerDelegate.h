//
//  ViewControllerDelegate.h
//  StoryboardTutorial
//
//  Created by Kristoffer Nielsen on 06/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ViewControllerDelegate <NSObject>
-(void) getWebserviceData;
-(void) flushdb;
-(void) getContactsFromDB;


@end
