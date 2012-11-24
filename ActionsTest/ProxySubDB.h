//
//  ProxySubDB.h
//  Subtitles Downloader
//
//  Created by Pawel Witkowski on 22/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovieModel.h"
#import "SearchModel.h"
#import "LoginModel.h"
#import "MovieModel.h"
#import "ProxyDelegate.h"

@interface ProxySubDB : NSObject <NSXMLParserDelegate> {
    
    LoginModel *loginModel;
    MovieModel *movieModel;
    SearchModel *searchModel;
    
    NSString *connectionID;
    NSMutableArray *searchModelCollection;
    NSMutableData *respondData;
    NSMutableDictionary *languages;
    
}

@property (nonatomic, retain) id <ProxyDelegate> delegate;

- (void)login;
- (void)searchForSubtitlesWithMovie: (MovieModel *)movie;
- (void)downloadSubtitle: (SearchModel *)subtitle;

@end

