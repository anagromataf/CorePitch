//
//  CPPitchManager.m
//  CorePitch
//
//  Created by Tobias Kräntzer on 16.12.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import "CPPitch+Private.h"

#import "CPPitchManager.h"
#import "CPPitchManager+Private.h"

@implementation CPPitchManager

#pragma mark Managing Pitch Updates

- (void)startPitchUpdates
{
}

- (void)stopPitchUpdates
{
}

@end

@implementation CPPitchManager (Private)

#pragma mark Process Samples

- (NSSet *)processSamples:(AudioBuffer)samples
{
    NSMutableSet *pitches = [NSMutableSet set];
    [pitches addObject:[[CPPitch alloc] initWithFrequency:440.0]];
    return pitches;
}

#pragma mark Handle Pitch Event

- (void)handleEvent:(CPEvent *)event
{
    
}

@end
