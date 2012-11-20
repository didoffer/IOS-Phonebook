//
//  VersionController.m
//  StoryboardTutorial
//
//  Created by Kristoffer Nielsen on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VersionController.h"
#import "ViewController.h"
@interface VersionController ()
-(void) showCurrentDepth;
@end

@implementation VersionController
@synthesize appVerison,name,dataVersion;
static NSString* newUpdate = nil;
static NSString* newdataUpdate = nil;
static NSString* currentversion = nil;
static NSString* newestVersion = nil;
NSURLConnection *theConnection;
NSURLConnection *myConnection;
NSMutableData *receivedData;
NSString *nextContact;
NSString* xml;
NSString *dump;
NSArray *array;
NSInteger Dataversion;
double dbAppVersionINT;
NSInteger dbDataVersionINT;


//Save the current dataversion of the data into NSUserdefault. It is now stored and can be loaded again
-(void) saveDbDataVersion{
    Dataversion =dbDataVersionINT;
    //NSLog(@"tatatatat %d", Dataversion);
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    [data setInteger:Dataversion forKey:@"DataVersion"];
    NSLog(@"saved data version: %d",Dataversion);
    [data synchronize];
    NSLog(@"data version saved");
}

// Get the current dataversion of the data from NSUserdefault.
-(void) getDbDataVersion{
    NSUserDefaults *data =[NSUserDefaults standardUserDefaults];
    Dataversion = [data integerForKey:@"DataVersion"];
    NSString *dataString =[NSString stringWithFormat:@"%i", Dataversion];
    NSLog(@"Har hentet data version fra NSUserDefault: %@", dataString);
    
}
//methode to start connection to the webservice for recieving app version and data version
- (void)getWebserviceVersion{
        
    [self getDbDataVersion];
    receivedData = [[NSMutableData alloc] init];
    
    NSURL *myURL = [NSURL URLWithString:@"http://intranet2.terma.com/phonebook/TermaService.svc/version/phonebook"];
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
    
    theConnection = [[NSURLConnection alloc] initWithRequest:myRequest delegate:self];
    
    
    if (theConnection){
        receivedData = [NSMutableData data];}
    else
    {}

}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //NSLog(@"data: %@", dump);
    [receivedData setLength:0];
    
}
//append received data to data
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
    //NSLog(@"Added: %@", receivedData);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
       
    
}
// if it get connection to the url it starts parsing xml (try the NSlog further down the function to see the parsed xml data)
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (theConnection) {
        xml = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        xmlParser = [[NSXMLParser alloc] initWithData:[xml dataUsingEncoding:NSUTF8StringEncoding]];
        [xmlParser setDelegate:self];
        [xmlParser setShouldProcessNamespaces:NO];
        [xmlParser setShouldReportNamespacePrefixes:NO];
        [xmlParser setShouldResolveExternalEntities:NO];
        [xmlParser parse];
        //NSLog(@" here is the data: %@", xml);
    }
    //[self getContactsFromDB];
}
-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    depth = 0;
    currentElement = nil;
}
// xml parse error
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Error: %@", [parseError localizedDescription]);
}



// parse through the xml data for every start Employee element with child items
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    currentElement = [elementName copy];
    
    if ([currentElement isEqualToString:@"AppVersion"]) {
        ++depth;
        [self showCurrentDepth];
        
    }
    else if ([currentElement isEqualToString:@"APP_VERSION"]) {
        appVerison = [[NSMutableString alloc]init];
    }
    
    else if ([currentElement isEqualToString:@"DATA_VERSION"]) {
        dataVersion = [[NSMutableString alloc]init];
    }

    else if ([currentElement isEqualToString:@"NAME"]) {
        name = [[NSMutableString alloc]init];
    } 
    
    

}
// Ends a employee element and insert it into the database
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"AppVersion"]) {
        --depth;
        //[self showCurrentDepth];
        //NSLog(@"test  %@", version);
      
            }
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([currentElement isEqualToString:@"APP_VERSION"])
        [appVerison appendString:string];
    if ([currentElement isEqualToString:@"DATA_VERSION"])
        [dataVersion appendString:string];
    if ([currentElement isEqualToString:@"NAME"]) 
        [name appendString:string];
   
    
    NSLog(@" here is the appversion: %@", appVerison);
    NSLog(@" here is the dataversion: %@", dataVersion);
   
    //
    }

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    dbAppVersionINT = [appVerison doubleValue];
    dbDataVersionINT = [dataVersion intValue];
    // NSLog(@" here is the db version: %d", dbVersion);
    
    if (dbDataVersionINT != Dataversion) {
        NSLog(@"Data version fra db %d",dbDataVersionINT);
        NSLog(@"Data version fra NSUserDefault %d",Dataversion);
        newdataUpdate =@"YES";
                
    }
    else {
        newdataUpdate =@"NO";
    }
    
    //Check if db version number of the app has been updated. If so it returns value YES
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    
    double versionNumber = [version doubleValue];
    //NSInteger versionNumber = [version integerValue];
    
    if (versionNumber != dbAppVersionINT) {
        newUpdate =@"YES";
        currentversion = version;
        newestVersion = appVerison;
    }
    else {
        newUpdate =@"NO";
    }

    
}
//methodes which returns a value which is used in settingsController.m
+(NSString*)ShowNewestVersion{
    return newestVersion;
}
+(NSString*)showVersion{
    return currentversion;
}
+(NSString*)update{
    return newUpdate;
}
+(NSString*)dataupdate{
    return newdataUpdate;
}

-(void)showCurrentDepth{
    //NSLog(@"current %@", depth);
}

@end
