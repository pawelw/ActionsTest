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

    [myAlert beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

+ (void) showNotFoundAlert
{
    [self showAlertSheet:@"Subtitles not found!" andInfo:@"Can't find suitable subtitles for this movie file."];
}

+ (void) showNotFoundAlertForLanguage
{
    [self showAlertSheet:@"Subtitles not found!" andInfo:@"Can't find suitable subtitles for this movie in your preferred language. To search in another language go to preferences panel."];
}

+(void) showNoConnectionAlert
{
    [self showAlertSheet:@"The Internet connection appears to be offline!" andInfo:@"You must be connected to the internet in order to search for subtitles on the server."];
}

+(void) showOnlyOneAtATimeAlert
{
    [self showAlertSheet:@"Please !" andInfo:@"You must be connected to the internet in order to search for subtitles on the server."];
}

+(void) showSomethingWentWrongAlert
{
    [self showAlertSheet:@"Something went wrong while trying to download subtitles." andInfo:@"There is something wrong with downloaded data from the server. Please make sure that you have active internet connection and try to search again!"];
}

+(void) showNoMultipleSupportAlert
{
    [self showAlertSheet:@"Sorry, no multiple search support yet!" andInfo:@"We will add this option for free with next update."];
}

+(void) askIfOverwriteFileAndDelegateTo:(id)sender withSelector:(SEL)selector
{
    NSAlert *myAlert = [NSAlert alertWithMessageText:@"Subtitle file already exist!" defaultButton:@"Yes" alternateButton:@"No" otherButton:nil informativeTextWithFormat:@"Would you like to overwrite old subtitle file with new one?"];
    [myAlert beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:sender didEndSelector:selector contextInfo:nil];
}



@end
