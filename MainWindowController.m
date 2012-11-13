//
//  MainWindowController.m
//  ActionsTest
//
//  Created by Pawel Witkowski on 18/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "MainWindowController.h"
#import "DisablerView.h"

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
        appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        subtitlesTable.delegate = self;
        [self initPreloader];
        
        // Seting YES as default because window is expanded in xib file when app starts
        isExpanded = YES;
        
        //[window setFrame:[] display:<#(BOOL)#>]
        
        nameSorters = [NSArray arrayWithObject:
                      [[NSSortDescriptor alloc] initWithKey:@"movieReleaseName" ascending:NO]];
        
        // Add notification center observer for drop file view
        notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(loginNotificationReceived:) name:@"logIn" object:nil];
    }
    
    //// DUMMY DATA
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
//        
//        [[self mutableArrayValueForKey:@"searchModelCollection"] addObject:[searchModel copy]];
//    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [subtitlesTable setRowHeight:33];
    [self.expandButton setHidden:YES];
    //[disablerView show];
    //[
    
    // Init Disable View
    NSRect viewFrame = [scrollTableView bounds];
    disablerView = [[DisablerView alloc] initWithFrame:viewFrame];
    [scrollTableView addSubview:disablerView positioned:NSWindowAbove relativeTo:subtitlesTable];
    
    [self contractWindowWithAnimation:NO];
}

-(void) initPreloader {
    [self setPreloaderHidden:YES];
    self.preloadeLabel = @"Connecting with server...";
}

- (IBAction)showPreferencesPanel:(id)sender
{

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

#pragma mark - general class methods

// Any ole method
-(NSArray *) openFiles
{
    // Create a File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    NSURL* movieDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSMoviesDirectory inDomains:NSUserDomainMask] objectAtIndex:0];
    
    // Set array of file types
    NSArray *fileTypesArray;
    fileTypesArray = [NSArray arrayWithObjects:@"mov", @"avi", @"mpg", @"mpeg", @"mp4", @"wmv", @"rmvb", @"mkv", @"asf", @"divx", nil];
    
    // Enable options in the dialog.
    [openDlg setCanChooseFiles:YES];
    [openDlg setDirectoryURL:movieDirectory];
    [openDlg setAllowedFileTypes:fileTypesArray];
    [openDlg setAllowsMultipleSelection:TRUE];
    
    // Display the dialog box.  If the OK pressed,
    // process the files.
    if ( [openDlg runModal] == NSOKButton ) {
        return [openDlg URLs];
    }
    return nil;
}


- (IBAction)onBrowseClicked:(id)sender
{
    selectedFilesURLs = [self openFiles];
    
    if( selectedFilesURLs == nil)
        return;
    movieLocalPath = [[selectedFilesURLs lastObject] path];
    movieLocalURL = [selectedFilesURLs lastObject];
    
    self.isConnected ? [self initSearchCall:movieLocalURL] : [self initLoginCall];
}

- (IBAction)onExpandButtonClicked:(id)sender
{
    isExpanded ? [self contractWindowWithAnimation:YES] : [self expandWindow];
}

-(void) initLoginCall
{        
    // Init Proxy
    proxy = [[Proxy alloc] init];
    [proxy setDelegate:self];
    [proxy callWebService:@"LogIn" withArguments:[NSArray arrayWithObjects: @"", @"", @"en", @"subtitler", nil]];
    
    // show preloader
    self.preloadeLabel = @"Connecting with server...";
    self.preloaderHidden = NO;
}

-(void) initSearchCall: (NSURL *) url
{
    hash = [OSHashAlgorithm hashForURL:url];
    movieLocalPath = [movieLocalPath stringByDeletingLastPathComponent];
    NSString *hashString = [OSHashAlgorithm stringForHash:hash.fileHash];
    double byteSizeString = (uint64_t) hash.fileSize;
    
    OrderedDictionary *dict = [[OrderedDictionary alloc] initWithCapacity:4];
    [dict setObject:@"" forKey:@"sublanguageid"];
    [dict setObject:hashString forKey:@"moviehash"];
    [dict setObject:[NSNumber numberWithDouble:byteSizeString] forKey:@"moviebytesize"];
    
    NSArray *arguments = [NSArray arrayWithObjects:dict, nil];
    
    self.preloadeLabel = @"Searching for subtitles...";
    self.preloaderHidden = NO;
    
    [proxy callWebService:@"SearchSubtitles" withArguments:[NSArray arrayWithObjects:[loginModel token], arguments, nil]];
}

- (IBAction)onInlineDownloadClicked:(id)sender
{
    [disablerView show];
    [disablerView.label setHidden:NO];
    // Find out what row it was in and edit that color with the popup
    NSInteger row = [subtitlesTable rowForView:sender];

    self.preloadeLabel = @"Downloading subtitles...";
    self.preloaderHidden = NO;
    [self.subtitlesTable setEnabled:NO];
    
    // Select elements from collections of models
    NSMutableArray* collection = [subsArrayController arrangedObjects];
    selectedSubtitle = [collection objectAtIndex:row];
    
    //[self contractWindowWithAnimation:YES];
    //[self.expandButton setHidden:NO];
    [scrollTableView addSubview:disablerView positioned:NSWindowAbove relativeTo:subtitlesTable];
    [disablerView show];
    
    [self saveSubtitles];
}

- (void) saveSubtitles
{
    NSURL* url = [NSURL URLWithString:[selectedSubtitle subDownloadLink]];
    [proxy downloadDataFromURL:url];
}

-(void) fileDownloadFinishedWithData:(NSMutableData *)data
{
    [disablerView hide];
    [disablerView.label setHidden:YES];
    [self setPreloaderHidden:YES];
    [subtitlesTable setEnabled:YES];
    
    // Decompress data received from server
    NSData *uncompressedData = [data gunzippedData];
    NSString *pathWithName = [NSString stringWithFormat:@"%@/%@",movieLocalPath ,[selectedSubtitle subFileName]];
    NSString *ext = [pathWithName pathExtension];
    NSString *movieLocalName = [[movieLocalURL lastPathComponent] stringByDeletingPathExtension];
    pathWithName = [NSString stringWithFormat:@"%@/%@.%@",movieLocalPath ,movieLocalName, ext];
    
    [uncompressedData writeToFile:pathWithName atomically:YES];
    
    NSArray *urls = [NSArray arrayWithObjects:[NSURL fileURLWithPath:pathWithName], nil];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:urls];
}

