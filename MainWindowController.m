//
//  MainWindowController.m
//  ActionsTest
//
//  Created by Pawel Witkowski on 18/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "MainWindowController.h"

@interface MainWindowController ()

@end

@implementation MainWindowController

@synthesize searchModelCollection, loginModel, searchModel, subtitlesTable, downloadButton, subsArrayController, preloaderHidden, preloadeLabel, nameSorters, selectedSubtitle, scrollTableView, isExpanded;

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
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(loginNotificationReceived:) name:@"logIn" object:nil];
    }
    
    
    
    
    //// DUMMY DATA
    
//    searchModel = [[SearchModel alloc] init];
//    searchModelCollection = [[NSMutableArray alloc] init];
//    
//    for (int i=0; i<10; i++) {
//        
//        [searchModel setMovieName: @"MovieName"];
//        [searchModel setZipDownloadLink: @"ZipDownloadLink"];
//        [searchModel setLanguageName: @"LanguageName"];
//        [searchModel setMovieReleaseName: @"MovieReleaseName"];
//        [searchModel setIdMovie:@"IdMovie"];
//        [searchModel setSubActualCD:@"SubActualCD"];
//        
//        // Using key setter method to activate delegation of data to NSTableView
//        [[self mutableArrayValueForKey:@"searchModelCollection"] addObject:[searchModel copy]];
//    }
    ///////////
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [scrollTableView setHidden:YES];
    [subtitlesTable setRowHeight:33];
    [self contractWindow];
    
}

-(void) initPreloader {
    self.preloaderHidden = YES;
    self.preloadeLabel = @"Connecting with server...";
}

#pragma mark - notification center methods

-(void) loginNotificationReceived: (id) object
{    
    DropView *dropView = [object valueForKey:@"object"];
    
    movieLocalPath = [dropView.fileURL path];
    NSLog(@"movieLocalPath: %@", [dropView.fileURL path]);
    selectedFilesURLs = [[NSArray alloc] initWithObjects:dropView.fileURL, nil];
    [self initLoginCall:dropView.fileURL];
    
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
    NSLog(@"movieLocalPath: %@", [[selectedFilesURLs lastObject] path]);
    movieLocalPath = [[selectedFilesURLs lastObject] path];
    [self initLoginCall:[selectedFilesURLs lastObject]];
    
}

-(void) initLoginCall: (NSURL *) url
{    
    hash = [OSHashAlgorithm hashForURL:url];
    movieLocalPath = [movieLocalPath stringByDeletingLastPathComponent];
    
    // Init Proxy
    proxy = [[Proxy alloc] init];
    [proxy setDelegate:self];
    [proxy callWebService:@"LogIn" withArguments:[NSArray arrayWithObjects: @"", @"", @"en", @"subtitler", nil]];
    
    // show preloader
    self.preloaderHidden = NO;
}


- (IBAction)onDownloadClicked:(id)sender
{
    [downloadButton setEnabled:NO];
    self.preloadeLabel = @"Downloading subtitles...";
    
    [self saveSubtitles];
}

- (IBAction)onInlineDownloadClicked:(id)sender
{
    // Find out what row it was in and edit that color with the popup
    NSInteger row = [subtitlesTable rowForView:sender];
    NSLog(@"%@", [NSNumber numberWithInteger:row]);
    
    self.preloadeLabel = @"Downloading subtitles...";
    self.preloaderHidden = NO;
    
    [self saveSubtitles];
}

- (void) saveSubtitles
{
    NSString* fileURL = [selectedSubtitle zipDownloadLink];
    NSString *pathWithName = [NSString stringWithFormat:@"%@/%@.zip",movieLocalPath ,[selectedSubtitle movieReleaseName]];
    
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    [data writeToFile:pathWithName atomically:YES];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:selectedFilesURLs];
    self.preloaderHidden = YES;
}

#pragma mark - proxy protocol methods

