//
//  Alerter.m
//  Subtitles Downloader
//
//  Created by Pawel Witkowski on 14/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "Alerter.h"
#import "MainWindowController.h"

@implementation Alerter

+ (void)showAlertSheet:(NSString *) message andInfo:(NSString *) info {
    NSAlert *myAlert = [NSAlert alertWithMessageText:message defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:info];
    //    NSAlert *myAlert = [NSAlert alertWithMessageText:@"huj" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:nil];
    [myAlert beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

+ (void) showNotFoundAlert
{
    [self showAlertSheet:@"Subtitles not found!" andInfo:@"There is no subtitle file for this movie on the server."];
}

+ (void) showNotFoundAlertForLanguage
{
    [self showAlertSheet:@"Subtitles not found!" andInfo:@"There is no subtitle file for this movie in your prefered language on the server. To change search language go to preferences panel."];
}

+(void) showNoConnectionAlert
{
    [self showAlertSheet:@"The Internet connection appears to be offline!" andInfo:@"You must be connected to the internet in order to serach for subtitles on the server."];
}



@end
