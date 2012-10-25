//
//  AppDelegate.h
//  ActionsTest
//
//  Created by Pawel Witkowski on 11/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;
@class PreloaderViewController;

@interface AppDelegate : NSObject <NSApplicationDelegate> {

@private
    MainWindowController *mainWindowController;
    PreloaderViewController *preloaderController;
}

@property (assign) IBOutlet NSWindow *window;
@property (retain) PreloaderViewController *preloaderController;

- (void)createErrorAlertSheet;

@end
