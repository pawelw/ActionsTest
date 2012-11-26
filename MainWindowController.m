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
#import "ZipFile.h"
#import "ZipReadStream.h"
#import "FileInZipInfo.h"
#import "NSString+Compare.h"

NSString *const SDOpenSubtitles = @"opensubtitles.org";
NSString *const SDPodnapisi = @"podnapisi.net";
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
        _server     = SDOpenSubtitles; // Set Main API server
        isExpanded  = YES;
        //appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        
        // ALLOCATIONS ////////////////////////
        searchModelCollection = [NSMutableArray new];
        movie = [MovieModel new];
        
        proxy = [self setProxyType];
        
        // DELEGATIONS /////////////////////////
        [proxy setDelegate:self];
        subtitlesTable.delegate = self;
      
        // NOTIFICATIONS //////////////////////
        notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(dropNotificationReceived:) name:@"logIn" object:nil];
        [notificationCenter addObserver:self selector:@selector(closingPreferencesReceived:) name:@"preferecncesWillClose" object:nil];
        
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

-(id) setProxyType {

    if([_server isEqual:SDOpenSubtitles]) {
        return [Proxy new];
    } else if ([_server isEqualTo:SDPodnapisi]) {
        return [ProxyPodnapi new];
    }
    return [Proxy new];
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
    
    //proxy = [self setProxyType];
    [proxy login];
}

-(void) initSearchCall
{
    hash = [OSHashAlgorithm hashForURL:movie.url];
    NSString *hashString = [OSHashAlgorithm stringForHash:hash.fileHash];
    double byteSize = (uint64_t) hash.fileSize;
    
    movie.hash = hashString;
    movie.bytes = byteSize;
    
    NSString *serverName = [NSString stringWithFormat:@"Searching %@ ...", _server];
    self.preloadeLabel = serverName;
    self.preloaderHidden = NO;
    
    [proxy searchForSubtitlesWithMovie:movie];
}

- (void) downloadSubtitles
{
    NSURL* url = [NSURL URLWithString:[selectedSubtitle subDownloadLink]];
    
    //NSAssert(url && url.scheme && url.host, @"Pawel Witkowski assertion: URL must be valid. You try to download subtitles from the server and you are pasing unvalid URL to the proxy. URL: '%@.'", url);
    
    if ([selectedSubtitle.server isEqual:SDOpenSubtitles]) {
        _server = SDOpenSubtitles;
        proxy = [Proxy new];
    } else if ([selectedSubtitle.server isEqual:SDPodnapisi]){
        _server = SDPodnapisi;
        proxy = [ProxyPodnapi new];
    }
    
    [proxy setDelegate:self];
    
    if (url && url.scheme && url.host) {
        self.preloadeLabel = @"Downloading subtitles ...";
        self.preloaderHidden = NO;
        [proxy downloadSubtitle:selectedSubtitle];
    } else {
        [Alerter showSomethingWentWrongAlert];
        [self contractWindowWithAnimation:YES];
    }
}

#pragma mark - notification center methods

-(void) restart: (id) object {
    proxy = [self setProxyType];
    [proxy setDelegate: self];
    [self initLoginCall];
}

