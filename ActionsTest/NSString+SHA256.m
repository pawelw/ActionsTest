//
//  NSData+SHA256.m
//  Subtitles Downloader
//
//  Created by Pawel Witkowski on 22/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "NSString+SHA256.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (SHA256)

+ (NSString*) sha256:(NSString *)clear{
    const char *s=[clear cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, keyData.length, digest);
    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash=[out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    return hash;
}

@end
