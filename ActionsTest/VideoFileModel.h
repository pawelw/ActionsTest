//
//  VideoFileModel.h
//  ActionsTest
//
//  Created by Pawel Witkowski on 18/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoFileModel : NSObject {
    NSURL *url;
	NSString *title;
	NSString *size;
    NSString *hash;
}

+(VideoFileModel *)initAsSingleton;

@property (nonatomic) NSURL *url;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *size;
@property (nonatomic, retain) NSString *hash;

@end
