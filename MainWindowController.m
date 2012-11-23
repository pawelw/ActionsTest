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

NSString *const SDOpenSubtitles = @"opensubtitles";
NSString *const SDPodnapisi = @"podnapisi";
NSString *const SDSubDB = @"subDB";

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
        
        // CONFIGURATION //////////////////////
        _server     = SDSubDB; // Set Main API server
        isExpanded  = YES;
        appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        
        // ALLOCATIONS ////////////////////////
        searchModelCollection = [NSMutableArray new];
        movie = [MovieModel new];
        
        // PROXY //////////////////////////////
        if([_server isEqualToString:SDOpenSubtitles]) {
            proxy = [[Proxy alloc] init];
        } else if ([_server isEqualToString:SDPodnapisi]) {
            proxy = [[ProxyPodnapi alloc] init];
        } else if ([_server isEqualToString:SDSubDB]) {
            proxy = [[ProxySubDB alloc] init];
        }
        
        // DELEGATIONS /////////////////////////
        [proxy setDelegate:self];
        subtitlesTable.delegate = self;
      
        // NOTIFICATIONS //////////////////////
        notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(loginNotificationReceived:) name:@"logIn" object:nil];
        [notificationCenter addObserver:self selector:@selector(closingPreferencesReceived:) name:@"preferecncesWillClose" object:nil];
        [notificationCenter addObserver:self selector:@selector(hideLoaderReceived:) name:@"hidePreloader" object:nil];
        
//        nameSorters = [NSArray arrayWithObject:
//                       [[NSSortDescriptor alloc] initWithKey:@"movieReleaseName" ascending:YES]];

        [self initPreloader];
    }
    
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
//    [disablerView setHidden:YES]; [disablerView hide];

    [self.window setBackgroundColor:[NSColor blackColor]];
    [self contractWindowWithAnimation:NO];
    
    [subtitlesTable setRowHeight:33];
    [self.expandButton setHidden:YES];
            
    [self showWindow:nil];
}

-(void) initPreloader {
    self.preloadeLabel = @"Connecting with server ...";
    self.preloaderHidden = YES;
}

-(void) initLoginCall
{
    // show preloader
    self.preloadeLabel = @"Connecting with server ...";
    self.preloaderHidden = NO;
    
    [proxy login];
}

-(void) initSearchCall
{
    hash = [OSHashAlgorithm hashForURL:movie.url];
    NSString *hashString = [OSHashAlgorithm stringForHash:hash.fileHash];
    double byteSize = (uint64_t) hash.fileSize;
    
    movie.hash = hashString;
    movie.bytes = byteSize;
    
    self.preloadeLabel = @"Searching opensubtitles.org ...";
    self.preloaderHidden = NO;
    
    [proxy searchForSubtitlesWithMovie:movie];
}

#pragma mark - notification center methods

-(void) loginNotificationReceived: (id) object
{    
    DropView *dropView = [object valueForKey:@"object"];
    
    movie.path = [dropView.fileURL path];
    movie.url = dropView.fileURL;
    
    selectedFilesURLs = [[NSArray alloc] initWithObjects:dropView.fileURL, nil];
    self.isConnected ? [self initSearchCall] : [self initLoginCall];
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
                            
                            NSLog(@"%@", [selectedFilesURLs lastObject]);
                            
                            movie.path = [[[selectedFilesURLs lastObject] path] stringByDeletingLastPathComponent];
                            movie.pathWithFileName = [[selectedFilesURLs lastObject] path];
                            movie.name = [movie.path lastPathComponent];
                            movie.url = [selectedFilesURLs lastObject];
                            
                            self.isConnected ? [self initSearchCall] : [self initLoginCall];
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
        [proxy downloadSubtitle:selectedSubtitle];
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
        [self initSearchCall];
        
    } else if ([identifier isEqualToString:@"Search"]) {
        
        
        NSLog(@"%@", data);
        
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
    
    readyToSaveData = data;
    
    //pathWithName = [NSString stringWithFormat:@"%@/%@",movie.path ,[selectedSubtitle subFileName]];
    NSString *movieLocalName = [[movie.url lastPathComponent] stringByDeletingPathExtension];
    pathWithName = [NSString stringWithFormat:@"%@/%@.%@",movie.path ,movieLocalName, selectedSubtitle.subFormat];
    
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
    [readyToSaveData writeToFile:pathWithName atomically:YES];
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
