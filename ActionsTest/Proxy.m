//
//  Proxy.m
//  ActionsTest
//
//  Created by Pawel Witkowski on 17/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "Proxy.h"

@implementation Proxy

@synthesize loginModel, delegate, manager;

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
        //NSLog(@"Parsed response: %@", [response object]);
    }
        
    NSLog(@"%@", [manager activeConnectionIdentifiers]);
    [delegate didFinishProxyRequest:request withResponse:response]; // Custom delegate
}

- (void)request: (XMLRPCRequest *)request didFailWithError: (NSError *)error {
    // Call appDelegation method to pop up "No Internet connection Alert"
}

- (BOOL)request: (XMLRPCRequest *)request canAuthenticateAgainstProtectionSpace: (NSURLProtectionSpace *)protectionSpace {
    return YES;
}

- (void)request: (XMLRPCRequest *)request didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge {
    
}

- (void)request: (XMLRPCRequest *)request didCancelAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge {
    
}

@end
