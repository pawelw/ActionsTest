//
//  NSString+Compare.m
//  Subtitles Downloader
//
//  Created by Pawel Witkowski on 25/11/2012.
//  Copyright (c) 2012 Pawel Witkowski. All rights reserved.
//

#import "NSString+Compare.h"

@implementation NSString (Compare)

//int compare(string a, string b){
//    return(a.size() > b.size() ? bigger(a,b) : bigger(b,a));
//}

+ (int) bigger:(NSString *)a and:(NSString *)b
{
    int maxcount = 0, currentcount = 0;//used to see which set of concurrent characters were biggest
    const char *chara = [a UTF8String];
    const char *charb = [b UTF8String];
    
    for(int i = 0; i < [a length]; ++i){
        
        for(int j = 0; j < [b length]; ++j){
            
            if(chara[i+j] == charb[j]){
                
                ++currentcount;
                
            }
            
            else{
                
                if(currentcount > maxcount){
                    
                    maxcount = currentcount;
                    
                }//end if
                
                currentcount = 0;
                
            }//end else
            
        }//end inner for loop
        
    }//end outer for loop
    
    return ((int)(((float)maxcount/((float)[a length]))*100));
}


+ (int) compareString: (NSString *)a withString:(NSString *)b
{
    return([a length] > [b length] ? [self bigger:a and:b ] : [self bigger:b and:a]);
}


//int bigger(string a, string b){
//    
//    
//
//    int maxcount = 0, currentcount = 0;//used to see which set of concurrent characters were biggest
//    
//    for(int i = 0; i < a.size(); ++i){
//        
//        for(int j = 0; j < b.size(); ++j){
//            
//            if(chara[i+j] == charb[j]){
//                
//                ++currentcount;
//                
//            }
//            
//            else{
//                
//                if(currentcount > maxcount){
//                    
//                    maxcount = currentcount;
//                    
//                }//end if
//                
//                currentcount = 0;
//                
//            }//end else
//            
//        }//end inner for loop
//        
//    }//end outer for loop
//    
//    
//    return ((int)(((float)maxcount/((float)a.size()))*100));
//}

@end
