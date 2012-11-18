//
//  NSAttributedString+Hyperlink.m
//  Subtitles Downloader
//
//  Created by Pawel Witkowski on 18/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "NSAttributedString+Hyperlink.h"

@implementation NSAttributedString (Hyperlink)

+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL
{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: inString];
    NSRange range = NSMakeRange(0, [attrString length]);
 	
    NSFont* font = [NSFont fontWithName:@"Avenir Next" size:11.0];
    NSColor *grey =[NSColor colorWithCalibratedWhite:1 alpha:1];
    
    [attrString beginEditing];
    [attrString addAttribute:NSLinkAttributeName value:[aURL absoluteString] range:range];
 	[attrString addAttribute:NSFontAttributeName value:font range:range];
    //[attrString addAttribute:NSForegroundColorAttributeName value:grey range:range];
 	
    // next make the text appear with an underline
    [attrString addAttribute: NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:range];
 	
    [attrString endEditing];
 	
    return attrString;
}

@end
