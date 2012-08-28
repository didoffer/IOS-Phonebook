//
//  DbDataController.h
//  StoryboardTutorial
//
//  Created by MacTerma on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataControllerDelegate.h"
@interface DbDataController : NSObject <DataControllerDelegate>{
NSMutableArray *data;           // Container for data returned from query
}

@property (nonatomic, retain) NSMutableArray *data;
@end
