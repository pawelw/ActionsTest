//
//  VideoFileModel.m
//  ActionsTest
//
//  Created by Pawel Witkowski on 18/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "VideoFileModel.h"

@implementation VideoFileModel
@synthesize size, hash, title, url;

static VideoFileModel* _shared = nil;

+ (VideoFileModel *) initAsSingleton
{
    @synchronized(self)
    {
        if (_shared == nil)
        {
            _shared = [[VideoFileModel alloc] init];
        }
    }
    return _shared;
}

@end
