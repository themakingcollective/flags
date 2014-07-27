//
//  EventRecorder.m
//  flags
//
//  Created by Chris Patuzzo on 27/07/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "EventRecorder.h"
#import "Utils.h"

@interface EventRecorder ()

@property (nonatomic, strong) NSFileHandle *file;

@end

@implementation EventRecorder

+ (EventRecorder *)sharedInstance
{
    static dispatch_once_t once;
    static EventRecorder *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString *)path
{
    return @"events.txt";
}

- (NSURL *)url
{
    return [NSURL URLWithString:@"http://localhost:3000/foo.html"];
}

- (void)record:(NSDictionary *)eventData
{
    NSData* data = [NSJSONSerialization dataWithJSONObject:eventData options:0 error:nil];
    NSString* json = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];

    NSFileHandle *file = [Utils fileAtDocumentsPath:[self path]];
    [file seekToEndOfFile];
    [file writeData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    [file writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [file closeFile];
}

- (void)transmit
{
    NSFileHandle *file = [Utils fileAtDocumentsPath:[self path]];
    NSData *postData = [file readDataToEndOfFile];
    [file closeFile];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[self url]];
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    
    NSHTTPURLResponse *response;
    NSError *error;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if ([response statusCode] == 200) {
        [Utils deleteDocument:[self path]];
    }
    else {
        NSLog(@"Failed to transmit to %@. code: %d, error: %@", [self url], [response statusCode], error);
    }
}

@end