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

@end
