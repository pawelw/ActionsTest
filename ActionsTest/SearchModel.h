//
//  SearchModel.h
//  ActionsTest
//
//  Created by Pawel Witkowski on 17/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject <NSCopying> {

    NSString *zipDownloadLink;
    NSString *subDownloadLink;
    NSString *subFileName;
    NSString *languageName;
    NSString *movieName;
    NSString *movieReleaseName;
    NSString *idMovie;
    NSString *subActualCD;
}

@property (copy) NSString *zipDownloadLink;
@property (copy) NSString *subDownloadLink;
@property (copy) NSString *subFileName;
@property (copy) NSString *languageName;
@property (copy) NSString *movieName;
@property (copy) NSString *movieReleaseName;
@property (copy) NSString *idMovie;
@property (copy) NSString *subActualCD;

+(SearchModel *)initAsSingleton;
-(id)copyWithZone:(NSZone *)zone;

@end
