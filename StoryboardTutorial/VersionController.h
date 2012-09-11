//
//  VersionController.h
//  StoryboardTutorial
//
//  Created by MacTerma on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VersionControllerDelegate.h"


@interface VersionController : NSObject<NSXMLParserDelegate, VersionControllerDelegate>{
@private
    
    NSXMLParser *xmlParser;
    NSString *currentElement;
    NSInteger depth;

    //NSMutableString *version;
    //NSMutableString *name;
    NSMutableArray *appVerison;
    //NSMutableString *update;
    

}
@property(strong, retain)NSMutableArray *appVerison;
@property (nonatomic, copy) NSMutableString *name;
@property (nonatomic, copy) NSMutableString *version;
//@property (nonatomic, retain) NSMutableString *update;
+(NSString*)update;
@end
