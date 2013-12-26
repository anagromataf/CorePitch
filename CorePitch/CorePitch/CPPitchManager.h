//
//  CPPitchManager.h
//  CorePitch
//
//  Created by Tobias Kräntzer on 16.12.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CPPitchManager;
@class CPEvent;

@protocol CPPitchManagerDelegate <NSObject>
@optional

#pragma mark Responding to Events
- (void)pitchManager:(CPPitchManager *)pitchManager tracksBegan:(NSSet *)tracks withEvent:(CPEvent *)event;
- (void)pitchManager:(CPPitchManager *)pitchManager tracksChanged:(NSSet *)tracks withEvent:(CPEvent *)event;
- (void)pitchManager:(CPPitchManager *)pitchManager tracksEnded:(NSSet *)tracks withEvent:(CPEvent *)event;

@end

#pragma mark -

@interface CPPitchManager : NSObject

#pragma mark Accessing the Delegate
@property (assign, nonatomic) id<CPPitchManagerDelegate> delegate;

#pragma mark General Properties
@property (nonatomic, readonly) double sampleRate;

#pragma mark Managing Pitch Updates
- (void)startPitchUpdates;
- (void)stopPitchUpdates;

#pragma mark Tracks
@property (nonatomic, readonly) NSSet *tracks;

@end
