//
//  ProxyPodnapisiXML.h
//  Subtitles Downloader
//
//  Created by Pawel Witkowski on 19/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLRPCRequest.h"
#import "LoginModel.h"
#import "SearchModel.h"

@protocol ProxyPodnapisiXMLDelegate 
@optional
//-(void) didFinishProxyRequest: (XMLRPCRequest *)request withData: (id)data;
//-(void) didFaultProxyRequest;
-(void) didFinishProxyRequestWithIdentifier: (NSString *)identifier withData:(id)data;
-(void) fileDownloadFinishedWithData: (NSData *) data;
@end

@interface ProxyPodnapisiXML : NSObject <NSXMLParserDelegate> {
    
    LoginModel *loginModel;
    NSMutableArray *searchModelCollection;
    NSMutableData *respondData;
    
    //XMLParser
    NSMutableDictionary *currentFields;
    NSMutableString *currentString;
    
}

@property (nonatomic, retain) id <ProxyPodnapisiXMLDelegate> delegate;

- (void) login;
- (void) searchWithMovieName: (NSString *) movieName;

@end
