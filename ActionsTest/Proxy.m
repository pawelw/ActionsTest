//
//  Proxy.m
//  ActionsTest
//
//  Created by Pawel Witkowski on 17/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "Proxy.h"

@implementation Proxy

@synthesize loginModel, delegate, manager, subtitleFileData;

-(void)callWebService:(NSString *)serviceName withArguments: (NSArray *)arguments
{
    NSURL *URL = [NSURL URLWithString: @"http://api.opensubtitles.org/xml-rpc"];
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
    manager = [XMLRPCConnectionManager sharedManager];
    
    
    [request setMethod: serviceName withParameters: arguments];
    
    NSLog(@"Request body: %@", [request body]);
    
    [manager spawnConnectionWithXMLRPCRequest: request delegate: self];
    
}

- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response {
    if ([response isFault]) {
        //NSLog(@"Fault code: %@", [response faultCode]);
        
        //NSLog(@"Fault string: %@", [response faultString]);
    } else {
        NSLog(@"Parsed response: %@", [response object]);
    }
        
    NSLog(@"%@", [manager activeConnectionIdentifiers]);
    [delegate didFinishProxyRequest:request withResponse:response]; // Custom delegate
}

- (void)request: (XMLRPCRequest *)request didFailWithError: (NSError *)error {
    // Call appDelegation method to pop up "No Internet connection Alert"
    [delegate didFaultProxyRequest];
}

- (BOOL)request: (XMLRPCRequest *)request canAuthenticateAgainstProtectionSpace: (NSURLProtectionSpace *)protectionSpace {
    return YES;
}

- (void)request: (XMLRPCRequest *)request didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge {
    
}

- (void)request: (XMLRPCRequest *)request didCancelAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge {
}

-(void)downloadDataFromURL:(NSURL *)url
{
    subtitleFileData = nil;
    subtitleFileData = [[NSMutableData alloc] init];
   // NSURL* fileURL = [NSURL URLWithString:[selectedSubtitle subtitlesLink]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if (!connection) {
        NSLog(@"Connection failed");
    }
}


#pragma mark - NSURL protocol methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //int length = data.length;
    //NSLog(@"%i", length);
    [subtitleFileData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [delegate fileDownloadFinishedWithData:subtitleFileData];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [subtitleFileData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}


@end
