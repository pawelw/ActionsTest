//
//  SubsTableRow.h
//  Subtitler
//
//  Created by Pawel Witkowski on 09/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
#import "Proxy.h"

@interface SubsTableRow : NSTableRowView {
@private
    BOOL mouseInside;
    NSTrackingArea *trackingArea;
    NSTimer *timer;
    NSNotificationCenter *notificationCenter;
    
    AppDelegate *appDelegate;
}

@property (strong) IBOutlet NSButton *downloadButton;

@end
