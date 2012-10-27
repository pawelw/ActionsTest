//
//  SearchModel.h
//  ActionsTest
//
//  Created by Pawel Witkowski on 17/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject <NSCopying> {
    @private
    NSString *zipDownloadLink;
    NSString *languageName;
    NSString *movieName;
    NSString *movieReleaseName;
    NSString *idMovie;
    NSString *subActualCD;
}

@property (readwrite, copy) NSString *zipDownloadLink;
@property (readwrite, copy) NSString *languageName;
@property (readwrite, copy) NSString *movieName;
@property (readwrite, copy) NSString *movieReleaseName;
@property (readwrite, copy) NSString *idMovie;
@property (readwrite, copy) NSString *subActualCD;

+(SearchModel *)initAsSingleton;
-(id)copyWithZone:(NSZone *)zone;

@end
