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
#import "OSHashAlgorithm.h"
#import "OrderedDictionary.h"

@interface MainWindowController : NSWindowController <NSApplicationDelegate, ProxyDelegate> {
    
    // Proxy class is responsible for all Webservices calls
    Proxy* proxy;
    LoginModel* loginModel;
    VideoHash hash;
    NSMutableArray *personArray;
}

@property(nonatomic, retain) NSMutableArray *personArray;
@property(nonatomic, retain) Proxy *proxy;
@property(nonatomic, retain) LoginModel *loginModel;

- (IBAction)onBrowseClicked:(id)sender;

@end