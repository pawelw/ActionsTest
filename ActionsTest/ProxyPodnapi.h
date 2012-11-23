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
#import "MovieModel.h"
#import "SearchModel.h"
#import "AppDelegate.h"
#import "NSData+GZIP.h"
#import "SearchModel.h"

@protocol ProxyPodnapiDelegate
@optional
-(void) didFinishProxyRequestWithIdentifier: (NSString *)identifier withData:(id)data;
-(void) didFaultProxyRequest;
-(void) fileDownloadFinishedWithData: (NSData *) data;
@end

@interface ProxyPodnapi : NSObject <XMLRPCConnectionDelegate, NSXMLParserDelegate> {
    id <ProxyPodnapiDelegate> delegate;
    XMLRPCConnectionManager *manager;
    
    NSMutableData *subtitleFileData;
    NSURLConnection *urlConnection;
    NSMutableArray *searchModelCollection;
    NSMutableData *respondData;
    
    LoginModel *loginModel;

    //XMLParser
    NSMutableDictionary *currentFields;
    NSMutableString *currentString;
}
@property(nonatomic, retain) NSMutableData *subtitleFileData;
@property(nonatomic, retain) XMLRPCConnectionManager *manager;
@property (nonatomic, retain) id <ProxyPodnapiDelegate> delegate;
@property (nonatomic, retain) NSString *serverMode;

-(void)callWebService:(NSString *)serviceName withArguments: (NSArray *)arguments;
-(void)login;
-(void)searchForSubtitlesWithMovie: (MovieModel *)movie;
-(void) downloadSubtitle:(SearchModel *)subtitle;


@end
