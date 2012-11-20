//
//  MainWindowController.m
//  ActionsTest
//
//  Created by Pawel Witkowski on 18/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "MainWindowController.h"
#import "DisablerView.h"
#import "GeneralPreferencesViewController.h"
#import "Alerter.h"

NSString *const SDOpenSubtitles = @"opensubtitles.org";
NSString *const SDPodnapisi = @"podnapisi.net";

@interface MainWindowController ()

@end

@implementation MainWindowController

@synthesize searchModelCollection, loginModel, searchModel, subtitlesTable, downloadButton, subsArrayController, preloaderHidden, preloadeLabel, nameSorters, selectedSubtitle, scrollTableView, isExpanded, tempArray, isConnected, zippedSubsData;

- (id)init {
    self = [super initWithWindowNibName:@"MainWindow"];
        
    return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    
    if (self) {
        // Initialization code here.
        _server = SDOpenSubtitles; // Set Main API server
        
        appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        subtitlesTable.delegate = self;
        // Seting YES as default because window is expanded in xib file when app starts
        isExpanded = YES;
        nameSorters = [NSArray arrayWithObject:
                       [[NSSortDescriptor alloc] initWithKey:@"movieReleaseName" ascending:YES]];
        // Add notification center observer for drop file view
        notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(loginNotificationReceived:) name:@"logIn" object:nil];
        [notificationCenter addObserver:self selector:@selector(closingPreferencesReceived:) name:@"preferecncesWillClose" object:nil];
        [notificationCenter addObserver:self selector:@selector(hideLoaderReceived:) name:@"hidePreloader" object:nil];
        
        
        // Allocations
        searchModelCollection = [[NSMutableArray alloc] init];
        
        [self initPreloader];
    }
    
    //[self showWindow:window];
    
//// DUMMY DATA FOR WORK OFFLINE
//    tempArray = [[NSMutableArray alloc] init];
//    searchModel = [[SearchModel alloc] init];
//    searchModelCollection = [[NSMutableArray alloc] init];
//    
//    for (int i=0; i<15; i++) {
//        
//        [searchModel setMovieName: @"MovieName"];
//        [searchModel setZipDownloadLink: @"ZipDownloadLink"];
//        [searchModel setLanguageName: @"LanguageName"];
//        [searchModel setMovieReleaseName: @"MovieReleaseName_xxx"];
//        [searchModel setIdMovie:@"IdMovie"];
//        [searchModel setSubActualCD:@"SubActualCD"];
//        [searchModel setSubDownloadLink:@"SubDownloadLink"];
//        
//        [[self mutableArrayValueForKey:@"searchModelCollection"] addObject:[searchModel copy]];
//    }
/////////////////////////
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Init Disable View
//    NSRect viewFrame = [scrollTableView bounds];
//    disablerView = [[DisablerView alloc] initWithFrame:viewFrame];
//    [scrollTableView addSubview:disablerView positioned:NSWindowAbove relativeTo:subtitlesTable];

    [self.window setBackgroundColor:[NSColor blackColor]];
    [self contractWindowWithAnimation:NO];
    //[disablerView setHidden:YES]; [disablerView hide];
    
    [subtitlesTable setRowHeight:33];
    [self.expandButton setHidden:YES];
            
    [self showWindow:nil];
}

-(void) initPreloader {
    [self setPreloaderHidden:YES];
    [self setPreloadeLabel: @"Connecting with server ..."];
}

-(void) initLoginCall
{
    // show preloader
    self.preloadeLabel = @"Connecting with server ...";
    self.preloaderHidden = NO;
    
    // Init Proxy
    if([_server isEqualToString:SDOpenSubtitles]) {
        proxy = [[Proxy alloc] init];
        [proxy setDelegate:self];
        [proxy login];
    } else if ([_server isEqualToString:SDPodnapisi]) {
        proxyPodnapisiXML = [[ProxyPodnapisiXML alloc] init];
        [proxyPodnapisiXML setDelegate:self];
        [proxyPodnapisiXML login];
    } 
}

