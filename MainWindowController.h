//
//  MainWindowController.h
//  ActionsTest
//
//  Created by Pawel Witkowski on 18/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Proxy.h"
#import "ProxySubDB.h"
#import "ProxyPodnapi.h"
#import "LoginModel.h"
#import "SearchModel.h"
#import "MovieModel.h"
#import "OSHashAlgorithm.h"
#import "OrderedDictionary.h"
#import "DropView.h"
#import "SubsTableRow.h"
#import "NSData+GZIP.h"
#import "DisablerView.h"

extern NSString *const SDOpenSubtitles;
extern NSString *const SDPodnapisi;
extern NSString *const SubDB;
extern NSString *serverType;

@interface MainWindowController : NSWindowController <NSApplicationDelegate, ProxyDelegate, NSTableViewDelegate> {
    
    // Outlets
    NSScrollView *scrollTableView;
    NSTableView *subtitlesTable;
    NSButton *downloadButton;
    
    // Models
    LoginModel *loginModel;
    SearchModel *searchModel;
    SearchModel *selectedSubtitle;
    MovieModel *movie;
    
    
    // Cocoa Objects
    NSMutableArray *tempArray;
    NSArray *selectedFilesURLs;
    NSMutableArray *searchModelCollection;
    NSString *preloaderLabel;
    NSMutableData * zippedSubsData;
    NSNotificationCenter *notificationCenter;
    NSString *pathWithName;
    NSData *subtitlesAsData;
    NSString *server;
    
    // Bool 
    BOOL preloaderHidden;
    BOOL _isConnected;
    BOOL isExpanded;
    
    // Classes
    id proxy;
    Proxy *proxyOpensubtitles;
    ProxyPodnapi *proxyPodnapi;
    
    VideoHash hash;
    DisablerView *disablerView;
}

@property (nonatomic, retain) IBOutlet NSButton *downloadButton;
@property (nonatomic, retain) IBOutlet NSTableView *subtitlesTable;
@property (nonatomic, retain) IBOutlet NSScrollView *scrollTableView;
@property (nonatomic, retain) IBOutlet NSArrayController* subsArrayController;
@property (nonatomic, retain) IBOutlet NSButton *expandButton;

@property (nonatomic, retain) NSMutableArray *tempArray;
@property (nonatomic, retain) NSMutableArray *searchModelCollection;
@property (nonatomic, retain) NSArray *nameSorters;
@property (nonatomic, retain) NSString *preloadeLabel;
@property (nonatomic, retain) NSMutableData *zippedSubsData;

@property (nonatomic, retain) LoginModel *loginModel;
@property (nonatomic, retain) SearchModel *searchModel;
@property (nonatomic, retain) SearchModel *selectedSubtitle;

@property (nonatomic, retain) NSString *server;
@property BOOL preloaderHidden;
@property BOOL isExpanded;
@property BOOL isConnected;

- (IBAction)onBrowseClicked:(id)sender;
- (IBAction)onInlineDownloadClicked:(id)sender; // this is connected via code not interface builder
- (IBAction)onExpandButtonClicked:(id)sender;
//-(void) alertEnded:(NSAlert *)alert code:(NSInteger)choice context:(void *)v;

@end
