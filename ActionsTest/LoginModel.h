//
//  LoginModel.h
//  ActionsTest
//
//  Created by Pawel Witkowski on 17/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//
// This is singeton Class

#import <Foundation/Foundation.h>


@interface LoginModel : NSObject {
    NSString *responseTime;
	NSString *status;
	NSString *token;
    NSString *session;
}

@property (nonatomic, retain) NSString *responseTime;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *session;

+(LoginModel*)initAsSingleton;

@end
