//
//  ProxySubDB.m
//  Subtitles Downloader
//
//  Created by Pawel Witkowski on 22/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "ProxySubDB.h"
#import "Alerter.h"
#import "NSString+MD5.h"
#import "SubDBHashAlgorithm.h"
#import "GeneralPreferencesViewController.h"

@implementation ProxySubDB

@synthesize delegate;

-(id) init
{
    self = [super init];
    if(self)
    {
        loginModel = [LoginModel initAsSingleton];
        movieModel = [[MovieModel alloc] init];
        searchModel =[[SearchModel alloc] init];
        respondData = [[NSMutableData alloc] init];
        connectionID = [NSString new];
        languages = [NSMutableDictionary new];
    }
    
    return self;
}

-(void) login
{
    connectionID = @"login";
    
    // Get list of available languages
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.thesubdb.com/?action=languages"]];
    NSMutableURLRequest *request =[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    if (!connection) {
        NSLog(@"Connection failed");
    }
}

- (void)searchForSubtitlesWithMovie: (MovieModel *)movie
{
    movieModel = movie;
        
    connectionID = @"search";
    
    NSString *subDBhash = [SubDBHashAlgorithm generateHashFromPath:movieModel.pathWithFileName];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.thesubdb.com/?action=search&hash=%@", subDBhash]];
    NSMutableURLRequest *request =[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];

    if (!connection) {
        NSLog(@"Connection failed");
    }
}

-(void)downloadSubtitle: (SearchModel *)subtitle
{
    // TODO check if subtitle == nil;
    connectionID = @"download";
    
    NSString *languageForDownload;

    if ([GeneralPreferencesViewController usePreferedLanguage]) {
        NSString *object = [[self languagesDictionary] objectForKey:[GeneralPreferencesViewController preferedLanguage]];
        NSLog(@"[languages allKeys]: %@", [languages allKeys]);
        
        for(id key in languages){
            if(![key isEqualToString:object]){
                NSLog(@"Found");
                break;
                return;
            } 
        }
        if ([[languages allKeys] containsObject:object] == nil) {
            [Alerter showNotFoundAlertForLanguage];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hidePreloader" object:self];
            return;
        }

        languageForDownload = [[languages allKeysForObject:object] objectAtIndex:0];
        
    } else {
        languageForDownload = [[languages allKeysForObject:subtitle.languageName] objectAtIndex:0];
    }
    
    NSString *subDBhash = [SubDBHashAlgorithm generateHashFromPath:movieModel.pathWithFileName];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.thesubdb.com/?action=download&hash=%@&language=%@", subDBhash, languageForDownload ]];
    NSMutableURLRequest *request =[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if (!connection) {
        NSLog(@"Connection failed");
    }
}

#pragma mark - 
#pragma mark - NSURL protocol methods

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
    // Replace User Agent
    NSMutableURLRequest *newRequest = [request mutableCopy];
    NSString* userAgent = @"SubDB/1.0 (SubtitlesDownloader/0.1; http://)";
    [newRequest setValue:userAgent forHTTPHeaderField:@"User-Agent"];

    return newRequest;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [respondData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //[delegate fileDownloadFinishedWithData:subtitleFileData];
    
   // NSLog(@"%@", [[NSString alloc] initWithData:respondData encoding:NSUTF8StringEncoding]);
    
    if ([connectionID isEqual:@"login"]) {
        NSString *respondAsString = [[NSString alloc] initWithData:respondData encoding:NSUTF8StringEncoding];
        NSArray *langsIDs = [respondAsString  componentsSeparatedByString:@","];
        
        for (NSString* key in langsIDs) {
            if ([key isEqual:@"en"]) [languages setObject:@"English" forKey:key];
            if ([key isEqual:@"es"]) [languages setObject:@"Spanish" forKey:key];
            if ([key isEqual:@"fr"]) [languages setObject:@"French" forKey:key];
            if ([key isEqual:@"it"]) [languages setObject:@"Italian" forKey:key];
            if ([key isEqual:@"nl"]) [languages setObject:@"Dutch" forKey:key];
            if ([key isEqual:@"pl"]) [languages setObject:@"Polish" forKey:key];
            if ([key isEqual:@"pt"]) [languages setObject:@"Portuguese" forKey:key];
            if ([key isEqual:@"ro"]) [languages setObject:@"Romanian" forKey:key];
            if ([key isEqual:@"sv"]) [languages setObject:@"Swedish" forKey:key];
            if ([key isEqual:@"tr"]) [languages setObject:@"Turkish" forKey:key];
        }
        [delegate didFinishProxyRequestWithIdentifier:@"Login" withData:loginModel];
        
    } else if ([connectionID isEqual:@"search"]) {
        
        NSString *respondAsString = [[NSString alloc] initWithData:respondData encoding:NSUTF8StringEncoding];
        
        if ([respondAsString isEqual:@""]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hidePreloader" object:self];
            [Alerter showNotFoundAlert];
            return;
        }
        
        searchModelCollection = [[NSMutableArray alloc] init];
        
        NSArray *items = [respondAsString  componentsSeparatedByString:@","];
        
        for (NSString* key in items) {
            [searchModel setMovieName: movieModel.name];
            [searchModel setMovieReleaseName: movieModel.name];
            [searchModel setSubFileName: movieModel.name];
            [searchModel setZipDownloadLink: @"http://dummylinkforvalidation.org"];
            [searchModel setSubDownloadLink: @"http://dummylinkforvalidation.org"];
            [searchModel setIdMovie:@"0000"];
            [searchModel setSubActualCD:@"0000"];
            [searchModel setSubFormat:@"srt"];
            
            [searchModel setLanguageName:[languages objectForKey:key]];
            
            [searchModelCollection addObject:[searchModel copy]];
        }
        
        [delegate didFinishProxyRequestWithIdentifier:@"Search" withData:searchModelCollection]; // Custom delegate

    } else if ([connectionID isEqual:@"download"]) {
        NSString *respondAsString = [[NSString alloc] initWithData:respondData encoding:NSUTF8StringEncoding];
        
        if ([respondAsString isEqual:@""]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hidePreloader" object:self];
            [Alerter showNotFoundAlert];
            return;
        }
        
        [delegate fileDownloadFinishedWithData:respondData];
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


//----------------------------

-(NSMutableDictionary *) languagesDictionary
{
    NSArray *languagesArray = [NSArray arrayWithObjects:
                          @"All",
                          @"Arabic",
                          @"Armenian",
                          @"Malay",
                          @"Albanian",
                          @"Basque",
                          @"Bosnian",
                          @"Bulgarian",
                          @"Catalan",
                          @"Chinese",
                          @"Croatian",
                          @"Czech",
                          @"Danish",
                          @"Dutch",
                          @"English",
                          @"Esperanto",
                          @"Estonian",
                          @"Finnish",
                          @"French",
                          @"Galician",
                          @"Georgian",
                          @"German",
                          @"Greek",
                          @"Hebrew",
                          @"Hungarian",
                          @"Indonesian",
                          @"Italian",
                          @"Japanese",
                          @"Kazakh",
                          @"Korean",
                          @"Latvian",
                          @"Lithuanian",
                          @"Luxembourgish",
                          @"Macedonian",
                          @"Norwegian",
                          @"Persian",
                          @"Polish",
                          @"Portuguese (Portugal)",
                          @"Portuguese (Brazil)",
                          @"Romanian",
                          @"Russian",
                          @"Serbian",
                          @"Slovak",
                          @"Slovenian",
                          @"Spanish (Spain)",
                          @"Swedish",
                          @"Thai",
                          @"Turkish",
                          @"Ukrainian",
                          @"Vietnamese",
                          nil];
    
    NSArray *codes = [NSArray arrayWithObjects:
                      @"",
                      @"ara",
                      @"arm",
                      @"may",
                      @"alb",
                      @"baq",
                      @"bos",
                      @"bul",
                      @"cat",
                      @"chi",
                      @"hrv",
                      @"cze",
                      @"dan",
                      @"dut",
                      @"eng",
                      @"epo",
                      @"est",
                      @"fin",
                      @"fre",
                      @"glg",
                      @"geo",
                      @"nds",
                      @"gre",
                      @"heb",
                      @"hun",
                      @"ind",
                      @"ita",
                      @"jpn",
                      @"kaz",
                      @"kor",
                      @"lav",
                      @"lit",
                      @"ltz",
                      @"mac",
                      @"nor",
                      @"per",
                      @"pol",
                      @"por (Portugal)",
                      @"pob (Brazil)",
                      @"rum",
                      @"rus",
                      @"srp",
                      @"slo",
                      @"slv",
                      @"spa",
                      @"swe",
                      @"Thai",
                      @"tur",
                      @"ukr",
                      @"vie",
                      nil];
    NSMutableDictionary *languagesDictionary = [NSDictionary dictionaryWithObjects:languagesArray forKeys:codes];
    
    return languagesDictionary;
}



@end
