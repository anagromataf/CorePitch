//
//  CPPitchManager+EventHandling.m
//  CorePitch
//
//  Created by Tobias Kräntzer on 20.12.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import "CPEvent.h"
#import "CPPitch.h"

#import "CPPitchManager+EventHandling.h"

@implementation CPPitchManager (EventHandling)

#pragma mark Handle Event

- (void)handleEvent:(CPEvent *)event
{
    // Handle CPPitchPhaseBegan
    if ([self.delegate respondsToSelector:@selector(pitchManager:pitchesBegan:withEvent:)]) {
        NSSet *pitches = [event.allPitches filteredSetUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(CPPitch *pitch, NSDictionary *bindings) {
            return pitch.phase == CPPitchPhaseBegan;
        }]];
        if ([pitches count] > 0) {
            [self.delegate pitchManager:self pitchesBegan:pitches withEvent:event];
        }
    }
    
    // Handle CPPitchPhaseChanged
    if ([self.delegate respondsToSelector:@selector(pitchManager:pitchesChanged:withEvent:)]) {
        NSSet *pitches = [event.allPitches filteredSetUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(CPPitch *pitch, NSDictionary *bindings) {
            return pitch.phase == CPPitchPhaseChanged;
        }]];
        if ([pitches count] > 0) {
            [self.delegate pitchManager:self pitchesChanged:pitches withEvent:event];
        }
    }
    
    // Handle CPPitchPhaseEnded
    if ([self.delegate respondsToSelector:@selector(pitchManager:pitchesEnded:withEvent:)]) {
        NSSet *pitches = [event.allPitches filteredSetUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(CPPitch *pitch, NSDictionary *bindings) {
            return pitch.phase == CPPitchPhaseEnded;
        }]];
        if ([pitches count] > 0) {
            [self.delegate pitchManager:self pitchesEnded:pitches withEvent:event];
        }
    }
}

@end
