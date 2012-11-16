//
//  DropView.h
//  Subtitler
//
//  Created by Pawel Witkowski on 03/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OSHashAlgorithm.h"
#import "Proxy.h"
#import "MainWindowController.h"

@interface DropView : NSImageView {
    NSColor *bgColor;
    BOOL highlighted;
    VideoHash hash;
    Proxy *proxy;
    NSURL *fileURL;
    NSColor* borderColor;
    NSNotificationCenter *notificationCenter;
}

@property(nonatomic, retain) NSURL *fileURL;
@property (retain) NSColor* borderColor;

@end
