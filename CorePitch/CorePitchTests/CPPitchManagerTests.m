//
//  CPPitchManagerTests.m
//  CorePitch
//
//  Created by Tobias Kräntzer on 18.12.13.
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
#import "CPPitchManager+EventHandling.h"

#import "CPPitch.h"
#import "CPPitch+Private.h"

#import "CPEvent.h"
#import "CPEvent+Private.h"

@interface CPPitchManagerTests : XCTestCase {
    AudioBuffer _buffer;
}
@property (nonatomic, strong) CPPitchManager *pitchManager;
@end

@implementation CPPitchManagerTests

- (void)setUp
{
    [super setUp];
    self.pitchManager = [[CPPitchManager alloc] init];
    _buffer.mDataByteSize = sizeof(float) * 1024;
    _buffer.mData = calloc(1, _buffer.mDataByteSize);
    _buffer.mNumberChannels = 1;
}

- (void)tearDown
{
    free(_buffer.mData);
    self.pitchManager = nil;
    [super tearDown];
}

#pragma mark Tests | Signal Processing

- (void)testSimpleSignal
{
    AudioBuffer buffer = _buffer;
    
    [self fillBuffer:buffer withFrequency:440.0 amplitude:1];
    
    NSSet *pitches = [self.pitchManager processSamples:buffer];
    XCTAssertEqual([pitches count], 1u);
    
    CPPitch *pitch = [pitches anyObject];
    XCTAssertEqualWithAccuracy(pitch.frequency, 440.0, 0.1);
}

#pragma mark Tests | Event Handling

- (void)testHandleEvent
{
    CPPitch *pitch = [[CPPitch alloc] initWithFrequency:440.0 amplitude:1 phase:CPPitchPhaseBegan];
    CPEvent *event = [[CPEvent alloc] initWithTimestamp:[[NSProcessInfo processInfo] systemUptime]
                                                pitches:[NSSet setWithObject:pitch]];
    
    id <CPPitchManagerDelegate> delegate = mockProtocol(@protocol(CPPitchManagerDelegate));
    
    self.pitchManager.delegate = delegate;
    
    [self.pitchManager handleEvent:event];
    
    [verifyCount(delegate, times(1)) pitchManager:self.pitchManager pitchesBegan:[NSSet setWithObject:pitch] withEvent:event];
}

#pragma mark -

- (void)fillBuffer:(AudioBuffer)buffer
     withFrequency:(float)frequency
         amplitude:(float)ampl
{
    float *samples = buffer.mData;
    UInt32 numSamples = buffer.mDataByteSize / sizeof(float);
    
    double sampleRate = self.pitchManager.sampleRate;
    
    for (int i = 0; i < numSamples; i++) {
        samples[i] = samples[i] + (float)(ampl * cos(2*M_PI*frequency*i/sampleRate));
    }
}

@end
