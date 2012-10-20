//
//  DownloadViewController.m
//  ActionsTest
//
//  Created by Pawel Witkowski on 20/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "DownloadViewController.h"

@interface DownloadViewController ()

@end

@implementation DownloadViewController

@synthesize subtitlesTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    NSLog(@"Selection did change from sub controller");
}

@end
