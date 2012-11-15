//
//  AboutWindowController.m
//  Subtitles Downloader
//
//  Created by Pawel Witkowski on 15/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "AboutWindowController.h"

@implementation AboutWindowController

- (id) initWithWindowNibName:(NSString *)windowNibName
{
    if ((self = [super initWithWindowNibName:@"AboutWindow"]))
    {
        // Init code here
        [self.window setBackgroundColor:[NSColor whiteColor]];
    }
    return self;
}

@end
