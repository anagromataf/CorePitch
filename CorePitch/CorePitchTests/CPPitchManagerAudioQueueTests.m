//
//  CPPitchManagerAudioQueueTests.m
//  CorePitch
//
//  Created by Tobias Kräntzer on 30.12.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#import <XCTest/XCTest.h>

#import "CPPitchManager.h"
#import "CPPitchManager+Private.h"

@interface CPPitchManagerAudioQueueTests : XCTestCase
@property (nonatomic, strong) CPPitchManager *pitchManager;
@end

@implementation CPPitchManagerAudioQueueTests

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

- (void)testInputStreamDescription
{
    XCTAssertEqual(self.pitchManager.inputStreamDescription.mFormatID, (UInt32)kAudioFormatLinearPCM);
    XCTAssertEqual(self.pitchManager.inputStreamDescription.mFormatFlags, (UInt32)kAudioFormatFlagIsFloat);
    
    XCTAssertEqual(self.pitchManager.inputStreamDescription.mFramesPerPacket, (UInt32)1);
    XCTAssertEqual(self.pitchManager.inputStreamDescription.mChannelsPerFrame, (UInt32)1);
    XCTAssertEqual(self.pitchManager.inputStreamDescription.mBitsPerChannel, sizeof(float) * 8);
}

- (void)testAudioQueue
{
    XCTAssertNotEqual(self.pitchManager.inputQueue, NULL);
}

- (void)testStartStop
{
    XCTAssertEqual(self.pitchManager.isUpdatingPitches, NO);
    
    [self.pitchManager startPitchUpdates];
    
    XCTAssertEqual(self.pitchManager.isUpdatingPitches, YES);
    
    [self.pitchManager stopPitchUpdates];
    
    XCTAssertEqual(self.pitchManager.isUpdatingPitches, NO);
}

@end
