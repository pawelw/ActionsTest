//
//  Alerter.h
//  Subtitles Downloader
//
//  Created by Pawel Witkowski on 14/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Alerter : NSObject

+ (void) showAlertSheet:(NSString *) message andInfo:(NSString *) info;
+ (void) showNotFoundAlert;
+ (void) showNotFoundAlertForLanguage;
+ (void) showNoConnectionAlert;

@end
