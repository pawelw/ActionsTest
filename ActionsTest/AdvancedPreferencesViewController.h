//
// This is a sample Advanced preference pane
//

#import "MASPreferencesViewController.h"

@interface AdvancedPreferencesViewController : NSViewController <MASPreferencesViewController> {
    NSTextField *_textField;
}

@property (nonatomic, assign) IBOutlet NSTextField *textField;

@end
