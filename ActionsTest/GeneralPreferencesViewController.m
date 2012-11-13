
#import "GeneralPreferencesViewController.h"

@implementation GeneralPreferencesViewController

@synthesize langPreferedCheckbox;

//NSString *const SD
NSString *const SDUsePreferedLanguageKey = @"SDUsePreferedLanguage";
NSString *const SDPreferedLanguageKey = @"SDPreferedLanguage";

- (id)init
{
    return [super initWithNibName:@"GeneralPreferencesView" bundle:nil];
}

-(void) awakeFromNib
{
    [langPreferedCheckbox setState:[GeneralPreferencesViewController usePreferedLanguage]];
    self.comboBoxEnabled = [GeneralPreferencesViewController usePreferedLanguage];
}

#pragma mark - Actions

- (IBAction)onPreferedLangCheckboxChanged:(id)sender {
    long state = [langPreferedCheckbox state];
    [GeneralPreferencesViewController setUsePreferedLanguage:state];
    
    // Binding to Eneble language combobox
    self.comboBoxEnabled = state;
}

#pragma mark - Preferences getters and setters


//-----------------------------
+ (BOOL) usePreferedLanguage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:SDUsePreferedLanguageKey];
}
+ (void) setUsePreferedLanguage: (BOOL) prefered {
    [[NSUserDefaults standardUserDefaults] setBool:prefered forKey:SDUsePreferedLanguageKey];
}
//-----------------------------
+ (NSString *) preferedLanguage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * language = [defaults objectForKey:SDPreferedLanguageKey];
    return language;
}
+ (void) setPreferedLanguage: (NSString *) language {
    
}
//-----------------------------

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
    return @"GeneralPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"General", @"Toolbar item name for the General preference pane");
}

@end
