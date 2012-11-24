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
#import "NSString+MD5.h"
#import "NSString+SHA256.h"

@implementation ProxyPodnapi

@synthesize delegate, manager, subtitleFileData;

-(id)init
{
    self = [super init];
    if(self)
    {
        loginModel = [LoginModel initAsSingleton];
        respondData = [[NSMutableData alloc] init];
        searchModelCollection = [[NSMutableArray alloc] init];
        selectedSubtitle = [SearchModel new];
    }
    
    return self;
}

-(void)login
{
     [self callWebService:@"initiate" withArguments:[NSArray arrayWithObjects: @"subtitles downloader", nil]];
}

-(void)authenticate
{
    NSString *md5Pass = [[loginModel.password MD5String] lowercaseString];
    NSString *combined = [NSString stringWithFormat:@"%@%@", md5Pass, loginModel.nonce];
    NSString *pass = [NSString sha256:combined];

    [self callWebService:@"authenticate" withArguments:[NSArray arrayWithObjects: loginModel.session, @"subtitlesdownloader", pass, nil]];
}

- (void)searchForSubtitlesWithMovie: (MovieModel *)movie
{
    connectionID = @"search";
    
    NSString *formatedName = [movie.name stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://podnapisi.net/en/ppodnapisi/search?sK=%@&sXML=1", formatedName]];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if (!connection) {
        NSLog(@"Connection failed");
    }
}

-(void)searchByHash: (NSString *)hash
{
    NSArray *hashesArray = [NSArray arrayWithObjects:hash, nil];
    NSMutableDictionary *hashesDictionary = [NSMutableDictionary new];
    [hashesDictionary setObject:hashesArray forKey:@"hash"];
    [self callWebService:@"search" withArguments:[NSArray arrayWithObjects: loginModel.session, hashesArray, nil]];
}

-(void)downloadSubtitle: (SearchModel *)subtitle
{
    // This web service on download is not downloading its only return file name for download.
    selectedSubtitle = subtitle;
    NSArray * subtitleIdArray = [NSArray arrayWithObjects:selectedSubtitle.index, nil];
    [self callWebService:@"download" withArguments:[NSArray arrayWithObjects: loginModel.session, subtitleIdArray, nil]];
}

-(void) doActualdownload {
    
    connectionID = @"download";
    
    [urlConnection cancel];
    subtitleFileData = nil;
    subtitleFileData = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString: [selectedSubtitle subDownloadLink]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if (!urlConnection) {
        NSLog(@"Connection failed");
    }
}

-(void) disconnect
{
    [manager closeConnections];
    [urlConnection cancel];
}


#pragma mark - XMLRPC Request


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
    
    //NSLog(@"%@",response.object);
    
    if ([response isFault]) {
        
        [delegate didFaultProxyRequest];
        
    } else if ([[request method] isEqualToString:@"initiate"]) {

        [loginModel setSession:[[response object] objectForKey:@"session"]];
        [loginModel setPassword:@"stratocaster1!"];
        [loginModel setNonce:[[response object] objectForKey:@"nonce"]];
        
        [self authenticate];
        
    } else if ([[request method] isEqualToString:@"authenticate"]) {
        //[delegate didFinishProxyRequestWithIdentifier:@"Login" withData:loginModel];// Custom delegate
        [self callWebService:@"supportedLanguages" withArguments:[NSArray arrayWithObjects: loginModel.session, nil]];

    } else if ([[request method] isEqualToString:@"supportedLanguages"]) {
        
        [delegate didFinishProxyRequestWithIdentifier:@"Login" withData:loginModel];// Custom delegate
        //[self callWebService:@"supportedLanguages" withArguments:[NSArray arrayWithObjects: loginModel.session, nil]];
        
    } else if ([[request method] isEqualToString:@"search"]) {
        NSLog(@"Search done only to keep session valid for download");
    } else if ([[request method] isEqualToString:@"download"]) {
        NSDictionary *files = [NSDictionary dictionaryWithDictionary:[response object]];
        
        NSDictionary *dic = [[NSDictionary alloc] init];
        dic = [[files objectForKey:@"names"] objectAtIndex:0];
        //dic = [filesArray objectAtIndex:0];
        [selectedSubtitle setSubDownloadLink:[NSString stringWithFormat:@"http://www.podnapisi.net/static/podnapisi/%@",[dic objectForKey:@"filename"]]];
        [selectedSubtitle setSubFormat:@"zip"];
        [self doActualdownload];
    } else {

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

// NSURL protocol methods /////////////////////////
///////////////////////////////////////////////////

#pragma mark - NSURL protocol methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [respondData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //[delegate fileDownloadFinishedWithData:subtitleFileData];

    if ([connectionID isEqual:@"download"]) {
        //NSData *uncompressedData = [respondData zlibDeflate];
        [delegate fileDownloadFinishedWithData:respondData];
    } else if ([connectionID isEqualToString:@"search"]) {
        [self parse];
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


// Parsing ////////////////////////////////////////
///////////////////////////////////////////////////

-(void) parse
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:respondData];
    [parser setDelegate:self];
    
    BOOL success = [parser parse];
    
    if(!success){
        NSError *outError = [parser parserError];
        NSLog(@"Parser error: %@", outError);
    }
}

#pragma mark - NSParser protocol methods

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqual:@"subtitle"]) {
        currentFields = [NSMutableDictionary new];
    }
}

-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqual:@"subtitle"]) {
        SearchModel *searchModel = [[SearchModel alloc] init];
        
        [searchModel setIndex:[currentFields objectForKey:@"id"]];
        [searchModel setMovieName:[currentFields objectForKey:@"title"]];
        [searchModel setLanguageName:[currentFields objectForKey:@"languageName"]];
        [searchModel setSubFormat:[currentFields objectForKey:@"format"]];
        
        // Setting dummy url for validation - Temporary Hack
        [searchModel setSubDownloadLink:@"http://www.podnapisi.net"];
        
        if([[currentFields objectForKey:@"release"] isEqual: @""])
            [searchModel setMovieReleaseName: [currentFields objectForKey:@"title"]];
        else
            [searchModel setMovieReleaseName:[currentFields objectForKey:@"release"]];
        
        [searchModelCollection addObject:searchModel];
        
    } else if(currentFields && currentString) {
        NSString *trimmed = [currentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [currentFields setObject:trimmed forKey:elementName];
    }
    
    currentString = nil;
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    currentString = [[NSMutableString alloc] init];
    [currentString appendString:string];
}

-(void) parserDidStartDocument:(NSXMLParser *)parser {
    [searchModelCollection removeAllObjects];
}

-(void) parserDidEndDocument:(NSXMLParser *)parser {
    
    if (searchModelCollection.count < 1) {
        [delegate didFinishProxyRequestWithIdentifier:@"Search" withData:NO];

        return;
    }
    [delegate didFinishProxyRequestWithIdentifier:@"Search" withData:searchModelCollection];
}



@end
