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

#import "CPPitch.h"
#import "CPPitch+Private.h"

#import "CPEvent.h"
#import "CPEvent+Private.h"

@interface CPPitchManagerSignalProcessingTests : XCTestCase {
    AudioBuffer _buffer;
}
@property (nonatomic, strong) CPPitchManager *pitchManager;
@end

@implementation CPPitchManagerSignalProcessingTests

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

#pragma mark Tests

- (void)testSimpleSignal
{
    AudioBuffer buffer = _buffer;
    
    [self fillBuffer:buffer withFrequency:440.0 amplitude:1];
    
    NSSet *pitches = [self.pitchManager processSamples:buffer];
    XCTAssertEqual([pitches count], 1u);
    
    CPPitch *pitch = [pitches anyObject];
    XCTAssertEqualWithAccuracy(pitch.frequency, 440.0, 0.1);
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
