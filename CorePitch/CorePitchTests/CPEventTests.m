//
//  CPEventTests.m
//  CorePitch
//
//  Created by Tobias Kräntzer on 20.12.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CPEvent.h"
#import "CPEvent+Private.h"

#import "CPPitch+Private.h"

@interface CPEventTests : XCTestCase

@end

@implementation CPEventTests

- (void)testEvent
{
    NSMutableSet *pitches = [[NSMutableSet alloc] init];
    [pitches addObject:[[CPPitch alloc] initWithFrequency:440.0 amplitude:1]];
    
    NSTimeInterval timestamp = [[NSProcessInfo processInfo] systemUptime];
    
    CPEvent *event = [[CPEvent alloc] initWithTimestamp:timestamp pitches:pitches];
    XCTAssertEqualObjects(event.allPitches, pitches);
    XCTAssertEqual(event.timestamp, timestamp);
}

@end
