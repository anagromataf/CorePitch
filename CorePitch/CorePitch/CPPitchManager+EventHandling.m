//
//  CPPitchManager+EventHandling.m
//  CorePitch
//
//  Created by Tobias Kräntzer on 20.12.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import "CPEvent.h"
#import "CPPitch.h"
#import "CPTrack.h"

#import "CPTrack+Private.h"

#import "CPPitchManager+Private.h"
#import "CPPitchManager+EventHandling.h"

@implementation CPPitchManager (EventHandling)

#pragma mark Handle Event

- (void)handleEvent:(CPEvent *)event
{
    NSMutableSet *changedTracks = [[NSMutableSet alloc] init];
    
    NSMutableSet *pitches = [event.allPitches mutableCopy];
    
    [self.tracks enumerateObjectsUsingBlock:^(CPTrack *track, BOOL *stop) {
        
        CPPitch *pitch = [pitches anyObject];
        if (pitch) {
            [pitches removeObject:pitch];
            [track addPitch:pitch atTimestamp:event.timestamp];
            [changedTracks addObject:track];
        } else {
            *stop = YES;
        }
    }];
    
    NSMutableSet *newTracks = [[NSMutableSet alloc] init];
    [pitches enumerateObjectsUsingBlock:^(CPPitch *pitch, BOOL *stop) {
        CPTrack *track = [[CPTrack alloc] init];
        [track addPitch:pitch atTimestamp:event.timestamp];
        [newTracks addObject:track];
    }];
    
    NSMutableSet *endedTracks = [self.tracks mutableCopy];
    [endedTracks minusSet:newTracks];
    [endedTracks minusSet:changedTracks];
    
    
    if ([newTracks count] > 0 &&
        [self.delegate respondsToSelector:@selector(pitchManager:tracksBegan:withEvent:)]) {
        [self.delegate pitchManager:self tracksBegan:newTracks withEvent:event];
    }
    
    if ([changedTracks count] > 0 &&
        [self.delegate respondsToSelector:@selector(pitchManager:tracksChanged:withEvent:)]) {
        [self.delegate pitchManager:self tracksChanged:changedTracks withEvent:event];
    }
    
    if ([endedTracks count] > 0 &&
        [self.delegate respondsToSelector:@selector(pitchManager:tracksEnded:withEvent:)]) {
        [self.delegate pitchManager:self tracksEnded:endedTracks withEvent:event];
    }
    
    self.tracks = [changedTracks setByAddingObjectsFromSet:newTracks];
}

@end
