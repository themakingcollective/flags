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
    NSString *host = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Flags Server"];
    NSString *path = [NSString stringWithFormat:@"%@/event_batches", host];
    
    return [NSURL URLWithString:path];
}

- (void)record:(NSDictionary *)eventData
{
    NSData* data = [NSJSONSerialization dataWithJSONObject:eventData options:0 error:nil];
    NSString* json = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];

    if ([self exceededMaximumFileSize]) {
        NSLog(@"Not recording event. Maximum file size reached.");
        return;
    }
    
    NSFileHandle *file = [Utils fileAtDocumentsPath:[self path]];
    [file seekToEndOfFile];
    [file writeData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    [file writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [file closeFile];
}

- (void)transmit
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *permission = [preferences valueForKey:@"transmit"];

    if ([permission isEqualToString:@"allow"]) {
        NSFileHandle *file = [Utils fileAtDocumentsPath:[self path]];
        NSData *data = [file readDataToEndOfFile];
        NSData *postData = [self convertToValidJson:data];
        [file closeFile];

        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[self url]];
        [request setHTTPBody:postData];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSHTTPURLResponse *response;
        NSError *error;
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if ([response statusCode] == 200) {
            [Utils deleteDocument:[self path]];
        }
        else {
            // NSLog(@"Failed to transmit to %@. code: %d, error: %@", [self url], [response statusCode], error);
            NSLog(@"Could not transmit events.");
        }
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Permission has not been granted to transmit events.");
        });
    }
}

- (NSData *)convertToValidJson:(NSData *)data
{
    NSString *events = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    events = [events stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    events = [events stringByReplacingOccurrencesOfString:@"\n" withString:@","];
    NSString *json = [NSString stringWithFormat:@"{\"events\": [%@] }", events];
    return [json dataUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)exceededMaximumFileSize
{
    NSString *path = [Utils documentsPath:[self path]];
    NSDictionary *attr = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSInteger fileSize = (NSInteger)[attr fileSize];
    
    // 100KB maximum file size.
    // Should be enough for > 1000 events.
    return fileSize > 100000;
}

@end