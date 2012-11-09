//
//  SubsTableRow.h
//  Subtitler
//
//  Created by Pawel Witkowski on 09/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

@interface SubsTableRow : NSTableRowView {
@private
    BOOL mouseInside;
    NSTrackingArea *trackingArea;
    NSButton* pushButton;
    NSTimer *timer;
    
    AppDelegate *appDelegate;
}

@end
