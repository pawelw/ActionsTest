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
    [self showAlertSheet:@"Subtitles not found!" andInfo:@"There is no subtitle file for this movie version on the server."];
}

+ (void) showNotFoundAlertForLanguage
{
    [self showAlertSheet:@"Subtitles not found!" andInfo:@"There is no subtitle file for this movie in your prefered language on the server. To change search language go to preferences panel."];
}

+(void) showNoConnectionAlert
{
    [self showAlertSheet:@"The Internet connection appears to be offline!" andInfo:@"You must be connected to the internet in order to search for subtitles on the server."];
}

+(void) showSomethingWentWrongAlert
{
    [self showAlertSheet:@"Something went wrong while trying to download subtitles." andInfo:@"There is something wrong with downloaded data from the server. Please make sure that you have active internet connection and try to search again!"];
}

-(void) askIfOverwriteFile
{
    //[self showAlertSheet:@"Subtitle file already exist in the folder" andInfo:@"Would you like to overwrite old subtitle file with new one?"];
    NSAlert *myAlert = [NSAlert alertWithMessageText:@"Subtitle file already exist!" defaultButton:@"YES" alternateButton:@"NO" otherButton:nil informativeTextWithFormat:@"Would you like to overwrite old subtitle file with new one?"];
    //    NSAlert *myAlert = [NSAlert alertWithMessageText:@"huj" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:nil];
    [myAlert beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:appDelegate.mainWindowController didEndSelector:@selector(alertEnded:code:context:) contextInfo:nil];
}



@end
