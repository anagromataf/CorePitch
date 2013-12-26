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

- (CPPitch *)currentPitch
{
    NSArray *timestamps = [[self.pitches allKeys] sortedArrayUsingSelector:@selector(compare:)];
    return [self.pitches objectForKey:[timestamps lastObject]];
}

- (CPPitch *)pitchAtTimestamp:(NSTimeInterval)timestamp
{
    return [self.pitches objectForKey:@(timestamp)];
}

#pragma mark NSObject 

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[CPTrack class]]) {
        return NO;
    }
    
    CPTrack *other = object;
    
    if (![other.pitches isEqualToDictionary:self.pitches]) {
        return NO;
    }
    
    return YES;
}

@end

#pragma mark -

@implementation CPTrack (Private)

#pragma mark Managing Track Pitches

- (void)addPitch:(CPPitch *)pitch atTimestamp:(NSTimeInterval)timestamp
{
    [self.pitches setObject:pitch forKey:@(timestamp)];
}

@end