#pragma mark - proxy protocol methods

-(void) didFinishProxyRequest: (XMLRPCRequest *)request withResponse:(XMLRPCResponse *)response
{    

    if ([[request method] isEqualToString:@"LogIn"]) {
        
        loginModel = [LoginModel initAsSingleton];
        
        [loginModel setToken:[[response object] objectForKey:@"token"]];
        [loginModel setStatus:[[response object] objectForKey:@"status"]];
        [loginModel setResponseTime:[[response object] objectForKey:@"seconds"]];
        
        self.isConnected = YES;
        [self initSearchCall:movieLocalURL];
        
    } else if ([[request method] isEqualToString:@"SearchSubtitles"]) {
        
        [self setPreloaderHidden:YES];
        
        NSDictionary *responseData = [[NSDictionary alloc] init];
        responseData = [[response object] objectForKey:@"data"];
        
        NSString *dataAsString = [NSString stringWithFormat:@"%@", responseData];
        
        if ([dataAsString isEqualToString:@"0"]) {
            [appDelegate showAlertSheet:@"Subtitles not found!" andInfo:@"There is no subtitle file for this movie on the server."];
            return;
        } else {
            dataAsString = nil;
        }
        
        searchModel = [[SearchModel alloc] init];
        searchModelCollection = [[NSMutableArray alloc] init];
        
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
            [[self mutableArrayValueForKey:@"searchModelCollection"] addObject:[searchModel copy]];
        }
    
        if (!self.isExpanded) [self expandWindow];
       // [disablerView hide];
        [subtitlesTable setEnabled:YES];

    }
}

-(void) didFaultProxyRequest
{
    [appDelegate showAlertSheet:@"The Internet connection appears to be offline!" andInfo:@"You must be connected to the internet in order to serach for subtitles on the server."];
    [self setPreloaderHidden:YES];
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
        frame.size.width = 859;
        
        if((frame.origin.x -= 200) > 210)
            frame.origin.x -= 200;
        else
            frame.origin.x = 10;
        
        isExpanded = YES;
    }
    
    [self.window setFrame: frame display:YES animate:YES];
    [disablerView hide];
    
    
    return self.window;
}

-(NSWindow *) contractWindowWithAnimation: (BOOL) useAnimation {
    //[appDelegate expandWindow];
    
    [scrollTableView addSubview:disablerView positioned:NSWindowAbove relativeTo:subtitlesTable];
    [disablerView show];
    NSRect frame = [self.window frame];
    
    // Check if window is expanded
    if(isExpanded) {
        frame.size.width = 295;
        isExpanded = NO;
    }
    
    [self.window setFrame: frame display:YES animate:useAnimation];
    [scrollTableView setHidden:YES];
    
    return self.window;
}

@end
