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
#import "OrderedDictionary.h"

@implementation Proxy

@synthesize delegate, subtitleFileData;

-(id) init
{
    self = [super init];
    if(self)
    {
        loginModel = [LoginModel initAsSingleton];
        appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    }
    
    return self;
}

-(void)login {
    [self callWebService:@"LogIn" withArguments:[NSArray arrayWithObjects: @"", @"", @"en", @"subtitler", nil]];
}

-(void)searchForSubtitlesWithMovie: (MovieModel *)movie {
    [self searchByHash:movie.hash andByteSize:movie.bytes];
}

-(void) searchByHash: (NSString *)hash andByteSize: (double) bytes
{
    OrderedDictionary *dict = [[OrderedDictionary alloc] initWithCapacity:4];
    
    if ([GeneralPreferencesViewController usePreferedLanguage]) {
        [dict setObject:[GeneralPreferencesViewController preferedLanguage] forKey:@"sublanguageid"];
    } else {
        [dict setObject:@"" forKey:@"sublanguageid"];
    }
    
    [dict setObject:hash forKey:@"moviehash"];
    [dict setObject:[NSNumber numberWithDouble:bytes] forKey:@"moviebytesize"];
    
    NSArray *arguments = [NSArray arrayWithObjects:dict, nil];
    
    [self callWebService:@"SearchSubtitles" withArguments:[NSArray arrayWithObjects:[loginModel token], arguments, nil]];
}

-(void) disconnect
{
    [manager closeConnections];
    [urlConnection cancel];
}

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
        
        
        // "LogIn" ////////////////
        [loginModel setToken:[[response object] objectForKey:@"token"]];
        [loginModel setStatus:[[response object] objectForKey:@"status"]];
        [loginModel setResponseTime:[[response object] objectForKey:@"seconds"]];
        
        [delegate didFinishProxyRequestWithIdentifier:@"Login" withData:loginModel];// Custom delegate
        
    } else if ([[request method] isEqualToString:@"SearchSubtitles"]) {
        
        // "SearchSubtitles" ////////////////
        NSDictionary *responseData = [[NSDictionary alloc] init];
        responseData = [[response object] objectForKey:@"data"];
        NSString *dataAsString = [NSString stringWithFormat:@"%@", responseData];
        
        if ([dataAsString isEqualToString:@"0"]) {
            [delegate didFinishProxyRequestWithIdentifier:@"Search" withData:NO];
            dataAsString = nil;
            return;
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
            [searchModel setServer:SDOpenSubtitles];
            
            ///////////
            //[searchModel setSubFormat:[key valueForKey:@"SubFormat"]];
            // Check extention manualy from movie full name.
            ///////////
            NSString *ext = [[searchModel subFileName] pathExtension];
            [searchModel setSubFormat:ext];
            
            
            // Sometimes Movie Release Name comes empty from the server. this statement replace empty name with MovieName
            if([[key valueForKey:@"MovieReleaseName"] isEqualToString:@""])
                [searchModel setMovieReleaseName: [key valueForKey:@"MovieName"]];
            else
                [searchModel setMovieReleaseName:[key valueForKey:@"MovieReleaseName"]];
            
            // Using key setter method to activate delegation of data to NSTableView
            [searchModelCollection addObject:[searchModel copy]];
        }
        
        [delegate didFinishProxyRequestWithIdentifier:@"Search" withData:searchModelCollection]; // Custom delegate
        
    } else {
        [delegate didFinishProxyRequestWithIdentifier:@"Search" withData:response];
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

-(void) downloadSubtitle:(SearchModel *)subtitle
{
    [urlConnection cancel];
    subtitleFileData = nil;
    subtitleFileData = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString: [subtitle subDownloadLink]];
    
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
    NSData *uncompressedData = [subtitleFileData gunzippedData];
    [delegate fileDownloadFinishedWithData:uncompressedData];
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
    [delegate connectionTimedOut];
}


@end
