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
        bgColor = [NSColor colorWithCalibratedWhite:0.2 alpha:1.0];
        borderColor = [NSColor colorWithCalibratedWhite:0.3 alpha:1.0];
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSTIFFPboardType, NSFilenamesPboardType,  nil]];
        //[self registerForDraggedTypes:[NSArray arrayWithObject:NSPasteboardTypeString]];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    

    
    
    NSRect bounds = [self bounds];
    

    
    // Draw gradient background if highlighted if (highlighted) {
    if (highlighted) {
       // NSGradient *gr;
       // gr = [[NSGradient alloc] initWithStartingColor:[NSColor blackColor] endingColor:bgColor];
       // [gr drawInRect:bounds relativeCenterPosition:NSZeroPoint];
        CGFloat insetX = NSWidth (bounds);
        CGFloat insetY = NSHeight (bounds);
        NSRect imageRect = NSInsetRect ( bounds, insetX, insetY );
        
        [self.borderColor set];
        NSBezierPath* imageFrame = [NSBezierPath bezierPathWithRect:imageRect];
        imageFrame.lineWidth = 4;
        [imageFrame stroke];
        
    } else {
        //[bgColor set];
        //[NSBezierPath fillRect:bounds];
    }
}

#pragma mark Dragging Destination

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    NSLog(@"draggingEntered:");
    if ([sender draggingSource] == self) {
        return NSDragOperationNone;
    }
    highlighted = YES;
    [self setNeedsDisplay:YES]; return NSDragOperationCopy;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender {
    NSLog(@"draggingExited:"); highlighted = NO;
    [self setNeedsDisplay:YES];
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {
     NSLog(@"preparing to draging operation:");
    return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSLog(@"perform drag operation:");
    NSPasteboard *pasteboard = [sender draggingPasteboard];
    NSArray* fileNames = [pasteboard propertyListForType:NSFilenamesPboardType];
    if ( fileNames.count < 1 ) return NO;
    for ( NSString* file in fileNames ) {
        //CBPhoto* newItem = [CBPhoto photoInDefaultContext];
        //newItem.filePath = file;
        NSLog(@"file: %@", file);
        //id url = [NSURL URLWithString:@"http://cocoabook.com/test.png"];
        fileURL = [NSURL URLWithString:file];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"logIn" object:self];
    
        
        // Send notification to the MainWindowController to call a method initLoginCall:url
        
        //hash = [OSHashAlgorithm hashForURL:url];
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

//- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
//    NSPasteboard *pboard;
//    NSDragOperation sourceDragMask;
//    
//    sourceDragMask = [sender draggingSourceOperationMask];
//    pboard = [sender draggingPasteboard];
//    
//    NSLog(@"Dragging entered");
//    
//    if ( [[pboard types] containsObject:NSColorPboardType] ) {
//        if (sourceDragMask & NSDragOperationGeneric) {
//            return NSDragOperationGeneric;
//        }
//    }
//    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
//        if (sourceDragMask & NSDragOperationLink) {
//            return NSDragOperationLink;
//        } else if (sourceDragMask & NSDragOperationCopy) {
//            return NSDragOperationCopy;
//        }
//    }
//    return NSDragOperationNone;
//}
//
//- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
//    NSPasteboard *pboard;
//    
//    pboard = [sender draggingPasteboard];
//    
//    return YES;
//}
@end
