//
// This is a sample General preference pane
//

#import "MASPreferencesViewController.h"

extern NSString *const SDUseQuickModeKey;
extern NSString *const SDUsePreferedLanguageKey;
extern NSString *const SDPreferedLanguageKey;
extern NSString *const SDDefaultDirectory;

@interface GeneralPreferencesViewController : NSViewController <MASPreferencesViewController> {
    NSButton *langPreferedCheckbox;
    NSMutableArray *languagesArray;
    NSArray * selectedFilesURLs;
}
@property (strong) IBOutlet NSPopUpButton *langPopUpButton;
@property (strong) IBOutlet NSButton *quickModeCheckbox;
@property (strong) IBOutlet NSButton *langPreferedCheckbox;
@property (nonatomic) NSMutableArray *languagesArray;
@property (strong) IBOutlet NSTextField *directoryTextField;
@property (nonatomic) NSDictionary * languagesDictionary;
@property (nonatomic) BOOL comboBoxEnabled;

- (IBAction)onPreferedLangCheckboxChanged:(id)sender;
- (IBAction)onLanguagesPopUpButtonChanged:(id)sender;
- (IBAction)onUseQuickModeCheckboxChanged:(id)sender;
- (IBAction)onDefaultDirectoryPressed:(id)sender;

+ (BOOL) usePreferedLanguage;
+ (void) setUsePreferedLanguage: (BOOL) prefered;
+ (NSString *) preferedLanguage;
+ (void) setPreferedLanguage: (NSString *) language;
- (NSString *) preferedLanguageFullName;
+ (BOOL) useQuickMode;
+ (void) setUseQuickMode: (BOOL) mode;
+ (NSString *) defaultDirectory;
+ (void) setDefaultDirectory: (NSString *) defaultDirectory;

@end
