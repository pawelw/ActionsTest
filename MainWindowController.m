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

@synthesize personArray, proxy, loginModel, searchModel;

- (id)init {
    self = [super initWithWindowNibName:@"MainWindow"];
    return self;
}
- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    NSLog(@"windowDidLoad");
    [super windowDidLoad];
    
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
    NSArray *urls = [self openFiles];
    
    hash = [OSHashAlgorithm hashForURL:[urls lastObject]];
    
    // Init Proxy
    proxy = [[Proxy alloc] init];
    [proxy setDelegate:self];
    [proxy callWebService:@"LogIn" withArguments:[NSArray arrayWithObjects: @"", @"", @"en", @"subtitler", nil]];
}

#pragma mark -

-(void) didFinishProxyRequest: (XMLRPCRequest *)request withResponse:(XMLRPCResponse *)response {
    
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

        searchModel = [SearchModel initAsSingleton];
        NSDictionary *responseData = [[NSDictionary alloc] init];
        NSMutableArray *searchModelCollection = [[NSMutableArray alloc] init];
        
        responseData = [[response object] objectForKey:@"data"];
        
        for (NSString* key in responseData) {
            
            [searchModel setMovieName: [responseData valueForKey:@"MovieName"]];
            [searchModel setZipDownloadLink: [responseData valueForKey:@"zipDownloadLink"]];
            [searchModel setLanguageName:[responseData valueForKey:@"languageName"]];
            [searchModel setMovieName:[responseData valueForKey:@"MovieName"]];
            [searchModel setMovieReleaseName:[responseData valueForKey:@"movieReleaseName"]];
            [searchModel setIdMovie:[responseData valueForKey:@"idMovie"]];
            [searchModel setSubActualCD:[responseData valueForKey:@"subActualCD"]];
            [searchModelCollection addObject:searchModel];
        }

        return;
    }
}


@end
