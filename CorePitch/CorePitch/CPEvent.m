//
//  CPEvent.m
//  CorePitch
//
//  Created by Tobias Kräntzer on 16.12.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import "CPEvent.h"
#import "CPEvent+Private.h"

@implementation CPEvent

@end

#pragma mark -

@implementation CPEvent (Private)

#pragma mark Life-cycle

- (id)initWithTimestamp:(NSTimeInterval)timestamp pitches:(NSSet *)pitches
{
    self = [super init];
    if (self) {
        _timestamp = timestamp;
        _allPitches = [pitches copy];
    }
    return self;
}

@end
