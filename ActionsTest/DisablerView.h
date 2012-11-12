//
//  DisablerView.h
//  Subtitler
//
//  Created by Pawel Witkowski on 12/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DisablerView : NSView

-(void) show;
-(void) hide;

@property(nonatomic, retain) NSTextField *label;

@end
