//
//  NSData+SHA256.h
//  Subtitles Downloader
//
//  Created by Pawel Witkowski on 22/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SHA256)

 + (NSString*) sha256:(NSString *)clear;

@end
