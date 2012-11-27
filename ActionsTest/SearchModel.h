//
//  SearchModel.h
//  ActionsTest
//
//  Created by Pawel Witkowski on 17/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovieModel.h"

@interface SearchModel : NSObject <NSCopying> {

    NSString *index;
    NSString *zipDownloadLink;
    NSString *subDownloadLink;
    NSString *subFileName;
    NSString *languageName;
    NSString *movieName;
    NSString *movieReleaseName;
    NSString *idMovie;
    NSString *subActualCD;
    NSString *subFormat;
    NSString *server;
    BOOL isZip;
}

@property (copy) NSString *index;
@property (copy) NSString *zipDownloadLink;
@property (copy) NSString *subDownloadLink;
@property (copy) NSString *subFileName;
@property (copy) NSString *languageName;
@property (copy) NSString *movieName;
@property (copy) NSString *movieReleaseName;
@property (copy) NSString *idMovie;
@property (copy) NSString *subActualCD;
@property (copy) NSString *subFormat;
@property (copy) NSString *server;
@property BOOL isZip;

+ (SearchModel *) matchByNameFromCollection:(NSArray *)collection withMovie:(MovieModel *)m;
+ (SearchModel *) initAsSingleton;
- (id)copyWithZone:(NSZone *)zone;

@end