-(void) dropNotificationReceived: (id) object
{
    [self finishConnections];
    
    NSLog(@"%@", [[object valueForKey:@"object"] fileURL]);
    NSURL *url = [[object valueForKey:@"object"] fileURL];
    NSLog(@"%@", [url path]);
    
    movie.path = [[url path] stringByDeletingLastPathComponent];
    movie.url = [[object valueForKey:@"object"] fileURL];
    movie.pathWithFileName = [movie.url path];
    movie.name = [movie.pathWithFileName lastPathComponent];
    
    selectedFilesURLs = [[NSArray alloc] initWithObjects:[[object valueForKey:@"object"] fileURL], nil];
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

-(void) finishConnections
{
    [[self mutableArrayValueForKey:@"searchModelCollection"] removeAllObjects];
    [proxy disconnect];
    self.isConnected = NO;
    _server = SDOpenSubtitles;
    [self setProxyType];
    
    // Set it again manualy ( BUG: setProxyType return ProxyPodnapi everytmime after nothing found )
    proxy = [[Proxy alloc] init];
    [proxy setDelegate:self];
}


#pragma mark - Action methods

- (IBAction)onBrowseClicked:(id)sender
{
    [self finishConnections];
    
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

                            movie.path = [[[selectedFilesURLs lastObject] path] stringByDeletingLastPathComponent];
                            movie.pathWithFileName = [[selectedFilesURLs lastObject] path];
                            movie.name = [movie.pathWithFileName lastPathComponent];
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

#pragma mark - proxy protocol methods

-(void) didFinishProxyRequestWithIdentifier: (NSString *)identifier withData:(id)data
{
    if ([identifier isEqualToString:@"Login"]) {
        
        loginModel = data;
        self.isConnected = YES;
        [self initSearchCall];
        
    } else if ([identifier isEqualToString:@"Search"]) {
        
        BOOL isFirstSearchEmpty = NO;
        if (!data) {
            NSLog(@"Nothing found");
            BOOL isFirstSearchEmpty = YES;
            [self setPreloaderHidden:YES];
            if ([_server isEqual:SDOpenSubtitles]) {
                _server = SDPodnapisi;
                [self restart:nil];
            } else if ([_server isEqual:SDPodnapisi] && isFirstSearchEmpty) {
                [GeneralPreferencesViewController usePreferedLanguage] ? [Alerter showNotFoundAlertForLanguage] : [Alerter showNotFoundAlert];
                //[self finishConnections];
            }
            return;
        }

        [self setPreloaderHidden:YES];
        
        [[self mutableArrayValueForKey:@"searchModelCollection"] addObjectsFromArray:data];

        // Search 2nd sever 
        if (![GeneralPreferencesViewController usePreferedLanguage] && [_server isEqual:SDOpenSubtitles]) {
            _server = SDPodnapisi;
            [self restart:nil];
        }
        if ([GeneralPreferencesViewController useQuickMode] && [_server isEqual:SDOpenSubtitles]){
            selectedSubtitle = [searchModelCollection objectAtIndex:0];
            
// NEED TESTING ( if in quick mode try to use a movie with the same movie release )
            
            int rank = 0;
            for (SearchModel* key in searchModelCollection) {

                NSString *a = [key movieReleaseName];
                NSString *b = [[movie.pathWithFileName lastPathComponent] stringByDeletingPathExtension];
                int result = [NSString compareString:a withString:b];

                if (rank < result) {
                    selectedSubtitle = key;
                    rank = result;
                }
            }
            
            [self downloadSubtitles];
            
        } else if ([GeneralPreferencesViewController usePreferedLanguage] && [_server isEqual:SDPodnapisi]) {
            [Alerter showdidntMatchSubtitles:self withSelector:@selector(didntMatchAlertEnded:code:context:)];
        } else if(!self.isExpanded) {
            [self expandWindow];
        } else if(self.isExpanded){
//            if ([_server isEqual:SDPodnapisi]) {
//                [Alerter showdidntMatchSubtitles:self withSelector:@selector(didntMatchAlertEnded:code:context:)];
//            }
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
    //[subtitlesTable setEnabled:YES];
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

-(void) didntMatchAlertEnded:(NSAlert *)alert code:(NSInteger)choice context:(void *)v
{
//    _server = SDPodnapisi;
    if(choice == NSAlertDefaultReturn) {
      [self expandWindow];
    } else {
        //[self finishConnections];
    }
}

-(void) saveDataFile {
    [readyToSaveData writeToFile:pathWithName atomically:YES];
    
    NSString *ext = [NSString new];
    ext = [pathWithName pathExtension];
    
    if(![ext isEqual:@"zip"]) {
        // remove zip if exist
        [self removeFileAtPath:[NSString stringWithFormat:@"%@.zip",[pathWithName stringByDeletingPathExtension]]];
        // SHow files in finder
        NSArray *urls = [NSArray arrayWithObjects:[NSURL fileURLWithPath:pathWithName], nil];
        [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:urls];
        
        return;
    }
    
    //If file is zipped need to do steps:  1.unpack saved file - 2.save unpacked files - 3.remove zip file
    ZipFile *unzipFile= [[ZipFile alloc] initWithFileName:pathWithName mode:ZipFileModeUnzip];
    NSMutableData *unzippedData = nil;
    
    NSString *zipFilePath = [[NSString alloc] initWithString:pathWithName]; //pathWithName;
    
    NSArray *infos= [unzipFile listFileInZipInfos];
    for (FileInZipInfo *zipInfo in infos) {
        
        // Locate the file in the zip
        [unzipFile locateFileInZip:zipInfo.name];
        
        // Expand the file in memory
        ZipReadStream *read= [unzipFile readCurrentFileInZip];
        [unzippedData setLength:0]; unzippedData = nil;
        unzippedData = [[NSMutableData alloc] initWithLength:zipInfo.length];
        
        int bytesRead = [read readDataWithBuffer:unzippedData];
        [read finishedReading];
        
        ext = [zipInfo.name pathExtension];
        pathWithName = [NSString stringWithFormat:@"%@.%@",[pathWithName stringByDeletingPathExtension], ext];
        
        // Write unzipped file to disc
//        NSArray *urls = [NSArray arrayWithObjects:[NSURL fileURLWithPath:subtitleName], nil];
//        [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:urls];
        BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:pathWithName];
        
        readyToSaveData = unzippedData;
        if(exist) {
            [Alerter askIfOverwriteFileAndDelegateTo:self withSelector:@selector(overwriteAlertEnded:code:context:)];
        } else {
            // Data is unpacked so run this function again
            [self saveDataFile];
            
        }
    }
    
    [unzipFile close];
    [self removeFileAtPath:[NSString stringWithFormat:@"%@.zip",[pathWithName stringByDeletingPathExtension]]];
}

-(BOOL) removeFileAtPath: (NSString *)path {
    // Remove old zip when finished
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    if (fileExists)
    {
        BOOL success = [fileManager removeItemAtPath:path error:&error];
        if (!success) NSLog(@"Error: %@", [error localizedDescription]);
    }
    
    return fileExists;
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
