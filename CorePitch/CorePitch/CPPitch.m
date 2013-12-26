//
//  CPPitch.m
//  CorePitch
//
//  Created by Tobias Kräntzer on 16.12.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import "CPPitch.h"
#import "CPPitch+Private.h"

@implementation CPPitch


#pragma mark Pitch Properties

- (CPPitchStepType)step
{
    NSInteger keyInOctave = self.key - 3 - (12 * (self.octave - 1));
    
    switch (keyInOctave) {
        case 0:
        case 1: return CPPitchStepTypeC;
        case 2:
        case 3: return CPPitchStepTypeD;
        case 4:
        case 5: return CPPitchStepTypeE;
        case 6: return CPPitchStepTypeF;
        case 7:
        case 8: return CPPitchStepTypeG;
        case 9:
        case 10: return CPPitchStepTypeA;
        case 11:
        case 12: return CPPitchStepTypeB;
        default: return CPPitchStepTypeUndefined;
    }
}

- (NSInteger)octave
{
    return (self.key - 3.0) / 12 + 1;
}

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[CPPitch class]]) {
        return NO;
    }

    CPPitch *other = object;
    
    if (other.frequency != self.frequency) {
        return NO;
    }

    if (other.amplitude != self.amplitude) {
        return NO;
    }
    
    return YES;
}

@end

#pragma mark -

@implementation CPPitch (Private)

#pragma mark Life-cycle

- (id)initWithFrequency:(double)frequency amplitude:(double)amplitude
{
    self = [super init];
    if (self) {
        _frequency = frequency;
        _amplitude = amplitude;
        _key = 12 * log2(_frequency / 127.09) + 28.5;
    }
    return self;
}

@end