//
//  SearchModel.m
//  ActionsTest
//
//  Created by Pawel Witkowski on 17/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel
static SearchModel* _shared = nil;

+ (SearchModel *) initAsSingleton
{
    @synchronized(self)
    {
        if (_shared == nil)
        {
            _shared = [[SearchModel alloc] init];
        }
    }
    return _shared;
}

@end
