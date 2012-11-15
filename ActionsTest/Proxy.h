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

extern NSString *const SDOpenSubtitlesURL;
extern NSString *const SDPodnapisiURL;

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
}
@property(nonatomic, retain) NSMutableData *subtitleFileData;
@property(nonatomic, retain) XMLRPCConnectionManager *manager;
@property (nonatomic, retain) id <ProxyDelegate> delegate;
@property (nonatomic, retain) NSString *serverMode;

-(void)callWebService:(NSString *)serviceName withArguments: (NSArray *)arguments;
-(void)downloadDataFromURL:(NSURL *)url;


@end
