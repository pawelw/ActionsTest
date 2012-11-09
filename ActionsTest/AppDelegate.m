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

@synthesize mainWindowController;

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


- (void)showAlertSheet:(NSString *) message andInfo:(NSString *) info {
    NSAlert *myAlert = [NSAlert alertWithMessageText:message defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:info];
//    NSAlert *myAlert = [NSAlert alertWithMessageText:@"huj" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:nil];
    [myAlert beginSheetModalForWindow:mainWindowController.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}



@end
