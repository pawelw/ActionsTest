//
//  SubsTableRow.m
//  Subtitler
//
//  Created by Pawel Witkowski on 09/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "SubsTableRow.h"

@interface SubsTableRow ()
@property BOOL mouseInside;
@end

@implementation SubsTableRow

@dynamic mouseInside;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        NSRect frame = NSMakeRect((self.bounds.origin.x + self.bounds.size.width + 128), 3, 88, 29);
        
        pushButton = [[NSButton alloc] initWithFrame: frame];
        pushButton.bezelStyle = NSInlineBezelStyle;
        pushButton.image = [NSImage imageNamed:@"download_green_2"];
        pushButton.title = @"Download";
        pushButton.target = appDelegate.mainWindowController;
        pushButton.action = @selector(onInlineDownloadClicked:);
        [pushButton setHidden:YES];
        [self addSubview:pushButton];
    }
    
    return self;
}

- (void)setMouseInside:(BOOL)value {
    if (mouseInside != value) {
        mouseInside = value;
        
        if(!value)
            [self hideDownloadButton];
        else
            timer = [NSTimer scheduledTimerWithTimeInterval: .15 target: self selector: @selector(showDownloadButton) userInfo: nil repeats: NO];
        [self setNeedsDisplay:YES];
    }
}

-(void) hideDownloadButton
{
    [timer invalidate];
    [pushButton setHidden:YES];
}

-(void) showDownloadButton
{
    [pushButton setHidden:NO];
}

- (BOOL)mouseInside {
    return mouseInside;
}

- (void)ensureTrackingArea {
    if (trackingArea == nil) {
        trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:NSTrackingInVisibleRect | NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
    }
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    [self ensureTrackingArea];
    if (![[self trackingAreas] containsObject:trackingArea]) {
        [self addTrackingArea:trackingArea];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    self.mouseInside = YES;
}

- (void)mouseExited:(NSEvent *)theEvent {
    self.mouseInside = NO;
}

static NSGradient *gradientWithTargetColor(NSColor *targetColor) {
    NSArray *colors = [NSArray arrayWithObjects:[targetColor colorWithAlphaComponent:0], targetColor, nil];
    const CGFloat locations[4] = { 0.0, 1.0 };
    return [[NSGradient alloc] initWithColors:colors atLocations:locations colorSpace:[NSColorSpace sRGBColorSpace]];
}

- (void)drawBackgroundInRect:(NSRect)dirtyRect {
    // Custom background drawing. We don't call super at all.
    [self.backgroundColor set];
    // Fill with the background color first
    NSRectFill(self.bounds);
    
    // Draw a white/alpha gradient
    if (self.mouseInside) {
        NSGradient *gradient = gradientWithTargetColor([NSColor colorWithSRGBRed:.80 green:.80 blue:.80 alpha:.3]);
        [gradient drawInRect:self.bounds angle:0];
    }
}

@end
