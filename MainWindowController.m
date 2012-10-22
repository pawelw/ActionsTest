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

@synthesize searchModelCollection, proxy, loginModel, searchModel, subtitlesTable, downloadButton, subsArrayController;

- (id)init {
    self = [super initWithWindowNibName:@"MainWindow"];
    
    return self;
}
- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    //[window setBackgroundColor:[NSColor colorWithPatternImage:[NSImage imageNamed:@"bg.png"]]];
    if (self) {
        // Initialization code here.
        NSLog(@"Setting bg");
        
        NSImage *bg = [NSImage imageNamed:@"bg.png"];
        [[window contentView] setWantsLayer:YES];
        [[window contentView] layer].contents = bg;
    }
    
    return self;
}

- (void)windowDidLoad
{
    NSLog(@"windowDidLoad");
    [super windowDidLoad];
    subtitlesTable.delegate = self;
}

// Any ole method
-(NSArray *) openFiles
{
    // Create a File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Set array of file types
    NSArray *fileTypesArray;
    fileTypesArray = [NSArray arrayWithObjects:@"mov", @"avi", @"mpg", @"mp4", nil];
    
    // Enable options in the dialog.
    [openDlg setCanChooseFiles:YES];
    [openDlg setAllowedFileTypes:fileTypesArray];
    [openDlg setAllowsMultipleSelection:TRUE];
    
    // Display the dialog box.  If the OK pressed,
    // process the files.
    if ( [openDlg runModal] == NSOKButton ) {
        return [openDlg URLs];
    }
    return nil;
}

- (IBAction)onBrowseClicked:(id)sender {
    selectedFilesURLs = [self openFiles];
    
    if( selectedFilesURLs == nil)
        return;
    
    hash = [OSHashAlgorithm hashForURL:[selectedFilesURLs lastObject]];
    movieLocalPath = [[selectedFilesURLs lastObject] path];
    movieLocalPath = [movieLocalPath stringByDeletingLastPathComponent];
    
    // Init Proxy
    proxy = [[Proxy alloc] init];
    [proxy setDelegate:self];
    [proxy callWebService:@"LogIn" withArguments:[NSArray arrayWithObjects: @"", @"", @"en", @"subtitler", nil]];
}

#pragma mark -

-(void) didFinishProxyRequest: (XMLRPCRequest *)request withResponse:(XMLRPCResponse *)response {
    
    NSLog(@"hujek: %@", self);
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
        
        //[[self mutableArrayValueForKey:@"searchModelCollection"] addObjectsFromArray:[temp copy]];
        [subtitlesTable setEnabled:YES];
    }
}

#pragma mark -

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
}

- (IBAction)onDownloadClicked:(id)sender {
    [downloadButton setEnabled:NO];
    [self saveSubtitles];
}

- (void) saveSubtitles {
    NSString* fileToSaveTo = [selectedSubtitle movieReleaseName];
    NSString* fileURL = [selectedSubtitle zipDownloadLink];
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    [data writeToFile:[NSString stringWithFormat:@"%@/%@.zip",movieLocalPath ,fileToSaveTo] atomically:YES];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:selectedFilesURLs];
}

@end
