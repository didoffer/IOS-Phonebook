//
//  VersionController.m
//  StoryboardTutorial
//
//  Created by MacTerma on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VersionController.h"
#import "ViewController.h"
@interface VersionController ()
-(void) showCurrentDepth;
@end

@implementation VersionController
@synthesize appVerison,name,version;
static NSString* newUpdate = nil;
NSURLConnection *theConnection;
NSURLConnection *myConnection;
NSMutableData *receivedData;
NSString *nextContact;
NSString* xml;
NSString *dump; 
                    /*--------Version update start-----------*/
/*--------Change this value when a new version of the app i released-----------*/
 NSInteger hardcodedVersion = 1;
                    /*--------Version update finish-----------*/

//Request data from url connection
- (void)getWebserviceVersion{
    
    //Start progress spinner
    
    
    receivedData = [[NSMutableData alloc] init];
    
    NSURL *myURL = [NSURL URLWithString:@"http://midvm1.terma.com/kbni2/TermaService.svc/version/phonebook"];
    
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
        NSLog(@" here is the data: %@", xml);
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
    else if ([currentElement isEqualToString:@"NAME"]) {
        name = [[NSMutableString alloc]init];
    } 
    
    else if ([currentElement isEqualToString:@"VERSION"]) {
        version = [[NSMutableString alloc]init];
    }    

}
// Ends a employee element and insert it into the database
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"AppVersion"]) {
        --depth;
        //[self showCurrentDepth];
        NSLog(@"test  %@", version);
      
            }
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    if ([currentElement isEqualToString:@"NAME"]) 
        [name appendString:string];
    if ([currentElement isEqualToString:@"VERSION"]) 
        [version appendString:string];
       
    //NSLog(@" here is the contact: %@", version);
    //NSLog(@" here is the contact: %@", name);
   
    NSInteger dbVersion = [version intValue];
    NSLog(@" here is the contact: %d", dbVersion);
    if (hardcodedVersion < dbVersion) {
        newUpdate =@"YES";
    }
    else {
        newUpdate =@"NO";
    }
}
+(NSString*)update{
    return newUpdate;
}

-(void)showCurrentDepth{
    //NSLog(@"current %@", depth);
}

@end
