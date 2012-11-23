//
//  LoginModel.m
//  ActionsTest
//
//  Created by Pawel Witkowski on 17/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel
static LoginModel* _shared = nil;

@synthesize responseTime,status,token, session, loginName, password, nonce;

+ (LoginModel *) initAsSingleton
{
    @synchronized(self)
    {
        if (_shared == nil)
        {
            _shared = [[LoginModel alloc] init];
        }
    }
    return _shared;
}
@end
