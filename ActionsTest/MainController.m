//
//  Controller.m
//  ActionsTest
//
//  Created by Pawel Witkowski on 11/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "MainController.h"

@implementation Controller

@synthesize personArray, proxy, loginModel;

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
        
    proxy = [[Proxy alloc] init];
    [proxy setDelegate:self];
    [proxy callWebService:@"LogIn" withArguments:[NSArray arrayWithObjects: @"", @"", @"en", @"subtitler", nil]];
}

#pragma mark -

-(void) didFinishProxyRequest: (XMLRPCRequest *)request {
    
    if ([[request method] isEqualToString:@"LogIn"]) {
        
        loginModel = [LoginModel initAsSingleton];
        
        NSString *hashString = [OSHashAlgorithm stringForHash:hash.fileHash];
        double byteSizeString = (uint64_t) hash.fileSize;
        
        OrderedDictionary *dict = [[OrderedDictionary alloc] initWithCapacity:4];
        [dict setObject:@"" forKey:@"sublanguageid"];
        [dict setObject:hashString forKey:@"moviehash"];
        [dict setObject:[NSNumber numberWithDouble:byteSizeString] forKey:@"moviebytesize"];

        NSArray *arguments = [NSArray arrayWithObjects:dict, nil];
        
        [proxy callWebService:@"SearchSubtitles" withArguments:[NSArray arrayWithObjects:[loginModel token], arguments, nil]];
        
    } else if ([[request method] isEqualToString:@"SearchSubtitles"]) {
        return;
    }
}

@end
