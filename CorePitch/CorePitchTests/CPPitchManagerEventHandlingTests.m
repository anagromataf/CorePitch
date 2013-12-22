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

- (void)testPitchesBeganEvent
{
    CPPitch *pitch = [[CPPitch alloc] initWithFrequency:440.0 amplitude:1 phase:CPPitchPhaseBegan];
    CPEvent *event = [[CPEvent alloc] initWithTimestamp:[[NSProcessInfo processInfo] systemUptime]
                                                pitches:[NSSet setWithObject:pitch]];
    
    id <CPPitchManagerDelegate> delegate = mockProtocol(@protocol(CPPitchManagerDelegate));
    self.pitchManager.delegate = delegate;
    
    [self.pitchManager handleEvent:event];
    
    [verifyCount(delegate, times(1)) pitchManager:self.pitchManager
                                     pitchesBegan:[NSSet setWithObject:pitch]
                                        withEvent:event];
    
    [verifyCount(delegate, never()) pitchManager:anything()
                                  pitchesChanged:anything()
                                       withEvent:anything()];
    
    [verifyCount(delegate, never()) pitchManager:anything()
                                    pitchesEnded:anything()
                                       withEvent:anything()];
}

- (void)testPitchesChangedEvent
{
    CPPitch *pitch = [[CPPitch alloc] initWithFrequency:440.0 amplitude:1 phase:CPPitchPhaseChanged];
    CPEvent *event = [[CPEvent alloc] initWithTimestamp:[[NSProcessInfo processInfo] systemUptime]
                                                pitches:[NSSet setWithObject:pitch]];
    
    id <CPPitchManagerDelegate> delegate = mockProtocol(@protocol(CPPitchManagerDelegate));
    self.pitchManager.delegate = delegate;
    
    [self.pitchManager handleEvent:event];
    
    
    [verifyCount(delegate, never()) pitchManager:anything()
                                    pitchesBegan:anything()
                                       withEvent:anything()];
    
    [verifyCount(delegate, times(1)) pitchManager:self.pitchManager
                                   pitchesChanged:[NSSet setWithObject:pitch]
                                        withEvent:event];
    
    [verifyCount(delegate, never()) pitchManager:anything()
                                    pitchesEnded:anything()
                                       withEvent:anything()];
}

- (void)testPitchesEndedEvent
{
    CPPitch *pitch = [[CPPitch alloc] initWithFrequency:440.0 amplitude:1 phase:CPPitchPhaseEnded];
    CPEvent *event = [[CPEvent alloc] initWithTimestamp:[[NSProcessInfo processInfo] systemUptime]
                                                pitches:[NSSet setWithObject:pitch]];
    
    id <CPPitchManagerDelegate> delegate = mockProtocol(@protocol(CPPitchManagerDelegate));
    self.pitchManager.delegate = delegate;
    
    [self.pitchManager handleEvent:event];
    
    [verifyCount(delegate, never()) pitchManager:anything()
                                    pitchesBegan:anything()
                                       withEvent:anything()];
    
    [verifyCount(delegate, never()) pitchManager:anything()
                                  pitchesChanged:anything()
                                       withEvent:anything()];
    
    [verifyCount(delegate, times(1)) pitchManager:self.pitchManager
                                   pitchesEnded:[NSSet setWithObject:pitch]
                                        withEvent:event];
}

- (void)testMixedEvent
{
    CPPitch *pitch1 = [[CPPitch alloc] initWithFrequency:440.0 amplitude:1 phase:CPPitchPhaseBegan];
    CPPitch *pitch2 = [[CPPitch alloc] initWithFrequency:770.0 amplitude:1 phase:CPPitchPhaseChanged];
    CPPitch *pitch3 = [[CPPitch alloc] initWithFrequency:990.0 amplitude:1 phase:CPPitchPhaseEnded];
    
    CPEvent *event = [[CPEvent alloc] initWithTimestamp:[[NSProcessInfo processInfo] systemUptime]
                                                pitches:[NSSet setWithObjects:pitch1, pitch2, pitch3, nil]];
    
    id <CPPitchManagerDelegate> delegate = mockProtocol(@protocol(CPPitchManagerDelegate));
    self.pitchManager.delegate = delegate;
    
    [self.pitchManager handleEvent:event];
    
    [verifyCount(delegate, times(1)) pitchManager:self.pitchManager
                                     pitchesBegan:[NSSet setWithObject:pitch1]
                                        withEvent:event];
    
    [verifyCount(delegate, times(1)) pitchManager:self.pitchManager
                                   pitchesChanged:[NSSet setWithObject:pitch2]
                                        withEvent:event];
    
    [verifyCount(delegate, times(1)) pitchManager:self.pitchManager
                                     pitchesEnded:[NSSet setWithObject:pitch3]
                                        withEvent:event];
}

@end
