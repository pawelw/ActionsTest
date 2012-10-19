//
//  SearchModel.h
//  ActionsTest
//
//  Created by Pawel Witkowski on 17/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject {
    NSString *zipDownloadLink;
    NSString *languageName;
    NSString *movieName;
    NSString *movieReleaseName;
    NSString *idMovie;
    NSString *subActualCD;
}

@property (nonatomic, retain) NSString *zipDownloadLink;
@property (nonatomic, retain) NSString *languageName;
@property (nonatomic, retain) NSString *movieName;
@property (nonatomic, retain) NSString *movieReleaseName;
@property (nonatomic, retain) NSString *idMovie;
@property (nonatomic, retain) NSString *subActualCD;

+(SearchModel *)initAsSingleton;

@end
