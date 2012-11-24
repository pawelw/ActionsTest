//
//  AppDelegate.h
//  ActionsTest
//
//  Created by Pawel Witkowski on 11/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;

@interface AppDelegate : NSObject <NSApplicationDelegate> {

    NSWindowController *_preferencesWindowController;
    NSWindowController *_aboutWindowController;
    MainWindowController *mainWindowController;
}

@property(nonatomic, retain) MainWindowController *mainWindowController;
@property(nonatomic, retain) NSWindow *window;
@property (nonatomic, readonly) NSWindowController *preferencesWindowController;
@property (nonatomic, readonly) NSWindowController *aboutWindowController;
@property (nonatomic, retain) NSString *server;

@property (nonatomic) NSInteger focusedAdvancedControlIndex;

- (void)showAlertSheet:(NSString *) message andInfo:(NSString *) info;
- (IBAction)openPreferences:(id)sender;
- (IBAction)openAbout:(id)sender;

@end
