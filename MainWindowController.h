//
//  MainWindowController.h
//  ActionsTest
//
//  Created by Pawel Witkowski on 18/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "Proxy.h"
#import "LoginModel.h"
#import "SearchModel.h"
#import "OSHashAlgorithm.h"
#import "OrderedDictionary.h"
#import "DropView.h"

@interface MainWindowController : NSWindowController <NSApplicationDelegate, ProxyDelegate, NSTableViewDelegate> {
    
    // Outlets
    NSScrollView *scrollTableView;
    NSTableView *subtitlesTable;
    NSButton *downloadButton;
    
    // Models
    LoginModel *loginModel;
    SearchModel *searchModel;
    SearchModel *selectedSubtitle;
    
    // Cocoa Objects
    NSArray *selectedFilesURLs;
    NSMutableArray *searchModelCollection;
    NSString *movieLocalPath;
    NSString *preloaderLabel;
    
    // Bool 
    BOOL preloaderHidden;
    
    // Classes
    Proxy *proxy;
    VideoHash hash;
    AppDelegate *appDelegate;
}

@property (unsafe_unretained) IBOutlet NSButton *inlineDownloadButton;
@property (nonatomic, retain) IBOutlet NSButton *downloadButton;
@property (nonatomic, retain) IBOutlet NSTableView *subtitlesTable;
@property (nonatomic, retain) IBOutlet NSScrollView *scrollTableView;
@property (nonatomic, retain) IBOutlet NSArrayController* subsArrayController;

@property (nonatomic, retain) NSMutableArray *searchModelCollection;
@property (nonatomic, retain) NSArray *nameSorters;
@property (nonatomic, retain) NSString *preloadeLabel;

@property (nonatomic, retain) LoginModel *loginModel;
@property (nonatomic, retain) SearchModel *searchModel;
@property (nonatomic, retain) SearchModel *selectedSubtitle;

@property BOOL preloaderHidden;
@property BOOL isExpanded;

- (IBAction)onBrowseClicked:(id)sender;
- (IBAction)onDownloadClicked:(id)sender;
- (IBAction)onInlineDownloadClicked:(id)sender;

- (void) initLoginCall: (NSURL *) url;

@end
