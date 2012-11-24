//
//  ProxyProtocol.h
//  Subtitles Downloader
//
//  Created by Pawel Witkowski on 24/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProxyDelegate <NSObject>

@optional
-(void) didFinishProxyRequestWithIdentifier: (NSString *)identifier withData:(id)data;
-(void) didFaultProxyRequest;
-(void) fileDownloadFinishedWithData: (NSData *) data;
-(void) connectionTimedOut;
@end

