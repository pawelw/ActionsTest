//
//  Proxy.m
//  ActionsTest
//
//  Created by Pawel Witkowski on 17/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "Proxy.h"
#import "Alerter.h"
#import "MainWindowController.h"
#import "GeneralPreferencesViewController.h"

@implementation Proxy

@synthesize delegate, manager, subtitleFileData;

-(void)callWebService:(NSString *)serviceName withArguments: (NSArray *)arguments
{
    
    // Use only one connection at a time 
    [manager closeConnections];
    NSURL *URL = [NSURL URLWithString: @"http://api.opensubtitles.org/xml-rpc"];
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
    manager = [XMLRPCConnectionManager sharedManager];
    
    [request setMethod: serviceName withParameters: arguments];
    
    [manager spawnConnectionWithXMLRPCRequest: request delegate: self];
}

- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response {
    if ([response isFault]) {
        [delegate didFaultProxyRequest];
    } else if ([[request method] isEqualToString:@"LogIn"]) {
        
        ////////////////////////////
        // OpenSubtitles.org "LogIn"
        ////////////////////////////
        LoginModel *loginModel = [LoginModel initAsSingleton];
        
        [loginModel setToken:[[response object] objectForKey:@"token"]];
        [loginModel setStatus:[[response object] objectForKey:@"status"]];
        [loginModel setResponseTime:[[response object] objectForKey:@"seconds"]];
        
        [delegate didFinishProxyRequest:request withData:loginModel]; // Custom delegate
        
    } else if ([[request method] isEqualToString:@"SearchSubtitles"]) {
        
        /////////////////////////////////////
        // OpenSubtitles.org "SearchSubtitles"
        /////////////////////////////////////
        NSDictionary *responseData = [[NSDictionary alloc] init];
        responseData = [[response object] objectForKey:@"data"];
        NSString *dataAsString = [NSString stringWithFormat:@"%@", responseData];
        
        if ([dataAsString isEqualToString:@"0"]) {
            [GeneralPreferencesViewController usePreferedLanguage] ? [Alerter showNotFoundAlertForLanguage] : [Alerter showNotFoundAlert];
            dataAsString = nil;
            return;
        } else {
            dataAsString = nil;
        }
        
        SearchModel *searchModel = [[SearchModel alloc] init];
        NSMutableArray *searchModelCollection = [[NSMutableArray alloc] init];
        
        for (NSString* key in responseData) {
            
            [searchModel setMovieName: [key valueForKey:@"MovieName"]];
            [searchModel setZipDownloadLink: [key valueForKey:@"ZipDownloadLink"]];
            [searchModel setSubDownloadLink: [key valueForKey:@"SubDownloadLink"]];
            [searchModel setSubFileName: [key valueForKey:@"SubFileName"]];
            [searchModel setLanguageName:[key valueForKey:@"LanguageName"]];
            [searchModel setIdMovie:[key valueForKey:@"IdMovie"]];
            [searchModel setSubActualCD:[key valueForKey:@"SubActualCD"]];
            
            // Sometimes Movie Release Name comes empty from the server. this statement replace empty name with MovieName
            if([[key valueForKey:@"MovieReleaseName"] isEqualToString:@""])
                [searchModel setMovieReleaseName: [key valueForKey:@"MovieName"]];
            else
                [searchModel setMovieReleaseName:[key valueForKey:@"MovieReleaseName"]];
            
            // Using key setter method to activate delegation of data to NSTableView
            [searchModelCollection addObject:[searchModel copy]];
        }
        
        [delegate didFinishProxyRequest:request withData:searchModelCollection]; // Custom delegate

    } else {
        NSLog(@"Parsed response: %@", [response object]);
        [delegate didFinishProxyRequest:request withData:response]; // Custom delegate
    }
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
