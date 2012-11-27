//
//  LanguagesCollection.m
//  Subtitles Downloader
//
//  Created by Pawel Witkowski on 27/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "LanguagesCollection.h"
#import "LanguageModel.h"

@implementation LanguagesCollection

static LanguagesCollection* _shared = nil;

+ (LanguagesCollection *) initAsSingleton
{
    @synchronized(self)
    {
        if (_shared == nil)
        {
            _shared = [[LanguagesCollection alloc] init];
        }
    }
    return _shared;

}

+ (NSArray *) populate
{
    NSArray *names = [NSArray arrayWithObjects:
                          @"Arabic",
                          @"Armenian",
                          @"Malay",
                          @"Albanian",
                          @"Basque",
                          @"Bosnian",
                          @"Bulgarian",
                          @"Catalan",
                          @"Chinese",
                          @"Croatian",
                          @"Czech",
                          @"Danish",
                          @"Dutch",
                          @"English",
                          @"Esperanto",
                          @"Estonian",
                          @"Finnish",
                          @"French",
                          @"Galician",
                          @"Georgian",
                          @"German",
                          @"Greek",
                          @"Hebrew",
                          @"Hungarian",
                          @"Indonesian",
                          @"Italian",
                          @"Japanese",
                          @"Kazakh",
                          @"Korean",
                          @"Latvian",
                          @"Lithuanian",
                          @"Luxembourgish",
                          @"Macedonian",
                          @"Norwegian",
                          @"Persian",
                          @"Polish",
                          @"Portuguese (Portugal)",
                          @"Portuguese (Brazil)",
                          @"Romanian",
                          @"Russian",
                          @"Serbian",
                          @"Slovak",
                          @"Slovenian",
                          @"Spanish (Spain)",
                          @"Swedish",
                          @"Thai",
                          @"Turkish",
                          @"Ukrainian",
                          @"Vietnamese",
                          nil];
    
    NSArray *ISO_639_1s = [NSArray arrayWithObjects:
                           @"ar",
                           @"hy",
                           @"ms",
                           @"sq",
                           @"eu",
                           @"bos",
                           @"bg",
                           @"ca",
                           @"zh",
                           @"hr",
                           @"cs",
                           @"da",
                           @"nl",
                           @"en",
                           @"eo",
                           @"et",
                           @"fi",
                           @"fr",
                           @"gl",
                           @"ka",
                           @"de",
                           @"el",
                           @"he",
                           @"hu",
                           @"id",
                           @"it",
                           @"ja",
                           @"kk",
                           @"ko",
                           @"lv",
                           @"lt",
                           @"lb",
                           @"mk",
                           @"no",
                           @"fa",
                           @"pl",
                           @"pt",
                           @"pt",
                           @"ro",
                           @"ru",
                           @"sr",
                           @"sk",
                           @"sl",
                           @"es",
                           @"sv",
                           @"th",
                           @"tr",
                           @"uk",
                           @"vi",
                           nil];
    
    NSArray *ISO_639_2s = [NSArray arrayWithObjects:
                          @"ara",
                          @"arm",
                          @"may",
                          @"alb",
                          @"baq",
                          @"bos",
                          @"bul",
                          @"cat",
                          @"chi",
                          @"hrv",
                          @"cze",
                          @"dan",
                          @"dut",
                          @"eng",
                          @"epo",
                          @"est",
                          @"fin",
                          @"fre",
                          @"glg",
                          @"geo",
                          @"ger",
                          @"gre",
                          @"heb",
                          @"hun",
                          @"ind",
                          @"ita",
                          @"jpn",
                          @"kaz",
                          @"kor",
                          @"lav",
                          @"lit",
                          @"ltz",
                          @"mac",
                          @"nor",
                          @"per",
                          @"pol",
                          @"por",
                          @"por",
                          @"rum",
                          @"rus",
                          @"srp",
                          @"slo",
                          @"slv",
                          @"spa",
                          @"swe",
                          @"th",
                          @"tur",
                          @"ukr",
                          @"vie",
                          nil];
    //self.languages = [NSDictionary dictionaryWithObjects:codes forKeys:languages];
    
    //return languages;
    NSMutableArray *collection = [NSMutableArray new];
    
    
    if (!names.count == ISO_639_1s.count == ISO_639_2s.count) {
        NSLog(@"There is something wrong with arrays in LanguagesCollection");
        return nil;
    }
    
    int i;
    for (i=0; i<names.count; i++)  {
        LanguageModel *langueageModel = [LanguageModel new];
        langueageModel.name = [names objectAtIndex:i];
        langueageModel.ISO_639_1 = [ISO_639_1s objectAtIndex:i];
        langueageModel.ISO_639_2 = [ISO_639_2s objectAtIndex:i];
        [collection addObject:langueageModel];
    }
    
    return collection;
}

@end
