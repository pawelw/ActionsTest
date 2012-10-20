//
//  DownloadViewController.h
//  ActionsTest
//
//  Created by Pawel Witkowski on 20/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DownloadViewController : NSViewController <NSTableViewDelegate, NSApplicationDelegate> {
    NSTableView *subtitlesTable;
}
    
@property(nonatomic, retain) IBOutlet NSTableView *subtitlesTable;

@end
