//
//  CPPitchTests.m
//  CorePitch
//
//  Created by Tobias Kräntzer on 20.12.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CPPitch.h"
#import "CPPitch+Private.h"

@interface CPPitchTests : XCTestCase

@end

@implementation CPPitchTests

- (void)testPitchFrequency
{
    CPPitch *pitch = [[CPPitch alloc] initWithFrequency:440.0 amplitude:1 phase:CPPitchPhaseStationary];
    XCTAssertEqual(pitch.frequency, 440.0);
}

- (void)testKey
{
    CPPitch *pitch;
    
    pitch = [[CPPitch alloc] initWithFrequency:27.5 amplitude:1 phase:CPPitchPhaseStationary];
    XCTAssertEqual(pitch.key, 1);
    
    pitch = [[CPPitch alloc] initWithFrequency:440.0 amplitude:1 phase:CPPitchPhaseStationary];
    XCTAssertEqual(pitch.key, 49);
    
    pitch = [[CPPitch alloc] initWithFrequency:261.626 amplitude:1 phase:CPPitchPhaseStationary];
    XCTAssertEqual(pitch.key, 40);

    pitch = [[CPPitch alloc] initWithFrequency:659.255 amplitude:1 phase:CPPitchPhaseStationary];
    XCTAssertEqual(pitch.key, 56);
    
    pitch = [[CPPitch alloc] initWithFrequency:2093.00 amplitude:1 phase:CPPitchPhaseStationary];
    XCTAssertEqual(pitch.key, 76);
}

- (void)testStep
{
    CPPitch *pitch;
    
    pitch = [[CPPitch alloc] initWithFrequency:55.0 amplitude:1 phase:CPPitchPhaseStationary];
    XCTAssertEqual(pitch.step, CPPitchStepTypeA);
    
    pitch = [[CPPitch alloc] initWithFrequency:110.0 amplitude:1 phase:CPPitchPhaseStationary];
    XCTAssertEqual(pitch.step, CPPitchStepTypeA);
    
    pitch = [[CPPitch alloc] initWithFrequency:220.0 amplitude:1 phase:CPPitchPhaseStationary];
    XCTAssertEqual(pitch.step, CPPitchStepTypeA);
    
    pitch = [[CPPitch alloc] initWithFrequency:440.0 amplitude:1 phase:CPPitchPhaseStationary];
    XCTAssertEqual(pitch.step, CPPitchStepTypeA);
    
    pitch = [[CPPitch alloc] initWithFrequency:880.0 amplitude:1 phase:CPPitchPhaseStationary];
    XCTAssertEqual(pitch.step, CPPitchStepTypeA);
    
    pitch = [[CPPitch alloc] initWithFrequency:1760.00 amplitude:1 phase:CPPitchPhaseStationary];
    XCTAssertEqual(pitch.step, CPPitchStepTypeA);
    
    pitch = [[CPPitch alloc] initWithFrequency:3520.00 amplitude:1 phase:CPPitchPhaseStationary];
    XCTAssertEqual(pitch.step, CPPitchStepTypeA);
}

- (void)testOctave
{
    CPPitch *pitch;
    
    pitch = [[CPPitch alloc] initWithFrequency:55.0 amplitude:1 phase:CPPitchPhaseStationary];
    XCTAssertEqual(pitch.octave, 1);
    
    pitch = [[CPPitch alloc] initWithFrequency:110.0 amplitude:1 phase:CPPitchPhaseStationary];
    XCTAssertEqual(pitch.octave, 2);
    
    pitch = [[CPPitch alloc] initWithFrequency:220.0 amplitude:1 phase:CPPitchPhaseStationary];
    XCTAssertEqual(pitch.octave, 3);
    
    pitch = [[CPPitch alloc] initWithFrequency:440.0 amplitude:1 phase:CPPitchPhaseStationary];
    XCTAssertEqual(pitch.octave, 4);
    
    pitch = [[CPPitch alloc] initWithFrequency:880.0 amplitude:1 phase:CPPitchPhaseStationary];
    XCTAssertEqual(pitch.octave, 5);
    
    pitch = [[CPPitch alloc] initWithFrequency:1760.00 amplitude:1 phase:CPPitchPhaseStationary];
    XCTAssertEqual(pitch.octave, 6);
    
    pitch = [[CPPitch alloc] initWithFrequency:3520.00 amplitude:1 phase:CPPitchPhaseStationary];
    XCTAssertEqual(pitch.octave, 7);
}

- (void)testEquality
{
    CPPitch *pitchA = [[CPPitch alloc] initWithFrequency:440.0 amplitude:1 phase:CPPitchPhaseBegan];
    CPPitch *pitchB = [[CPPitch alloc] initWithFrequency:450.0 amplitude:1 phase:CPPitchPhaseBegan];
    CPPitch *pitchC = [[CPPitch alloc] initWithFrequency:440.0 amplitude:1 phase:CPPitchPhaseBegan];
    
    XCTAssertEqualObjects(pitchA, pitchC);
    XCTAssertNotEqualObjects(pitchA, pitchB);
}

@end