-(void) didFinishProxyRequest: (XMLRPCRequest *)request withResponse:(XMLRPCResponse *)response
{    
    self.preloadeLabel = @"Searching for subtitles...";
    
    if ([[request method] isEqualToString:@"LogIn"]) {
        
        loginModel = [LoginModel initAsSingleton];
        
        [loginModel setToken:[[response object] objectForKey:@"token"]];
        [loginModel setStatus:[[response object] objectForKey:@"status"]];
        [loginModel setResponseTime:[[response object] objectForKey:@"seconds"]];
        
        NSString *hashString = [OSHashAlgorithm stringForHash:hash.fileHash];
        double byteSizeString = (uint64_t) hash.fileSize;
        
        OrderedDictionary *dict = [[OrderedDictionary alloc] initWithCapacity:4];
        [dict setObject:@"" forKey:@"sublanguageid"];
        [dict setObject:hashString forKey:@"moviehash"];
        [dict setObject:[NSNumber numberWithDouble:byteSizeString] forKey:@"moviebytesize"];
        
        NSArray *arguments = [NSArray arrayWithObjects:dict, nil];
        
        [proxy callWebService:@"SearchSubtitles" withArguments:[NSArray arrayWithObjects:[loginModel token], arguments, nil]];
        
    } else if ([[request method] isEqualToString:@"SearchSubtitles"]) {
        
        self.preloaderHidden = YES;
        
        NSDictionary *responseData = [[NSDictionary alloc] init];
        responseData = [[response object] objectForKey:@"data"];
        searchModel = [[SearchModel alloc] init];
        searchModelCollection = [[NSMutableArray alloc] init];
        
        for (NSString* key in responseData) {
            
            [searchModel setMovieName: [key valueForKey:@"MovieName"]];
            [searchModel setZipDownloadLink: [key valueForKey:@"ZipDownloadLink"]];
            [searchModel setLanguageName:[key valueForKey:@"LanguageName"]];
            [searchModel setMovieReleaseName:[key valueForKey:@"MovieReleaseName"]];
            [searchModel setIdMovie:[key valueForKey:@"IdMovie"]];
            [searchModel setSubActualCD:[key valueForKey:@"SubActualCD"]];
            
            // Using key setter method to activate delegation of data to NSTableView
            [[self mutableArrayValueForKey:@"searchModelCollection"] addObject:[searchModel copy]];
        }
        
        NSLog(@"%@", [[searchModelCollection objectAtIndex:1] movieName]);
        [self expandWindow];
        [subtitlesTable setEnabled:YES];

    }
}

-(void) didFaultProxyRequest
{
    [appDelegate showAlertSheet:@"The Internet connection appears to be offline!" andInfo:@"You must be connected to the internet in order to serach for subtitles on the server."];
    self.preloaderHidden = YES;
}

#pragma mark - tableView protocol methods

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {

    NSInteger selection = subtitlesTable.selectedRow;
    
    if(selection < 0) {
        [downloadButton setEnabled:NO];
        return;
    } else {
        [downloadButton setEnabled:YES];
    }
    
    // Select elements from collections of models
    NSMutableArray* collection = [subsArrayController arrangedObjects];
    selectedSubtitle = [collection objectAtIndex:selection];
    
   // [[self valueForKey:@"selectedSubtitle"] setValue:[collection objectAtIndex:selection]];
   // [selectedSubtitle setValue:[collection objectAtIndex:selection]];
}

#pragma mark - window sizing

-(NSWindow *) expandWindow {
    
    // Make sure that table is shown
    [scrollTableView setHidden:NO];
    
    float tableWidth = 552;
    NSRect frame = [self.window frame];
    
    // Check if is not expanded already
    if(!isExpanded) {
        frame.size.width += tableWidth;
        
        if((frame.origin.x -= 200) > 210)
            frame.origin.x -= 200;
        else
            frame.origin.x = 10;
        
        isExpanded = YES;
    }
    
    [self.window setFrame: frame display:YES animate:YES];
    
    return self.window;
}

-(NSWindow *) contractWindow {
    //[appDelegate expandWindow];
    float tableWidth = 602;
    NSRect frame = [self.window frame];
    
    // Check if window is expanded
    if(isExpanded) {
        frame.size.width -= tableWidth;
        isExpanded = NO;
    }
    
    [self.window setFrame: frame display:YES animate:NO];
    
    return self.window;
}

@end
