//
//  DropView.m
//  Subtitler
//
//  Created by Pawel Witkowski on 03/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "DropView.h"
#import "Alerter.h"

NSImageView *imageView;

@implementation DropView
@synthesize fileURL, borderColor;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code here.
        bgColor = [NSColor colorWithCalibratedWhite:0.05 alpha:1.0];
        borderColor = [NSColor colorWithCalibratedWhite:0.2 alpha:1.0];
        [self registerForDraggedTypes:[NSArray arrayWithObjects: NSFilenamesPboardType,  nil]];

        // NT
        notificationCenter = [NSNotificationCenter defaultCenter];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    NSRect bounds = [self bounds];
    NSBezierPath* path = [NSBezierPath bezierPathWithRoundedRect:bounds xRadius:8 yRadius:8];
    
    // Draw gradient background if highlighted if (highlighted) {
    if (highlighted) {
        
        [self.borderColor set];
        path.lineWidth = 4;
        [path stroke];
    }
}

#pragma mark Dragging Destination

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    if ([sender draggingSource] == self) {
        return NSDragOperationNone;
    }
    highlighted = YES;
    [self setNeedsDisplay:YES]; return NSDragOperationEvery;
    
    return NSDragOperationCopy;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    highlighted = NO;
    [self setNeedsDisplay:YES];
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
    NSArray *files = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    
    if ([files count] == 1) {
        
        NSString *filepath = [files lastObject];
        
        if ([[filepath pathExtension] isEqualToString:@"mov"] ||
            [[filepath pathExtension] isEqualToString:@"MOV"] ||
            [[filepath pathExtension] isEqualToString:@"avi"] ||
            [[filepath pathExtension] isEqualToString:@"mpg"] ||
            [[filepath pathExtension] isEqualToString:@"mpeg"] ||
            [[filepath pathExtension] isEqualToString:@"mp4"] ||
            [[filepath pathExtension] isEqualToString:@"wmv"] ||
            [[filepath pathExtension] isEqualToString:@"rmvb"] ||
            [[filepath pathExtension] isEqualToString:@"asf"] ||
            [[filepath pathExtension] isEqualToString:@"divx"] ||
            [[filepath pathExtension] isEqualToString:@"mkv"])
        {
            return YES;
        } else {
            // If file is not a movie
            highlighted = NO;
            [self setNeedsDisplay:YES];
            return NO;
        }
    } else {
        // If there is multiple files dragged in to view
        highlighted = NO;
        [self setNeedsDisplay:YES];
        [Alerter showNoMultipleSupportAlert];
        return NO;
    }
    
    return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pasteboard = [sender draggingPasteboard];
    NSArray* fileNames = [pasteboard propertyListForType:NSFilenamesPboardType];

    if ( fileNames.count < 1 ) return NO;
    
    for ( NSString* file in fileNames ) {
        fileURL = [NSURL URLFromPasteboard:pasteboard];
        [notificationCenter postNotificationName:@"logIn" object:self];
    }

    return YES;
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
    highlighted = NO;
    [self setNeedsDisplay:YES];
}



@end
