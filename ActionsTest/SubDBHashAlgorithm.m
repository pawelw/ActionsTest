//
//  PNHashAlgorithm.m
//  Subtitles Downloader
//
//  Created by Pawel Witkowski on 22/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "SubDBHashAlgorithm.h"
#import <CommonCrypto/CommonDigest.h>

@implementation SubDBHashAlgorithm

+(NSString *)generateHashFromPath:(NSString *)path {
    const NSUInteger CHUNK_SIZE = 65536;
    
    NSError *error = nil;
    NSData *fileData = [NSData dataWithContentsOfFile:path
                                              options:NSDataReadingMapped | NSDataReadingUncached error:&error];
    
    if (error) {
        return nil;
    }
    
    const uint8_t* buffer = [fileData bytes];
    
    NSUInteger byteLength = [fileData length];
    NSUInteger byteOffset = 0;
    
    if (byteLength > CHUNK_SIZE) {
        byteOffset = byteLength - CHUNK_SIZE;
        byteLength = CHUNK_SIZE;
    }
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    
    CC_MD5_Update(&md5, buffer, (unsigned int) byteLength);
    CC_MD5_Update(&md5, buffer + byteOffset, (unsigned int) byteLength);
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5_Final(digest, &md5);
    
    NSMutableString *ret = [NSMutableString
                            stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", digest[i]];
    }
    
    return [ret lowercaseString];
}

@end
