//
//  NSView+Apperance.m
//  Subtitles Downloader
//
//  Created by Pawel Witkowski on 19/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "NSView+Apperance.h"

@implementation NSView (Apperance)

-(void) show
{
    [self setHidden:NO];
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.3];
    [[self animator] setAlphaValue:1];
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

@end
