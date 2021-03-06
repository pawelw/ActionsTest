//
//  Alerter.h
//  Subtitles Downloader
//
//  Created by Pawel Witkowski on 14/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

@interface Alerter : NSObject {
    AppDelegate *appDelegate;
}

+ (void) showAlertSheet:(NSString *) message andInfo:(NSString *) info;
+ (void) showNotFoundAlert;
+ (void) showNotFoundAlertForLanguage;
+ (void) showNoConnectionAlert;
+ (void) showSomethingWentWrongAlert;
+ (void) showNoMultipleSupportAlert;

+ (void) askIfOverwriteFileAndDelegateTo:(id)sender withSelector:(SEL)selector;
+ (void) showdidntMatchSubtitles:(id)sender withSelector:(SEL)selector;

@end
