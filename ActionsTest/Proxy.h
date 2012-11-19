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
#import "SearchModel.h"

@protocol ProxyDelegate
@optional
-(void) didFinishProxyRequest: (XMLRPCRequest *)request withData: (id)data;
-(void) didFaultProxyRequest;
-(void) fileDownloadFinishedWithData: (NSData *) data;
@end

@interface Proxy : NSObject <XMLRPCConnectionDelegate> {
    id <ProxyDelegate> delegate;
    XMLRPCConnectionManager *manager;
    NSMutableData *subtitleFileData;
    NSURLConnection *urlConnection;
    LoginModel *loginModel;
}
@property(nonatomic, retain) NSMutableData *subtitleFileData;
//@property(nonatomic, retain) XMLRPCConnectionManager *manager;
@property (nonatomic, retain) id <ProxyDelegate> delegate;

-(void) login;
-(void) searchByHash: (NSString *)hash andByteSize: (double) bytes;
-(void) callWebService:(NSString *)serviceName withArguments: (NSArray *)arguments;
-(void) downloadDataFromURL:(NSURL *)url;



@end
