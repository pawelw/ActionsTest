//
//  DropView.m
//  Subtitler
//
//  Created by Pawel Witkowski on 03/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "DropView.h"

@implementation DropView
@synthesize fileURL, borderColor;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code here.
        bgColor = [NSColor colorWithCalibratedWhite:0.05 alpha:1.0];
        borderColor = [NSColor colorWithCalibratedWhite:0.15 alpha:1.0];
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
    [bgColor set];
    [path fill];
    
    // Draw gradient background if highlighted if (highlighted) {
    if (highlighted) {
        
        [self.borderColor set];
        path.lineWidth = 4;
        [path stroke];
        
    } else {

    }

}

#pragma mark Dragging Destination

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    if ([sender draggingSource] == self) {
        return NSDragOperationNone;
    }
    highlighted = YES;
    [self setNeedsDisplay:YES]; return NSDragOperationCopy;
    
    
    //return [QTMovie canInitWithPasteboard:[sender draggingPasteboard]] ? NSDragOperationCopy : NSDragOperationNone;

}

- (void)draggingExited:(id <NSDraggingInfo>)sender {
    NSLog(@"draggingExited:"); highlighted = NO;
    [self setNeedsDisplay:YES];
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {
     NSLog(@"preparing to draging operation:");
    NSArray *files = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    
    if ([files count] == 1) {
        NSString *filepath = [files lastObject];
        if ([[filepath pathExtension] isEqualToString:@"mov"] ||
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
            highlighted = NO;
            [self setNeedsDisplay:YES];
            return NO;
        }
    } 
    
    return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSLog(@"perform drag operation:");
    NSPasteboard *pasteboard = [sender draggingPasteboard];
    NSArray* fileNames = [pasteboard propertyListForType:NSFilenamesPboardType];
    if ( fileNames.count < 1 ) return NO;
    for ( NSString* file in fileNames ) {
        fileURL = [NSURL URLFromPasteboard:pasteboard];
        [notificationCenter postNotificationName:@"logIn" object:self];
    }
    NSLog(@"Pasteboard: %@", pasteboard);
//    if(![self readFromPasteboard:pb]) {
//        NSLog(@"Error: Could not read from dragging pasteboard");
//        return NO;
//    }
    return YES;
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender {
    NSLog(@"concludeDragOperation:"); highlighted = NO;
    [self setNeedsDisplay:YES];
}



@end
