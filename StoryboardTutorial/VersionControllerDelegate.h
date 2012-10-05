//
//  VersionControllerDelegate.h
//  StoryboardTutorial
//
//  Created by Kristoffer Nielsen on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VersionControllerDelegate <NSObject>

-(void)getWebserviceVersion;
-(void)saveDbDataVersion;

@end


