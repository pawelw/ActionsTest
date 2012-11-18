//
//  SearchModel.m
//  ActionsTest
//
//  Created by Pawel Witkowski on 17/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel
@synthesize zipDownloadLink, languageName, movieName, movieReleaseName, idMovie, subActualCD, subDownloadLink, subFileName, subFormat;

static SearchModel* _shared = nil;

-(id) init {
    if(![super init]) {
        return nil; // Bail early
    }
    return self;
}


+ (SearchModel *) initAsSingleton
{
    @synchronized(self)
    {
        if (_shared == nil)
        {
            _shared = [[SearchModel alloc] init];
        }
    }
    return _shared;
}

-(id)copyWithZone:(NSZone *)zone
{
    // We'll ignore the zone for now
    SearchModel *another = [[SearchModel alloc] init];
    another.movieName = [movieName copyWithZone: zone];
    another.zipDownloadLink = [zipDownloadLink copyWithZone: zone];
    another.subDownloadLink = [subDownloadLink copyWithZone: zone];
    another.subFileName = [subFileName copyWithZone: zone];
    another.languageName = [languageName copyWithZone: zone];
    another.movieName = [movieName copyWithZone: zone];
    another.movieReleaseName = [movieReleaseName copyWithZone: zone];
    another.idMovie = [idMovie copyWithZone: zone];
    another.subActualCD = [subActualCD copyWithZone: zone];
    another.subFormat = [subFormat copyWithZone: zone];
    
    return another;
}

@end
