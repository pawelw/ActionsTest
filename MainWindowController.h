//
//  MainWindowController.h
//  ActionsTest
//
//  Created by Pawel Witkowski on 18/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Proxy.h"
#import "LoginModel.h"
#import "SearchModel.h"
#import "OSHashAlgorithm.h"
#import "OrderedDictionary.h"

@interface MainWindowController : NSWindowController <NSApplicationDelegate, ProxyDelegate> {
    
    NSTableView *subtitlesTable;
    NSButton *downloadButton;
    // Proxy class is responsible for all Webservices calls
    Proxy *proxy;
    LoginModel *loginModel;
    SearchModel *searchModel;
    VideoHash hash;
    NSMutableArray *searchModelCollection;
}
@property (nonatomic, retain) IBOutlet NSButton *downloadButton;
@property(nonatomic, retain) NSMutableArray *searchModelCollection;
@property(nonatomic, retain) Proxy *proxy;
@property(nonatomic, retain) NSTableView *subtitlesTable;
@property(nonatomic, retain) LoginModel *loginModel;
@property(nonatomic, retain) SearchModel *searchModel;
@end
