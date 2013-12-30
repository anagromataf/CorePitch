//
//  CPPitchManager.m
//  CorePitch
//
//  Created by Tobias Kräntzer on 16.12.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#include <Accelerate/Accelerate.h>
#import <AudioToolbox/AudioToolbox.h>


#import "CPEvent.h"
#import "CPPitch.h"
#import "CPTrack.h"

#import "CPEvent+Private.h"
#import "CPPitch+Private.h"
#import "CPTrack+Private.h"

#import "CPPitchManager.h"
#import "CPPitchManager+Private.h"

#define FFTLength 12
#define NumberOfInputSamples (1u << 10)
#define NumberOfProcessingSamples (1u << 12)

@interface CPPitchManager () {
    FFTSetup _FFTSetup;
    float *_window;
    float *_preperationBuffer;
    float *_processingBuffer;
    float *_magnitudes;
}

#pragma mark Tracks
@property (nonatomic, strong) NSSet *tracks;

#pragma mark General Properties
@property (nonatomic, assign) double sampleRate;
@property (nonatomic, assign) NSTimeInterval bufferDuration;

@end

#pragma mark -

@implementation CPPitchManager

#pragma mark Life-cycle

- (id)init
{
    self = [super init];
    if (self) {
        _sampleRate = 44100.0;
        
        _window = calloc(sizeof(float), NumberOfInputSamples);
        _preperationBuffer = calloc(sizeof(float), NumberOfProcessingSamples);
        _processingBuffer  = calloc(sizeof(float), NumberOfProcessingSamples);
        _magnitudes        = calloc(sizeof(float), NumberOfProcessingSamples / 2);
        _FFTSetup = vDSP_create_fftsetup(FFTLength, FFT_RADIX2);
        vDSP_hamm_window(_window, NumberOfInputSamples, 0);
        
        _tracks = [[NSSet alloc] init];
    }
    return self;
}

- (void)dealloc
{
    vDSP_destroy_fftsetup(_FFTSetup);
    
    free(_magnitudes);
    free(_processingBuffer);
    free(_preperationBuffer);
    free(_window);
}

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
    NSParameterAssert(samples.mNumberChannels == 1);
    NSParameterAssert(samples.mDataByteSize == sizeof(float) * NumberOfInputSamples);
    
    
    // Prepare the input buffer
    // ------------------------
    
    // Clear the Preperation Buffer
    memset(_preperationBuffer, 0, sizeof(float) * NumberOfProcessingSamples);
    
    // Copy the windowed first half of the input samples to the end of the processing buffer
    float *inputA       = samples.mData;
    float *windowA      = _window;
    float *preperationA = _preperationBuffer + NumberOfProcessingSamples - (NumberOfInputSamples / 2);
    vDSP_vmul(inputA, 1, windowA, 1, preperationA, 1, NumberOfInputSamples/2);
    
    // Copy the windowed second half of the input samples to the begin of the processing buffer
    float *inputB       = (float *)(samples.mData) + NumberOfInputSamples / 2;
    float *windowB      = _window + NumberOfInputSamples / 2;
    float *preperationB = _preperationBuffer;
    vDSP_vmul(inputB, 1, windowB, 1, preperationB, 1, NumberOfInputSamples/2);
    
    // Copy the input samples to the processing buffer in the even-odd split configuration.
	DSPSplitComplex FFTBuffer = { _processingBuffer, _processingBuffer + NumberOfProcessingSamples/2 };
    vDSP_ctoz((DSPComplex *)_preperationBuffer, 2, &FFTBuffer, 1, NumberOfProcessingSamples/2);
    
    
    // Covert buffer to the frquency domain
    // ------------------------------------
    
    // Perform a real-to-complex FFT.
	vDSP_fft_zrip(_FFTSetup, &FFTBuffer, 1, FFTLength, FFT_FORWARD);
    
    // Get the magnitudes
    vDSP_zvabs(&FFTBuffer, 1, _magnitudes, 1, NumberOfProcessingSamples/2);
    
    
    // Analyse magentudes
    // ------------------
    
    NSMutableSet *pitches = [NSMutableSet set];
    
    // Convert to db
    Float32 one = 1;
    vDSP_vdbcon(_magnitudes, 1, &one, _magnitudes, 1, NumberOfProcessingSamples/2, 0);
    
    // Get the index of the bin with the highest frequency
    float maxValue;
    vDSP_Length index;
    
    vDSP_maxvi(_magnitudes, 1, &maxValue, &index, NumberOfProcessingSamples/2);

    
    // Print magnitudes
    #if 0
    printf("\n");
    for (int i = 0; i < MIN(300, NumberOfProcessingSamples / 2); i++) {
        float m = _magnitudes[i];
        printf("%4d ", i);
        int x = (m / maxValue) * 150;
        for (int xi = 0; xi < x; xi++) {
            printf(".");
        }
        printf("*\n");
    }
    #endif
    
    // Interpolate the peak magnitude
    double alpha    = _magnitudes[index - 1];
    double beta     = _magnitudes[index];
    double gamma    = _magnitudes[index + 1];
    
    double p = 0.5 * (alpha - gamma) / (alpha - 2 * beta + gamma);
    
    double frequency = ((long)index + p) * self.sampleRate / (float)(NumberOfProcessingSamples);
    
    [pitches addObject:[[CPPitch alloc] initWithFrequency:frequency amplitude:maxValue]];
    
    return pitches;
}

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

#pragma mark -

void CPPitchManagerAudioQueueInputCallback(void                                *aqData,
                                           AudioQueueRef                       inAQ,
                                           AudioQueueBufferRef                 inBuffer,
                                           const AudioTimeStamp                *inStartTime,
                                           UInt32                              inNumPackets,
                                           const AudioStreamPacketDescription  *inPacketDesc)
{
    CPPitchManager *pitchManager = (__bridge CPPitchManager *)aqData;
    
    // For now expecting the number of Packets to be the same as the log2n of the "fftLength"
    // and checking the size of the input buffer.
    if (NumberOfInputSamples != inNumPackets) return;
    if (inBuffer->mAudioDataByteSize != sizeof(float) * NumberOfInputSamples) return;
    
    AudioBuffer buffer = {
        .mNumberChannels = 1,
        .mDataByteSize = inBuffer->mAudioDataByteSize,
        .mData = inBuffer->mAudioData
    };
    
    @autoreleasepool {
        NSSet *pitches = [pitchManager processSamples:buffer];
        CPEvent *event = [[CPEvent alloc] initWithTimestamp:[[NSProcessInfo processInfo] systemUptime] pitches:pitches];
        [pitchManager performSelectorOnMainThread:@selector(handleEvent:) withObject:event waitUntilDone:NO];
    }
    
    // Enqueue the used Buffer.
    if (pitchManager.isRunning == true) {
        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
    }
}
