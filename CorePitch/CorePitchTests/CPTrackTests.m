//
//  CPTrackTests.m
//  CorePitch
//
//  Created by Tobias Kräntzer on 26.12.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CPTrack.h"
#import "CPTrack+Private.h"

#import "CPPitch.h"
#import "CPPitch+Private.h"

@interface CPTrackTests : XCTestCase

@end

@implementation CPTrackTests

- (void)testCreateTrack
{
    CPTrack *track = [[CPTrack alloc] init];
    XCTAssertNotNil(track);
}

- (void)testAddPitch
{
    NSTimeInterval timespamp = [[NSProcessInfo processInfo] systemUptime];
    
    CPTrack *track = [[CPTrack alloc] init];
    CPPitch *pitch = [[CPPitch alloc] initWithFrequency:440.0 amplitude:1];
    
    [track addPitch:pitch atTimestamp:timespamp];
    
    CPPitch *_pitch = [track pitchAtTimestamp:timespamp];
    XCTAssertNotNil(_pitch);
    XCTAssertEqualObjects(_pitch, pitch);
}

- (void)testGetCurrentPitch
{
    NSTimeInterval timespamp = [[NSProcessInfo processInfo] systemUptime];
    
    CPTrack *track = [[CPTrack alloc] init];

    CPPitch *pitchA = [[CPPitch alloc] initWithFrequency:440.0 amplitude:1];
    [track addPitch:pitchA atTimestamp:timespamp - 60];

    CPPitch *pitchB = [[CPPitch alloc] initWithFrequency:450.0 amplitude:1];
    [track addPitch:pitchB atTimestamp:timespamp];
    
    CPPitch *_pitch = track.currentPitch;
    XCTAssertEqualObjects(pitchB, _pitch);
}

@end
