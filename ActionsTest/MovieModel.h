//
//  MovieModel.h
//  Subtitles Downloader
//
//  Created by Pawel Witkowski on 20/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieModel : NSObject {
//    NSString *hash;
//    NSString *name;
}

@property (nonatomic, retain) NSString *hash;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSString *pathWithFileName;
@property (nonatomic, retain) NSURL *url;
@property double bytes;

@end
