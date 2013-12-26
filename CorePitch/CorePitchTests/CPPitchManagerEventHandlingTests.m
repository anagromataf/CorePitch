//
//  CPPitchManagerEventHandlingTests.m
//  CorePitch
//
//  Created by Tobias Kräntzer on 22.12.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#import <XCTest/XCTest.h>

#import <CoreAudio/CoreAudioTypes.h>

#import "CPPitchManager.h"
#import "CPPitchManager+EventHandling.h"

#import "CPPitch.h"
#import "CPPitch+Private.h"

#import "CPEvent.h"
#import "CPEvent+Private.h"

#import "CPTrack.h"
#import "CPTrack+Private.h"


@interface CPPitchManagerEventHandlingTests : XCTestCase
@property (nonatomic, strong) CPPitchManager *pitchManager;
@end

@implementation CPPitchManagerEventHandlingTests

- (void)setUp
{
    [super setUp];
    self.pitchManager = [[CPPitchManager alloc] init];
}

- (void)tearDown
{
    self.pitchManager = nil;
    [super tearDown];
}

#pragma mark Tests

- (void)testTrackSingleTrack
{
    id <CPPitchManagerDelegate> delegate = mockProtocol(@protocol(CPPitchManagerDelegate));
    self.pitchManager.delegate = delegate;
    
    NSTimeInterval timestamp = [[NSProcessInfo processInfo] systemUptime];
    
    // Track Began
    
    CPPitch *pitchA = [[CPPitch alloc] initWithFrequency:440.0 amplitude:1];
    CPEvent *eventA = [[CPEvent alloc] initWithTimestamp:timestamp
                                                 pitches:[NSSet setWithObject:pitchA]];
    [self.pitchManager handleEvent:eventA];
    
    [verifyCount(delegate, times(1)) pitchManager:self.pitchManager
                                      tracksBegan:anything()
                                        withEvent:eventA];
    
    // Track Changed
    
    CPPitch *pitchB = [[CPPitch alloc] initWithFrequency:450.0 amplitude:1];
    CPEvent *eventB = [[CPEvent alloc] initWithTimestamp:timestamp + 60
                                                 pitches:[NSSet setWithObject:pitchB]];
    [self.pitchManager handleEvent:eventB];
    
    [verifyCount(delegate, times(1)) pitchManager:self.pitchManager
                                    tracksChanged:anything()
                                        withEvent:eventA];
    
    // Track Changed
    
    CPPitch *pitchC = [[CPPitch alloc] initWithFrequency:460.0 amplitude:1];
    CPEvent *eventC = [[CPEvent alloc] initWithTimestamp:timestamp + 120
                                                 pitches:[NSSet setWithObject:pitchC]];
    [self.pitchManager handleEvent:eventC];
    
    [verifyCount(delegate, times(1)) pitchManager:self.pitchManager
                                    tracksChanged:anything()
                                        withEvent:eventA];
    
    // Track Ended
    
    CPEvent *eventD = [[CPEvent alloc] initWithTimestamp:timestamp + 180
                                                 pitches:[NSSet set]];
    [self.pitchManager handleEvent:eventD];
    
    [verifyCount(delegate, times(1)) pitchManager:self.pitchManager
                                      tracksEnded:anything()
                                        withEvent:eventA];
    
    
    CPTrack *_track = [[CPTrack alloc] init];
    [_track addPitch:pitchA atTimestamp:timestamp];
    [_track addPitch:pitchB atTimestamp:timestamp + 60];
    [_track addPitch:pitchC atTimestamp:timestamp + 120];
    
    XCTAssertEqual([self.pitchManager.tracks count], 1u);
    
    CPTrack *track = [self.pitchManager.tracks anyObject];
    XCTAssertEqualObjects(track, _track);
}

@end
