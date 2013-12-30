//
//  CPPitchManager+Private.h
//  CorePitch
//
//  Created by Tobias Kräntzer on 16.12.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>

#import "CPPitchManager.h"

@interface CPPitchManager (Private)

#pragma mark General Properties
@property (nonatomic, readonly) double sampleRate;

#pragma mark Process Samples
- (NSSet *)processSamples:(AudioBuffer)samples;

#pragma mark Handle Event
- (void)handleEvent:(CPEvent *)event;

#pragma mark Input Queue
@property (nonatomic, readonly) AudioStreamBasicDescription inputStreamDescription;
@property (nonatomic, readonly) AudioQueueRef inputQueue;

@end

#pragma mark -

void CPPitchManagerAudioQueueInputCallback(void                                *aqData,
                                           AudioQueueRef                       inAQ,
                                           AudioQueueBufferRef                 inBuffer,
                                           const AudioTimeStamp                *inStartTime,
                                           UInt32                              inNumPackets,
                                           const AudioStreamPacketDescription  *inPacketDesc);