-(void) initSearchCall: (NSURL *) url
{
    hash = [OSHashAlgorithm hashForURL:url];
    movieLocalPath = [movieLocalPath stringByDeletingLastPathComponent];
    NSString *hashString = [OSHashAlgorithm stringForHash:hash.fileHash];
    double byteSize = (uint64_t) hash.fileSize;
    
    [self setPreloadeLabel:@"Searching opensubtitles.org ..."];
    [self setPreloaderHidden: NO];
    
    if([_server isEqualToString:SDOpenSubtitles]) {
        [proxy searchByHash:hashString andByteSize:byteSize];
    } else if ([_server isEqualToString:SDPodnapisi]) {
        [proxyPodnapisiXML searchWithMovieName: [movieLocalPath lastPathComponent]];
    } 
    
}

#pragma mark - notification center methods

-(void) loginNotificationReceived: (id) object
{    
    DropView *dropView = [object valueForKey:@"object"];
    
    movieLocalPath = [dropView.fileURL path];
    movieLocalURL = dropView.fileURL;
    selectedFilesURLs = [[NSArray alloc] initWithObjects:dropView.fileURL, nil];
    self.isConnected ? [self initSearchCall:movieLocalURL] : [self initLoginCall];
}

-(void) closingPreferencesReceived: (id) object
{
    if (self.isExpanded && [GeneralPreferencesViewController useQuickMode])
    {
        [self contractWindowWithAnimation:YES];
    }
}

-(void) hideLoaderReceived: (id) object
{
    [self setPreloaderHidden:YES];
}

#pragma mark - Action methods

- (IBAction)onBrowseClicked:(id)sender
{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    NSArray *fileTypesArray;
    fileTypesArray = [NSArray arrayWithObjects:@"mov", @"avi", @"mpg", @"mpeg", @"mp4", @"wmv", @"rmvb", @"mkv", @"asf", @"divx", nil];
    [openDlg setCanChooseFiles:YES];
    [openDlg setDirectoryURL:[NSURL fileURLWithPath:[GeneralPreferencesViewController defaultDirectory]]];
    [openDlg setAllowedFileTypes:fileTypesArray];
    [openDlg setAllowsMultipleSelection:TRUE];
    [openDlg beginSheetModalForWindow:self.window
                    completionHandler:^(NSInteger result) {
                        
                        if(result == NSOKButton) {
                            selectedFilesURLs = [openDlg URLs];
                            if( selectedFilesURLs == nil)
                                return;
                            
                            movieLocalPath = [[selectedFilesURLs lastObject] path];
                            movieLocalURL = [selectedFilesURLs lastObject];
                            
                            self.isConnected ? [self initSearchCall:movieLocalURL] : [self initLoginCall];
                            NSLog(@"HUJ 1");
                        } else {
                            
                        }
                    }];
}

- (IBAction)onExpandButtonClicked:(id)sender
{
    isExpanded ? [self contractWindowWithAnimation:YES] : [self expandWindow];
}

- (IBAction)onInlineDownloadClicked:(id)sender
{
    //[disablerView show];
    
    // Find out what row it was in and edit that color with the popup
    NSInteger row = [subtitlesTable rowForView:sender];
    
    // Select elements from collections of models
    NSMutableArray* collection = [subsArrayController arrangedObjects];
    selectedSubtitle = [collection objectAtIndex:row];
    [self downloadSubtitles];
}

- (void) downloadSubtitles
{    
    NSURL* url = [NSURL URLWithString:[selectedSubtitle subDownloadLink]];
    
    //NSAssert(url && url.scheme && url.host, @"Pawel Witkowski assertion: URL must be valid. You try to download subtitles from the server and you are pasing unvalid URL to the proxy. URL: '%@.'", url);
    
    if (url && url.scheme && url.host) {
        self.preloadeLabel = @"Downloading subtitles ...";
        self.preloaderHidden = NO;
        [self.subtitlesTable setEnabled:NO];
        [proxy downloadDataFromURL:url];
    } else {
        [Alerter showSomethingWentWrongAlert];
         [self contractWindowWithAnimation:YES];
    }
}

#pragma mark - proxy protocol methods

