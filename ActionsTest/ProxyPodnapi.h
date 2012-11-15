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
#import "SearchModel.h"

@protocol ProxyPodnapiDelegate
@optional
-(void) didFinishProxyRequest: (XMLRPCRequest *)request withData: (id)data;
-(void) didFaultProxyRequest;
-(void) fileDownloadFinishedWithData: (NSData *) data;
@end

@interface ProxyPodnapi : NSObject <XMLRPCConnectionDelegate> {
    id <ProxyPodnapiDelegate> delegate;
    XMLRPCConnectionManager *manager;
    NSMutableData *subtitleFileData;
    NSURLConnection *urlConnection;
    LoginModel *loginModel;
}
@property(nonatomic, retain) NSMutableData *subtitleFileData;
@property(nonatomic, retain) XMLRPCConnectionManager *manager;
@property (nonatomic, retain) id <ProxyPodnapiDelegate> delegate;
@property (nonatomic, retain) NSString *serverMode;

-(void)callWebService:(NSString *)serviceName withArguments: (NSArray *)arguments;
-(void)downloadDataFromURL:(NSURL *)url;
-(void)login;
-(void)searchByHash: (NSString *) hash;


@end
