//
//  CPPitchManager+Private.h
//  CorePitch
//
//  Created by Tobias Kräntzer on 16.12.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import <CoreAudio/CoreAudioTypes.h>

#import "CPPitchManager.h"

@interface CPPitchManager (Private)

#pragma mark Process Samples
- (void)processSamples:(AudioBuffer)samples;

#pragma mark Handle Pitch Event
- (void)handleEvent:(CPEvent *)event;

@end
