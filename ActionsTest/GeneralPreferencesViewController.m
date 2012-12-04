
#import "GeneralPreferencesViewController.h"
#import "LanguagesCollection.h"
#import "LanguageModel.h"

@implementation GeneralPreferencesViewController

@synthesize langPreferedCheckbox, languagesDictionary, languagesArray;

//NSString *const SD
NSString *const SDUsePreferedLanguageKey = @"SDUsePreferedLanguage";
NSString *const SDPreferedLanguageKey = @"SDPreferedLanguage";
NSString *const SDUseQuickModeKey = @"SDUseQuickMode";
NSString *const SDDefaultDirectory = @"SDDefaultDirectory";

- (id)init
{
    return [super initWithNibName:@"GeneralPreferencesView" bundle:nil];
}

-(void) awakeFromNib
{
    // Setting value of checkbox from user defaults database
    [langPreferedCheckbox setState:[GeneralPreferencesViewController usePreferedLanguage]];
    self.comboBoxEnabled = [GeneralPreferencesViewController usePreferedLanguage];
    
    // Setting quick mode checkbox value
    [self.quickModeCheckbox setState:[GeneralPreferencesViewController useQuickMode]];
    
    // Setting dropdown item from user defaults ( + (NSString *) preferedLanguage )
    NSArray *langKeysArray = [self.languagesDictionary allKeysForObject:[GeneralPreferencesViewController preferedLanguage]];
    [self.langPopUpButton selectItemWithTitle:[langKeysArray objectAtIndex:0]];
    
    // Setitng
    //NSString *path = [
    [self.directoryTextField setStringValue:[GeneralPreferencesViewController defaultDirectory]];
}

#pragma mark - Actions

- (IBAction)onPreferedLangCheckboxChanged:(id)sender {
    long state = [langPreferedCheckbox state];
    [GeneralPreferencesViewController setUsePreferedLanguage:state];
    
    // Binding to Eneble language combobox
    self.comboBoxEnabled = state;
}

- (IBAction)onLanguagesPopUpButtonChanged:(id)sender {
    
    NSString *key = [[self.langPopUpButton selectedItem] title];
    NSString *language = [self.languagesDictionary objectForKey:key];
    [GeneralPreferencesViewController setPreferedLanguage:language];
}

- (IBAction)onUseQuickModeCheckboxChanged:(id)sender {
    long state = [self.quickModeCheckbox state];
    [GeneralPreferencesViewController setUseQuickMode:state];
}

- (IBAction)onDefaultDirectoryPressed:(id)sender {
    //NSLog(@"%@", [GeneralPreferencesViewController defaultDirectory]);
    //NSArray *urls; = [self openFilesPanel];
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setDirectoryURL:[NSURL fileURLWithPath:[GeneralPreferencesViewController defaultDirectory]]];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setCanChooseFiles:NO];
    [openDlg beginSheetModalForWindow: self.view.window
                    completionHandler:^(NSInteger result) {
                        
                        if(result == NSOKButton) {
                           // urls = [openDlg URLs];
                            selectedFilesURLs = [openDlg URLs];
                            NSString *path = [[selectedFilesURLs objectAtIndex:0] path];
                            [self.directoryTextField setStringValue:path ];
                            [GeneralPreferencesViewController setDefaultDirectory:path];
                        } else {
                            
                        }
                    }];
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
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:SDPreferedLanguageKey];
}
//-----------------------------
+ (BOOL) useQuickMode {
    if (![GeneralPreferencesViewController usePreferedLanguage]) {
        return NO;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:SDUseQuickModeKey];
}
+ (void) setUseQuickMode: (BOOL) mode {
    [[NSUserDefaults standardUserDefaults] setBool:mode forKey:SDUseQuickModeKey];
}
//-----------------------------
+ (NSString *) defaultDirectory {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * defaultDirectory = [defaults objectForKey:SDDefaultDirectory];
    return defaultDirectory;
}
+ (void) setDefaultDirectory: (NSString *) defaultDirectory {
    //[self.directoryTextField setStringValue: defaultDirectory];
    [[NSUserDefaults standardUserDefaults] setObject:defaultDirectory forKey:SDDefaultDirectory];
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

//----------------------------

-(NSArray *) languagesArray
{
    NSArray *collection = [LanguagesCollection populate];
    NSMutableArray *objects = [NSMutableArray new];
    NSMutableArray *keys = [NSMutableArray new];
    for (LanguageModel * languageModel in collection) {
        [objects addObject:languageModel.ISO_639_2];
        [keys addObject:languageModel.name];
    }
    self.languagesDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];

    return keys;
}
@end
