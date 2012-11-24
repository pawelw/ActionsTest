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
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    NSAlert *myAlert = [NSAlert alertWithMessageText:message defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:info];
    
    [myAlert beginSheetModalForWindow:[appDelegate window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
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
    [self showAlertSheet:@"Something went wrong while trying to download subtitles." andInfo:@"There is something wrong with data downloaded from server. Please make sure that you have active internet connection and then try to search again!"];
}

+(void) showNoMultipleSupportAlert
{
    [self showAlertSheet:@"Sorry, no multiple search support yet!" andInfo:@"No multiple search support."];
}

+(void) askIfOverwriteFileAndDelegateTo:(id)sender withSelector:(SEL)selector
{
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    NSAlert *myAlert = [NSAlert alertWithMessageText:@"Subtitle file already exist!" defaultButton:@"Yes" alternateButton:@"No" otherButton:nil informativeTextWithFormat:@"Would you like to overwrite old subtitle file with new one?"];
    [myAlert beginSheetModalForWindow:[appDelegate window] modalDelegate:sender didEndSelector:selector contextInfo:nil];
}

+(void) showdidntMatchSubtitles:(id)sender withSelector:(SEL)selector
{
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    NSAlert *myAlert = [NSAlert alertWithMessageText:@"Hmmm, We couldn't match video file with subtitles!" defaultButton:@"OK" alternateButton:@"Concel" otherButton:nil informativeTextWithFormat:@"We show you list of available subtitles now. Please choose subtitle for download by yourself."];
    [myAlert beginSheetModalForWindow:[appDelegate window] modalDelegate:sender didEndSelector:selector contextInfo:nil];
}



@end
