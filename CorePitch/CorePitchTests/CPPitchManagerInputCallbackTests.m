//
//  CPPitchManagerInputCallbackTests.m
//  CorePitch
//
//  Created by Tobias Kräntzer on 27.12.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#import <XCTest/XCTest.h>
#import <CoreAudio/CoreAudioTypes.h>

#import "CPPitchManager.h"
#import "CPPitchManager+Private.h"

#import "CPPitch.h"
#import "CPPitch+Private.h"

#import "CPEvent.h"
#import "CPEvent+Private.h"

@interface CPPitchManagerStub : NSObject
@property (nonatomic, strong) CPEvent *event;
@property (nonatomic, assign) BOOL isRunning;
- (NSSet *)processSamples:(AudioBuffer)samples;
- (void)handleEvent:(CPEvent *)event;
@end
@implementation CPPitchManagerStub
- (NSSet *)processSamples:(AudioBuffer)samples { return [NSSet set]; }
- (void)handleEvent:(CPEvent *)event { self.event = event; }
@end

#pragma mark -

@interface CPPitchManagerInputCallbackTests : XCTestCase

@end

@implementation CPPitchManagerInputCallbackTests

#pragma mark Tests

- (void)testInputCallback
{
    CPPitchManagerStub *pitchManager = [[CPPitchManagerStub alloc] init];
    pitchManager.isRunning = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CPPitchManager *manager = (CPPitchManager *)pitchManager;
        
        AudioQueueBuffer aqBuffer = {
            .mAudioDataBytesCapacity = sizeof(float) * 1024,
            .mAudioData = calloc(sizeof(float), 1024),
            .mAudioDataByteSize = sizeof(float) * 1024
        };
        
        CPPitchManagerAudioQueueInputCallback((__bridge void *)(manager), NULL, &aqBuffer, NULL, 1024, NULL);
        
        free(aqBuffer.mAudioData);
    });
    
    NSUInteger runs = 0;
    while (pitchManager.event == nil || runs > 3) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode
                              beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        runs++;
    }
    
    XCTAssertNotNil(pitchManager.event);
}

@end
