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
@property (nonatomic, strong) CPPitchManager *_pitchManager;
@end

@implementation CPPitchManagerInputCallbackTests

- (void)setUp
{
    [super setUp];
    self._pitchManager = [[CPPitchManager alloc] init];
}

- (void)tearDown
{
    self._pitchManager = nil;
    [super tearDown];
}

#pragma mark Tests

- (void)testInputCallback
{
    CPPitchManagerStub *pitchManager = [[CPPitchManagerStub alloc] init];
    pitchManager.isRunning = NO;
    
    AudioQueueBufferRef buffer;
    OSStatus status = AudioQueueAllocateBuffer(self._pitchManager.inputQueue, sizeof(float) * 1024, &buffer);
    XCTAssertEqual(status, (OSStatus)noErr);
    
    buffer->mAudioDataByteSize = buffer->mAudioDataBytesCapacity;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CPPitchManager *manager = (CPPitchManager *)pitchManager;
        CPPitchManagerAudioQueueInputCallback((__bridge void *)(manager), NULL, buffer, NULL, 1024, NULL);
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
