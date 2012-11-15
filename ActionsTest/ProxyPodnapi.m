//
//  Proxy.m
//  ActionsTest
//
//  Created by Pawel Witkowski on 17/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "ProxyPodnapi.h"
#import "Alerter.h"
#import "MainWindowController.h"
#import "GeneralPreferencesViewController.h"

@implementation ProxyPodnapi

@synthesize delegate, manager, subtitleFileData;

-(id) init
{
    self = [super init];
    if(self)
    {
        loginModel = [LoginModel initAsSingleton];
    }
    
    return self;
}

-(void) login
{
     [self callWebService:@"initiate" withArguments:[NSArray arrayWithObjects: @"subtitles downloader", nil]];
}

-(void)searchByHash: (NSString *)hash
{
    NSArray *hashesCollection = [NSArray arrayWithObjects:hash, nil];
    [self callWebService:@"search" withArguments:[NSArray arrayWithObjects: loginModel.session, hashesCollection, nil]];
}

-(void)callWebService:(NSString *)serviceName withArguments: (NSArray *)arguments
{
    // Use only one connection at a time
    [manager closeConnections];
    NSURL *URL = [NSURL URLWithString: @"http://ssp.podnapisi.net:8000/RPC2/"];
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
    manager = [XMLRPCConnectionManager sharedManager];
    
    [request setMethod: serviceName withParameters: arguments];
    
    [manager spawnConnectionWithXMLRPCRequest: request delegate: self];
}

- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response {
    
    if ([response isFault]) {
        [delegate didFaultProxyRequest];
        NSLog(@"Proxy is Fault with response: %@", response);
        
    } else if ([[request method] isEqualToString:@"initiate"]) {
        NSLog(@"initiate response: %@", response);
        [loginModel setSession:[[response object] objectForKey:@"session"]];
        [self callWebService:@"authenticate" withArguments:[NSArray arrayWithObjects: loginModel.session, @"", @"", nil]];
        
    } else if ([[request method] isEqualToString:@"authenticate"]) {
        //[self callWebService:@"search" withArguments:[NSArray arrayWithObjects: loginModel.session, @"", @"", nil]];
        NSLog(@"authenticate response: %@", response);
        [delegate didFinishProxyRequest:request withData:loginModel];
    } else if ([[request method] isEqualToString:@"search"]) {
        NSLog(@"search response: %@", response);
        
    } else {
        NSLog(@"Parsed response: %@", [response object]);
    }
}

- (void)request: (XMLRPCRequest *)request didFailWithError: (NSError *)error {
    // Call appDelegation method to pop up "No Internet connection Alert"
    NSLog(@"Proxy Error: %@", error);
    [delegate didFaultProxyRequest];
}

- (BOOL)request: (XMLRPCRequest *)request canAuthenticateAgainstProtectionSpace: (NSURLProtectionSpace *)protectionSpace {
    return YES;
}

- (void)request: (XMLRPCRequest *)request didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge {
    
}

- (void)request: (XMLRPCRequest *)request didCancelAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge {
}

//------------------------------------------------------

-(void)downloadDataFromURL:(NSURL *)url
{
    [urlConnection cancel];
    subtitleFileData = nil;
    subtitleFileData = [[NSMutableData alloc] init];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if (!urlConnection) {
        NSLog(@"Connection failed");
    }
}

#pragma mark - NSURL protocol methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [subtitleFileData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%@", subtitleFileData);
    [delegate fileDownloadFinishedWithData:subtitleFileData];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [subtitleFileData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [Alerter showAlertSheet:@"Connection failed!" andInfo:(@"Error - %@", [error localizedDescription])];
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}


@end