-(void) didFinishProxyRequestWithIdentifier: (NSString *)identifier withData:(id)data
{
    if ([identifier isEqualToString:@"Login"]) {
        
        loginModel = data;
        self.isConnected = YES;
        [self initSearchCall:movieLocalURL];
        
    } else if ([identifier isEqualToString:@"Search"]) {
        
        [self setPreloaderHidden:YES];
        [[self mutableArrayValueForKey:@"searchModelCollection"] setArray:data];
        
        if ([GeneralPreferencesViewController useQuickMode]){
            selectedSubtitle = [searchModelCollection objectAtIndex:0];
            
// NEED TESTING ( if in quick mode try to use a movie with the same movie release )
//            for (SearchModel* key in searchModelCollection) {
//                if ([[key movieReleaseName] isEqualToString:[pathWithName lastPathComponent]])
//                {
//                    selectedSubtitle = key;
//                }
//            }
            
            [self downloadSubtitles];
        } else if(!self.isExpanded) {
            [subtitlesTable setEnabled:YES];
            [self expandWindow];
        }
    }
}

-(void) didFaultProxyRequest
{
    [Alerter showNoConnectionAlert];
    [self setPreloaderHidden:YES];
}

-(void) connectionTimedOut
{
    //[disablerView hide];
    //[disablerView.label setHidden:YES];
    [subtitlesTable setEnabled:YES];
}

-(void) fileDownloadFinishedWithData:(NSMutableData *)data
{
    if (![GeneralPreferencesViewController useQuickMode]){
        //[disablerView hide];
        //[disablerView.label setHidden:YES];
        [subtitlesTable setEnabled:YES];
    }
    [self setPreloaderHidden:YES];
    
    // Decompress data received from server
    uncompressedData = [data gunzippedData];
    pathWithName = [NSString stringWithFormat:@"%@/%@",movieLocalPath ,[selectedSubtitle subFileName]];
    NSString *ext = [pathWithName pathExtension];
    NSString *movieLocalName = [[movieLocalURL lastPathComponent] stringByDeletingPathExtension];
    pathWithName = [NSString stringWithFormat:@"%@/%@.%@",movieLocalPath ,movieLocalName, ext];
    
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:pathWithName];
    
    if(exist) {
        [Alerter askIfOverwriteFileAndDelegateTo:self withSelector:@selector(overwriteAlertEnded:code:context:)];
    } else {
        [self saveDataFile];
    }
}

#pragma mark - NSAlert Delegation

-(void) overwriteAlertEnded:(NSAlert *)alert code:(NSInteger)choice context:(void *)v
{
    if(choice == NSAlertDefaultReturn) {
        [self saveDataFile];
    }
}

-(void) saveDataFile {
    [uncompressedData writeToFile:pathWithName atomically:YES];
    NSArray *urls = [NSArray arrayWithObjects:[NSURL fileURLWithPath:pathWithName], nil];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:urls];
}

#pragma mark - tableView protocol methods

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{

}

#pragma mark - window sizing

-(NSWindow *) expandWindow {
    
    // Make sure that table is shown
    [scrollTableView setHidden:NO];
    
   // float tableWidth = 800;
    NSRect frame = [self.window frame];
    
    // Check if is not expanded already
    if(!isExpanded) {
        frame.size.width = 894;
        
        if((frame.origin.x -= 200) > 210)
            frame.origin.x -= 200;
        else
            frame.origin.x = 10;
        
        isExpanded = YES;
    }
    
    [self.window setFrame: frame display:YES animate:YES];
    
    // And at the end when expand copleted hide black diabler view
    //[disablerView hide];
    
    return self.window;
}

-(NSWindow *) contractWindowWithAnimation: (BOOL) useAnimation {
    //[appDelegate expandWindow];
    
    //[scrollTableView addSubview:disablerView positioned:NSWindowAbove relativeTo:subtitlesTable];
    //[disablerView show];
    
    NSRect frame = [self.window frame];
    
    // Check if window is expanded
    if(isExpanded) {
        frame.size.width = 299;
        isExpanded = NO;
    }
    
    [self.window setFrame: frame display:YES animate:useAnimation];
    [scrollTableView setHidden:YES];
    
    return self.window;
}

@end
