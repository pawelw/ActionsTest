//
// This is a sample General preference pane
//

#import "MASPreferencesViewController.h"

extern NSString *const SDUseQuickModeKey;
extern NSString *const SDUsePreferedLanguageKey;
extern NSString *const SDPreferedLanguageKey;

@interface GeneralPreferencesViewController : NSViewController <MASPreferencesViewController> {
    NSButton *langPreferedCheckbox;
    NSMutableArray *languagesArray;
}
@property (strong) IBOutlet NSPopUpButton *langPopUpButton;
@property (strong) IBOutlet NSButton *quickModeCheckbox;
@property (strong) IBOutlet NSButton *langPreferedCheckbox;
@property (nonatomic) NSMutableArray *languagesArray;
@property (nonatomic) NSDictionary * languagesDictionary;
@property (nonatomic) BOOL comboBoxEnabled;

- (IBAction)onPreferedLangCheckboxChanged:(id)sender;
- (IBAction)onLanguagesPopUpButtonChanged:(id)sender;
- (IBAction)onUseQuickModeCheckboxChanged:(id)sender;

+ (BOOL) usePreferedLanguage;
+ (void) setUsePreferedLanguage: (BOOL) prefered;
+ (NSString *) preferedLanguage;
+ (void) setPreferedLanguage: (NSString *) language;
+ (BOOL) useQuickMode;
+ (void) setUseQuickMode: (BOOL) mode;

@end
