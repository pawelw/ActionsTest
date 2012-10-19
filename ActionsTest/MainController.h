//
//  Controller.h
//  ActionsTest
//
//  Created by Pawel Witkowski on 11/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Proxy.h"
#import "LoginModel.h"
#import "OSHashAlgorithm.h"
#import "OrderedDictionary.h"


@interface Controller : NSObject <NSApplicationDelegate, ProxyDelegate> {
    
    // Proxy class is responsible for all Webservices calls
    Proxy* proxy;
    LoginModel* loginModel;
    VideoHash hash;
    NSMutableArray *personArray;
}

@property(nonatomic, retain) NSMutableArray *personArray;
@property(nonatomic, retain) Proxy *proxy;
@property(nonatomic, retain) LoginModel *loginModel;

- (IBAction)onBrowseClicked:(id)sender;

@end
