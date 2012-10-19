//
//  OSHashAlgorithm.h
//  ActionsTest
//
//  Created by Pawel Witkowski on 18/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef struct
{
	uint64_t fileHash;
	uint64_t fileSize;
} VideoHash;

@interface OSHashAlgorithm : NSObject {
    
}
+(VideoHash)hashForPath:(NSString*)path;
+(VideoHash)hashForURL:(NSURL*)url;
+(VideoHash)hashForFile:(NSFileHandle*)handle;
+(NSString*)stringForHash:(uint64_t)hash;

@end