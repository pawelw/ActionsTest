//
//  SubsArrayController.h
//  Subtitler
//
//  Created by Pawel Witkowski on 22/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SubsArrayController : NSArrayController {
    NSTableView *subtitlesTable;
}

@property(nonatomic, retain) IBOutlet NSTableView *subtitlesTable;
    
@end
