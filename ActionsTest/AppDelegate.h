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

@private
    MainWindowController *mainWindowController;
}

- (void)showAlertSheet:(NSString *) message andInfo:(NSString *) info;

@end
