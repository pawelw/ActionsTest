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
#import "ProxyDelegate.h"

@interface ProxyPodnapi : NSObject <XMLRPCConnectionDelegate, NSXMLParserDelegate> {
    id <ProxyDelegate> delegate;
    XMLRPCConnectionManager *manager;
    
    NSMutableData *subtitleFileData;
    NSURLConnection *urlConnection;
    NSMutableArray *searchModelCollection;
    NSMutableData *respondData;
    NSString *connectionID;
    
    LoginModel *loginModel;
    SearchModel *selectedSubtitle;

    //XMLParser
    NSMutableDictionary *currentFields;
    NSMutableString *currentString;
}
@property(nonatomic, retain) NSMutableData *subtitleFileData;
@property(nonatomic, retain) XMLRPCConnectionManager *manager;
@property (nonatomic, retain) id <ProxyDelegate> delegate;
@property (nonatomic, retain) NSString *serverMode;

-(void)callWebService:(NSString *)serviceName withArguments: (NSArray *)arguments;
-(void)login;
-(void)searchForSubtitlesWithMovie: (MovieModel *)movie;
-(void) downloadSubtitle:(SearchModel *)subtitle;
-(void) disconnect;


@end
