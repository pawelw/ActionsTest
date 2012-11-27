//
//  LanguagesModel.h
//  Subtitles Downloader
//
//  Created by Pawel Witkowski on 27/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanguageModel : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *ISO_639_1;
@property (nonatomic, retain) NSString *ISO_639_2;

@end
