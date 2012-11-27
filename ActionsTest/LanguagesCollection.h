//
//  LanguagesCollection.h
//  Subtitles Downloader
//
//  Created by Pawel Witkowski on 27/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanguagesCollection : NSMutableArray

@property(nonatomic, retain) NSDictionary *languages;

+ (LanguagesCollection*)initAsSingleton;
+ (NSArray *) populate;

@end
