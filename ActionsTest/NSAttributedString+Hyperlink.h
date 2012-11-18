//
//  NSAttributedString+Hyperlink.h
//  Subtitles Downloader
//
//  Created by Pawel Witkowski on 18/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Hyperlink)

+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL;

@end
