//
//  Proxy.h
//  ActionsTest
//
//  Created by Pawel Witkowski on 17/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLRPCRequest.h"
#import "XMLRPCConnectionManager.h"
#import "XMLRPCResponse.h"
#import "LoginModel.h"
#import "AppDelegate.h"

@protocol ProxyDelegate
@optional
-(void) didFinishProxyRequest: (XMLRPCRequest *)request;
@end

@interface Proxy : NSObject <XMLRPCConnectionDelegate> {
    id <ProxyDelegate> delegate;
    LoginModel *loginModel;
    XMLRPCConnectionManager *manager;
}
@property(nonatomic, retain) LoginModel *loginModel;
@property(nonatomic, retain) XMLRPCConnectionManager *manager;
@property (nonatomic, retain) id <ProxyDelegate> delegate;

-(void)callWebService:(NSString *)serviceName withArguments: (NSArray *)arguments;


@end
