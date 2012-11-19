//# License
//
//## The Cocoa XML-RPC Framework is distributed under the MIT License:
//
//Copyright (c) 2012 Eric Czarny <eczarny@gmail.com>
//
//Permission  is hereby granted, free of charge, to any person obtaining a copy of
//this  software  and  associated documentation files (the "Software"), to deal in
//the  Software  without  restriction,  including without limitation the rights to
//use,  copy,  modify,  merge, publish, distribute, sublicense, and/or sell copies
//of  the  Software, and to permit persons to whom the Software is furnished to do
//so, subject to the following conditions:
//
//The  above  copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE  SOFTWARE  IS  PROVIDED  "AS  IS",  WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED,  INCLUDING  BUT  NOT  LIMITED  TO  THE  WARRANTIES  OF MERCHANTABILITY,
//FITNESS  FOR  A  PARTICULAR  PURPOSE  AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS  OR  COPYRIGHT  HOLDERS  BE  LIABLE  FOR  ANY  CLAIM,  DAMAGES  OR OTHER
//LIABILITY,  WHETHER  IN  AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT  OF  OR  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

#import "XMLRPCRequest.h"
#import "XMLRPCEncoder.h"
#import "XMLRPCDefaultEncoder.h"

#define kDefaultTimeoutInterval 240;

#pragma mark -

@implementation XMLRPCRequest

- (id)initWithURL: (NSURL *)URL withEncoder: (id<XMLRPCEncoder>)encoder {
    self = [super init];
    if (self) {
        if (URL) {
            myRequest = [[NSMutableURLRequest alloc] initWithURL: URL];
        } else {
            myRequest = [[NSMutableURLRequest alloc] init];
        }
        
        myXMLEncoder = encoder;
#if ! __has_feature(objc_arc)
        [myXMLEncoder retain];
#endif

        myTimeoutInterval = kDefaultTimeoutInterval;
    }
    
    return self;
}

- (id)initWithURL: (NSURL *)URL {
#if ! __has_feature(objc_arc)
    return [self initWithURL: URL withEncoder: [[[XMLRPCDefaultEncoder alloc] init] autorelease]];
#else
    return [self initWithURL: URL withEncoder: [[XMLRPCDefaultEncoder alloc] init]];
#endif
}

#pragma mark -

- (void)setURL: (NSURL *)URL {
    [myRequest setURL: URL];
}

- (NSURL *)URL {
    return [myRequest URL];
}

#pragma mark -

- (void)setUserAgent: (NSString *)userAgent {
    if (![self userAgent]) {
        [myRequest addValue: userAgent forHTTPHeaderField: @"User-Agent"];
    } else {
        [myRequest setValue: userAgent forHTTPHeaderField: @"User-Agent"];
    }
}

- (NSString *)userAgent {
    return [myRequest valueForHTTPHeaderField: @"User-Agent"];
}

#pragma mark -

- (void)setEncoder:(id<XMLRPCEncoder>)encoder {
    NSString *method = [myXMLEncoder method];
    NSArray *parameters = [myXMLEncoder parameters];
#if ! __has_feature(objc_arc)
    [myXMLEncoder release];
    
    myXMLEncoder = [encoder retain];
#else
    myXMLEncoder = encoder;
#endif
    
    [myXMLEncoder setMethod: method withParameters: parameters];
}

- (void)setMethod: (NSString *)method {
    [myXMLEncoder setMethod: method withParameters: nil];
}

- (void)setMethod: (NSString *)method withParameter: (id)parameter {
    NSArray *parameters = nil;
    
    if (parameter) {
        parameters = [NSArray arrayWithObject: parameter];
    }
    
    [myXMLEncoder setMethod: method withParameters: parameters];
}

- (void)setMethod: (NSString *)method withParameters: (NSArray *)parameters {
    [myXMLEncoder setMethod: method withParameters: parameters];
}

- (void)setTimeoutInterval: (NSTimeInterval)timeoutInterval {
    myTimeoutInterval = timeoutInterval;
}



#pragma mark -

- (NSString *)method {
    return [myXMLEncoder method];
}

- (NSArray *)parameters {
    return [myXMLEncoder parameters];
}

- (NSTimeInterval)timeoutInterval {
    return myTimeoutInterval;
}

#pragma mark -

- (NSString *)body {
    return [myXMLEncoder encode];
}

#pragma mark -

- (NSURLRequest *)request {
    NSData *content = [[self body] dataUsingEncoding: NSUTF8StringEncoding];
    NSNumber *contentLength = [NSNumber numberWithInt: [content length]];
    
    if (!myRequest) {
        return nil;
    }
    
    NSLog(@"Request: %@", self.body);
    [myRequest setHTTPMethod: @"POST"];
    
    if (![myRequest valueForHTTPHeaderField: @"Content-Type"]) {
        [myRequest addValue: @"text/xml" forHTTPHeaderField: @"Content-Type"];
    } else {
        [myRequest setValue: @"text/xml" forHTTPHeaderField: @"Content-Type"];
    }
    
    if (![myRequest valueForHTTPHeaderField: @"Content-Length"]) {
        [myRequest addValue: [contentLength stringValue] forHTTPHeaderField: @"Content-Length"];
    } else {
        [myRequest setValue: [contentLength stringValue] forHTTPHeaderField: @"Content-Length"];
    }
    
    if (![myRequest valueForHTTPHeaderField: @"Accept"]) {
        [myRequest addValue: @"text/xml" forHTTPHeaderField: @"Accept"];
    } else {
        [myRequest setValue: @"text/xml" forHTTPHeaderField: @"Accept"];
    }
    
    if (![self userAgent]) {
      NSString *userAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
        
      if (userAgent) {
        [self setUserAgent: userAgent];
      }
    }
    
    [myRequest setHTTPBody: content];
    
    return (NSURLRequest *)myRequest;
}

#pragma mark -

- (void)setValue: (NSString *)value forHTTPHeaderField: (NSString *)header {
    [myRequest setValue: value forHTTPHeaderField: header];
}

#pragma mark -

- (void)dealloc {
#if ! __has_feature(objc_arc)
    [myRequest release];
    [myXMLEncoder release];
    
    [super dealloc];
#endif
}

@end
