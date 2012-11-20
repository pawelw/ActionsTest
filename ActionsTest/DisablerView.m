//
//  DisablerView.m
//  Subtitler
//
//  Created by Pawel Witkowski on 12/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "DisablerView.h"

@implementation DisablerView

@synthesize label;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
//        NSRect frameRect = NSMakeRect(175,100,600,140);
//        NSFont* font = [NSFont fontWithName:@"Avenir Next" size:28.0];
//        label = [[NSTextField alloc] initWithFrame:frameRect];
//        [label setTextColor:[NSColor colorWithCalibratedWhite:.5 alpha:1.0]];
//        [label setBordered:NO];
//        [label setStringValue:@"Downloading..."];
//        [label setFont:font];
//        [label setBackgroundColor:[NSColor colorWithCalibratedWhite:0 alpha:0.0]];
//        [label setHidden:NO];
//        [self addSubview:label];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    NSColor* backgroundColor = [NSColor colorWithCalibratedWhite:0 alpha:1.0];
    NSRect bounds = self.bounds;
    [backgroundColor set];
    NSRectFill (bounds);
}

-(void) show
{
    [self setHidden:NO];
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.3];
    [[self animator] setAlphaValue:0.8];
    [NSAnimationContext endGrouping];
}

-(void) hide
{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context){
        // Start some animations.
        [[NSAnimationContext currentContext] setDuration:0.3];
        [[self animator] setAlphaValue:0.0];
    } completionHandler:^{
        // This block will be invoked when all of the animations
        // started above have completed or been cancelled.
        [self setHidden:YES];
    }];
}

-(void)onShowCompleted
{
    
}


@end
