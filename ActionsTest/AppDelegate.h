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


MainWindowController *mainWindowController;
}

@property(nonatomic, retain) MainWindowController *mainWindowController;
@property(nonatomic, retain) NSWindow *window;

- (void)showAlertSheet:(NSString *) message andInfo:(NSString *) info;

@end
