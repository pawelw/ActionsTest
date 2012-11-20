//
//  ProxyPodnapisiXML.m
//  Subtitles Downloader
//
//  Created by Pawel Witkowski on 19/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "ProxyPodnapisiXML.h"
#import "Alerter.h"

@implementation ProxyPodnapisiXML

@synthesize delegate;

-(id) init
{
    self = [super init];
    if(self)
    {
        loginModel = [LoginModel initAsSingleton];
        respondData = [[NSMutableData alloc] init];
    }
    
    return self;
}

-(void) login
{
    //NSError *error = nil;
    XMLRPCRequest *request = [[XMLRPCRequest alloc] init];
    //[request setMethod:@"PodnapisiEmptyLogin"];
    [delegate didFinishProxyRequest:request withData:loginModel];
}

- (void) searchWithMovieName: (NSString *) movieName
{
   // NSString *st = [NSString stringWithFormat:@"http://podnapisi.net/en/ppodnapisi/search?sK=%@&sXML=1", movieName];
    NSString *st = [NSString stringWithFormat:@"http://podnapisi.net/en/ppodnapisi/search?sK=AmericanBeauty&sXML=1"];
    NSLog(st);
    NSString *st2 = [NSString stringWithFormat:@"http://apple.com"];
    NSURL *url = [NSURL URLWithString:st];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
   // NSURLResponse *response = nil;
    
    //NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if (!connection) {
        NSLog(@"Connection failed");
    }
}

#pragma mark - NSURL protocol methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [respondData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //[delegate fileDownloadFinishedWithData:subtitleFileData];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:respondData];
    [parser setDelegate:self];
    
    BOOL success = [parser parse];
    
    if(!success){
        NSError *outError = [parser parserError];
        NSLog(@"Parser error: %@", outError);
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [respondData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [Alerter showAlertSheet:@"Connection failed!" andInfo:(@"Error - %@", [error localizedDescription])];
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

#pragma mark - NSParser protocol methods

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqual:@"result"]) {
        currentFields = [NSMutableArray new];
    }
    
    if([elementName isEqual:@"subtitle"]) {
        [currentFields setObject:attributeDict forKey:@"subtitle"];
        
    }
    
    NSLog(@"%@", attributeDict);
}

-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqual:@"release"]) {
        SearchModel *searchM = [[SearchModel alloc] init];
    }
}

@end