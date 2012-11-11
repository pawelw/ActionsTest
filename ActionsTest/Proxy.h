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
#import "NSData+GZIP.h"

@protocol ProxyDelegate
@optional
-(void) didFinishProxyRequest: (XMLRPCRequest *)request withResponse: (XMLRPCResponse *)response;
-(void) didFaultProxyRequest;
-(void) fileDownloadFinishedWithData: (NSData *) data;
@end

@interface Proxy : NSObject <XMLRPCConnectionDelegate> {
    id <ProxyDelegate> delegate;
    LoginModel *loginModel;
    XMLRPCConnectionManager *manager;
    NSMutableData *subtitleFileData;
}
@property(nonatomic, retain) LoginModel *loginModel;
@property(nonatomic, retain) NSMutableData *subtitleFileData;
@property(nonatomic, retain) XMLRPCConnectionManager *manager;
@property (nonatomic, retain) id <ProxyDelegate> delegate;

-(void)callWebService:(NSString *)serviceName withArguments: (NSArray *)arguments;
-(void)downloadDataFromURL:(NSURL *)url;


@end
