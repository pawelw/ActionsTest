//
// This is a sample General preference pane
//

#import "MASPreferencesViewController.h"

extern NSString *const SDUsePreferedLanguageKey;
extern NSString *const SDPreferedLanguageKey;

@interface GeneralPreferencesViewController : NSViewController <MASPreferencesViewController> {
    NSButton *langPreferedCheckbox;
}
@property (strong) IBOutlet NSButton *langPreferedCheckbox;
@property (nonatomic) BOOL comboBoxEnabled;

- (IBAction)onPreferedLangCheckboxChanged:(id)sender;
+ (BOOL) usePreferedLanguage;
+ (void) setUsePreferedLanguage: (BOOL) prefered;

+ (NSString *) preferedLanguage;
+ (void) setPreferedLanguage: (NSString *) language;

@end
