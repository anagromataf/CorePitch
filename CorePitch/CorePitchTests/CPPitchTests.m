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
    CPPitch *pitch = [[CPPitch alloc] initWithFrequency:440.0 amplitude:1];
    XCTAssertEqual(pitch.frequency, 440.0);
}

- (void)testKey
{
    CPPitch *pitch;
    
    pitch = [[CPPitch alloc] initWithFrequency:27.5 amplitude:1];
    XCTAssertEqual(pitch.key, (NSInteger)1);
    
    pitch = [[CPPitch alloc] initWithFrequency:440.0 amplitude:1];
    XCTAssertEqual(pitch.key, (NSInteger)49);
    
    pitch = [[CPPitch alloc] initWithFrequency:261.626 amplitude:1];
    XCTAssertEqual(pitch.key, (NSInteger)40);

    pitch = [[CPPitch alloc] initWithFrequency:659.255 amplitude:1];
    XCTAssertEqual(pitch.key, (NSInteger)56);
    
    pitch = [[CPPitch alloc] initWithFrequency:2093.00 amplitude:1];
    XCTAssertEqual(pitch.key, (NSInteger)76);
}

- (void)testStep
{
    CPPitch *pitch;
    
    pitch = [[CPPitch alloc] initWithFrequency:55.0 amplitude:1];
    XCTAssertEqual(pitch.step, CPPitchStepTypeA);
    
    pitch = [[CPPitch alloc] initWithFrequency:110.0 amplitude:1];
    XCTAssertEqual(pitch.step, CPPitchStepTypeA);
    
    pitch = [[CPPitch alloc] initWithFrequency:220.0 amplitude:1];
    XCTAssertEqual(pitch.step, CPPitchStepTypeA);
    
    pitch = [[CPPitch alloc] initWithFrequency:440.0 amplitude:1];
    XCTAssertEqual(pitch.step, CPPitchStepTypeA);
    
    pitch = [[CPPitch alloc] initWithFrequency:880.0 amplitude:1];
    XCTAssertEqual(pitch.step, CPPitchStepTypeA);
    
    pitch = [[CPPitch alloc] initWithFrequency:1760.00 amplitude:1];
    XCTAssertEqual(pitch.step, CPPitchStepTypeA);
    
    pitch = [[CPPitch alloc] initWithFrequency:3520.00 amplitude:1];
    XCTAssertEqual(pitch.step, CPPitchStepTypeA);
}

- (void)testOctave
{
    CPPitch *pitch;
    
    pitch = [[CPPitch alloc] initWithFrequency:55.0 amplitude:1];
    XCTAssertEqual(pitch.octave, (NSInteger)1);
    
    pitch = [[CPPitch alloc] initWithFrequency:110.0 amplitude:1];
    XCTAssertEqual(pitch.octave, (NSInteger)2);
    
    pitch = [[CPPitch alloc] initWithFrequency:220.0 amplitude:1];
    XCTAssertEqual(pitch.octave, (NSInteger)3);
    
    pitch = [[CPPitch alloc] initWithFrequency:440.0 amplitude:1];
    XCTAssertEqual(pitch.octave, (NSInteger)4);
    
    pitch = [[CPPitch alloc] initWithFrequency:880.0 amplitude:1];
    XCTAssertEqual(pitch.octave, (NSInteger)5);
    
    pitch = [[CPPitch alloc] initWithFrequency:1760.00 amplitude:1];
    XCTAssertEqual(pitch.octave, (NSInteger)6);
    
    pitch = [[CPPitch alloc] initWithFrequency:3520.00 amplitude:1];
    XCTAssertEqual(pitch.octave, (NSInteger)7);
}

- (void)testEquality
{
    CPPitch *pitchA = [[CPPitch alloc] initWithFrequency:440.0 amplitude:1];
    CPPitch *pitchB = [[CPPitch alloc] initWithFrequency:450.0 amplitude:1];
    CPPitch *pitchC = [[CPPitch alloc] initWithFrequency:440.0 amplitude:1];
    
    XCTAssertEqualObjects(pitchA, pitchC);
    XCTAssertNotEqualObjects(pitchA, pitchB);
}

@end
