//
//  PNHashAlgorithm.h
//  Subtitles Downloader
//
//  Created by Pawel Witkowski on 22/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubDBHashAlgorithm : NSObject

+ (NSString *)generateHashFromPath:(NSString *)path;

@end
