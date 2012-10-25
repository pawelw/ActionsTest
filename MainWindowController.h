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

@interface MainWindowController : NSWindowController <NSApplicationDelegate, ProxyDelegate, NSTableViewDelegate> {
    
    NSTableView *subtitlesTable;
    NSButton *downloadButton;
    // Proxy class is responsible for all Webservices calls
    Proxy *proxy;
    LoginModel *loginModel;
    SearchModel *searchModel;
    SearchModel *selectedSubtitle;
    NSArray *selectedFilesURLs;
    VideoHash hash;
    NSMutableArray *searchModelCollection;
    NSString *movieLocalPath;
    BOOL preloaderHidden;
    NSString *preloaderLabel;
    AppDelegate *appDelegate;
    
}
@property (nonatomic, retain) IBOutlet NSButton *downloadButton;
@property(nonatomic, retain) NSMutableArray *searchModelCollection;
@property(nonatomic, retain) Proxy *proxy;
@property(nonatomic, retain) IBOutlet NSTableView *subtitlesTable;
@property(nonatomic, retain) LoginModel *loginModel;
@property(nonatomic, retain) SearchModel *searchModel;
@property (retain) IBOutlet NSArrayController* subsArrayController;
@property (nonatomic, retain) NSString *preloadeLabel;
@property BOOL preloaderHidden;

- (IBAction)onBrowseClicked:(id)sender;
- (IBAction)onDownloadClicked:(id)sender;

@end
