//
//  CPTrack.m
//  CorePitch
//
//  Created by Tobias Kräntzer on 26.12.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import "CPTrack.h"
#import "CPTrack+Private.h"

@interface CPTrack ()
@property (nonatomic, readonly) NSMutableDictionary *pitches;
@end

@implementation CPTrack

#pragma mark Life-cycle

- (id)init
{
    self = [super init];
    if (self) {
        _pitches = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark Getting Track Attributes

- (CPPitch *)pitchAtTimestamp:(NSTimeInterval)timestamp
{
    return [self.pitches objectForKey:@(timestamp)];
}

@end

#pragma mark -

@implementation CPTrack (Private)

- (void)addPitch:(CPPitch *)pitch atTimestamp:(NSTimeInterval)timestamp
{
    [self.pitches setObject:pitch forKey:@(timestamp)];
}

@end
