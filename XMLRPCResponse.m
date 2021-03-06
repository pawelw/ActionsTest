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

#import "XMLRPCResponse.h"
#import "XMLRPCEventBasedParser.h"

@implementation XMLRPCResponse

- (id)initWithData: (NSData *)data {
    if (!data) {
        return nil;
    }

    self = [super init];
    if (self) {
        XMLRPCEventBasedParser *parser = [[XMLRPCEventBasedParser alloc] initWithData: data];
        
        if (!parser) {
#if ! __has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
    
        myBody = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        myObject = [parser parse];
#if ! __has_feature(objc_arc)
        [myObject retain];
#endif
        
        isFault = [parser isFault];
        
#if ! __has_feature(objc_arc)
        [parser release];
#endif
    }
    
    return self;
}

#pragma mark -

- (BOOL)isFault {
    return isFault;
}

- (NSNumber *)faultCode {
    if (isFault) {
        return [myObject objectForKey: @"faultCode"];
    }
    
    return nil;
}

- (NSString *)faultString {
    if (isFault) {
        return [myObject objectForKey: @"faultString"];
    }
    
    return nil;
}

#pragma mark -

- (id)object {
    return myObject;
}

#pragma mark -

- (NSString *)body {
  
    return myBody;
}

#pragma mark -

- (NSString *)description {
	NSMutableString	*result = [NSMutableString stringWithCapacity:128];
    
	[result appendFormat:@"[body=%@", myBody];
    
	if (isFault) {
		[result appendFormat:@", fault[%@]='%@'", [self faultCode], [self faultString]];
	} else {
		[result appendFormat:@", object=%@", myObject];
	}
    
	[result appendString:@"]"];
    
	return result;
}

#pragma mark -

- (void)dealloc {
#if ! __has_feature(objc_arc)
    [myBody release];
    [myObject release];
    
    [super dealloc];
#endif
}

@end
