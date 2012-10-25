//
//  AppDelegate.m
//  ActionsTest
//
//  Created by Pawel Witkowski on 11/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindowController.h"

@implementation AppDelegate

@synthesize window, preloaderController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

-(void) awakeFromNib {
    if (!mainWindowController) {
        mainWindowController = [[MainWindowController alloc] init];
    }
     [mainWindowController showWindow:nil];
}

- (void)createErrorAlertSheet {
    NSAlert *myAlert = [NSAlert alertWithMessageText:@"It appears that you have no internet connection" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:nil];
    [myAlert beginSheetModalForWindow:window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}


@end
