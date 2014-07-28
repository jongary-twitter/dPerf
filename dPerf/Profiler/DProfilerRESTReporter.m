//
//  DProfilerRESTReporter.m
//  dPerf
//
/*
 Copyright (c) 2014 Twitter, Inc.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */


#import "DProfilerRESTReporter.h"

@implementation DprofilerRESTReporter

- (instancetype)initWithURL:(NSURL *)url
{
    if (self = [super init]) {
        _serverURL = url;
    }
    return self;
}

- (void)reportDictionary:(NSDictionary *)reportDictionary;
{
    NSData *json = [NSJSONSerialization dataWithJSONObject:reportDictionary
                                                   options:0
                                                     error: nil];

    // Create a URL for the request using the |_serverUrl| and appending a
    // cache busting token.
    NSString *url = [NSString stringWithFormat:@"%@/?cacheBust=%u",
                     [self.serverURL absoluteString],
                     (uint)[[NSDate date] timeIntervalSince1970]
                     ];

    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];

    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:json];

    NSError *error = [[NSError alloc] init];
    NSURLResponse *res = [[NSURLResponse alloc] init];

    NSData *resData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
    if (resData == nil && error != nil) {
        NSLog(@"Reporting may have failed: %@", [error localizedDescription]);
    }

}

@end
