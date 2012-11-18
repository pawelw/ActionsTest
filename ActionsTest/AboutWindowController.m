//
//  AboutWindowController.m
//  Subtitles Downloader
//
//  Created by Pawel Witkowski on 15/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "AboutWindowController.h"
#import "NSAttributedString+Hyperlink.h"

@implementation AboutWindowController

- (id) initWithWindowNibName:(NSString *)windowNibName
{
    if ((self = [super initWithWindowNibName:@"AboutWindow"]))
    {
        // Init code here
        [self.window setBackgroundColor:[NSColor whiteColor]];
        
       // NSURL* url = [NSURL URLWithString:@"http://www.opensubtitles.org"];
        //[NSApp openURL:url];
        
        [self.opensubtitlesTexField setAllowsEditingTextAttributes:YES];
        [self.opensubtitlesTexField setSelectable:YES];
        
        NSURL* url = [NSURL URLWithString:@"http://www.opensubtitles.org"];
        
        NSMutableAttributedString* string = [[NSMutableAttributedString alloc] init];
        [string appendAttributedString: [NSAttributedString hyperlinkFromString:@"Powered by opensubtitles.org" withURL:url]];
        
        [self.opensubtitlesTexField setAttributedStringValue: string];
    }
    return self;
}



@end
