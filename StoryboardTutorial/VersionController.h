//
//  VersionController.h
//  StoryboardTutorial
//
//  Created by Kristoffer Nielsen on 9/10/12.
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
    NSMutableString *appVerison;
    NSMutableString *dataVersion;
    //NSMutableString *update;
    

}
@property(nonatomic, copy)NSMutableString *appVerison;
@property(nonatomic, copy)NSMutableString *dataVersion;
@property (nonatomic, copy) NSMutableString *name;
//@property (nonatomic, retain) NSMutableString *update;
+(NSString*)update;
+(NSString*)dataupdate;
+(NSString*)showVersion;
+(NSString*)ShowNewestVersion;
@end
