//
//  AppDelegate.m
//  ActionsTest
//
//  Created by Pawel Witkowski on 11/10/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindowController.h"
#import "DisablerView.h"
#import "MASPreferencesWindowController.h"
#import "GeneralPreferencesViewController.h"
#import "AboutWindowController.h"
#import "MovieModel.h"

@implementation AppDelegate

@synthesize mainWindowController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
//    NSDictionary * allObjects;
//    NSString     * key;
//    
//    allObjects = [ [ NSUserDefaults standardUserDefaults ] dictionaryRepresentation ];
//    
//    for( key in allObjects )
//    {
//        [ [ NSUserDefaults standardUserDefaults ] removeObjectForKey: key ];
//    }
//    
//    [ [ NSUserDefaults standardUserDefaults ] synchronize ];
    
    // Insert code here to initialize your applications
    self.window = mainWindowController.window;
    
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:SDUsePreferedLanguageKey];
    [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:SDUseQuickModeKey];
    
    //NSURL* movieDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] objectAtIndex:0];
    // Using hardcoded /movis path because sandbox returns diferet path ( yur aplication folder )
    [defaultValues setObject:@"/Movies" forKey:SDDefaultDirectory];
    
    [defaultValues setObject:@"eng" forKey:SDPreferedLanguageKey];
    
    // Register the dictionary of defaults
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

-(void) awakeFromNib {
    if (!mainWindowController) {
        mainWindowController = [[MainWindowController alloc] init];
    }
     [mainWindowController showWindow:nil];
}

-(void) application:(NSApplication *)sender openFiles:(NSArray *)filenames
{
    MovieModel *movie = [MovieModel new];
    
    if (filenames.count < 1) {
        NSLog(@"No files selected. URLs array is empty");
        return;
    }
    
    movie.pathWithFileName = [NSString stringWithString:[filenames objectAtIndex:0]];
    movie.path = [movie.pathWithFileName stringByDeletingLastPathComponent];
    movie.url = [[NSURL alloc] initFileURLWithPath:movie.pathWithFileName];
    movie.name = [movie.pathWithFileName lastPathComponent];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:movie,@"movie", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"beginConnection" object:self userInfo:options];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}


//- (void)showAlertSheet:(NSString *) message andInfo:(NSString *) info {
//    NSAlert *myAlert = [NSAlert alertWithMessageText:message defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:info];
////    NSAlert *myAlert = [NSAlert alertWithMessageText:@"huj" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:nil];
//    [myAlert beginSheetModalForWindow:mainWindowController.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
//}

- (IBAction)openAbout:(id)sender
{
    _aboutWindowController = [[AboutWindowController alloc] initWithWindowNibName:@"AboutWindow"];
    [_aboutWindowController.window makeKeyAndOrderFront:nil];
}

#pragma mark - Preferences 

- (IBAction)openPreferences:(id)sender
{
    [self.preferencesWindowController showWindow:nil];
}

- (NSWindowController *)preferencesWindowController
{
    if (_preferencesWindowController == nil)
    {
        NSViewController *generalViewController = [[GeneralPreferencesViewController alloc] init];
        //NSViewController *advancedViewController = [[AdvancedPreferencesViewController alloc] init];
        NSArray *controllers = [[NSArray alloc] initWithObjects:generalViewController, nil];
        
        // To add a flexible space between General and Advanced preference panes insert [NSNull null]:
        //     NSArray *controllers = [[NSArray alloc] initWithObjects:generalViewController, [NSNull null], advancedViewController, nil];
        
        NSString *title = NSLocalizedString(@"Preferences", @"Common title for Preferences window");
        _preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers title:title];
    }
    return _preferencesWindowController;
}

#pragma mark -

NSString *const kFocusedAdvancedControlIndex = @"FocusedAdvancedControlIndex";

- (NSInteger)focusedAdvancedControlIndex
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kFocusedAdvancedControlIndex];
}

- (void)setFocusedAdvancedControlIndex:(NSInteger)focusedAdvancedControlIndex
{
    [[NSUserDefaults standardUserDefaults] setInteger:focusedAdvancedControlIndex forKey:kFocusedAdvancedControlIndex];
}

- (void) setServer:(NSString * )s {
    mainWindowController.server = s;
}
- (NSString *) server{
    return mainWindowController.server;
}



@end
