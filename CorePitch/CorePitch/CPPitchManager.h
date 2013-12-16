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

#pragma mark Responding to Pitch Events
- (void)pitchManager:(CPPitchManager *)pitchManager pitchesBegan:(NSSet *)pitches withEvent:(CPEvent *)event;
- (void)pitchManager:(CPPitchManager *)pitchManager pitchesChanged:(NSSet *)pitches withEvent:(CPEvent *)event;
- (void)pitchManager:(CPPitchManager *)pitchManager pitchesEnded:(NSSet *)pitches withEvent:(CPEvent *)event;
- (void)pitchManager:(CPPitchManager *)pitchManager pitchesCancelled:(NSSet *)pitches withEvent:(CPEvent *)event;

@end

#pragma mark -

@interface CPPitchManager : NSObject

#pragma mark Accessing the Delegate
@property (assign, nonatomic) id<CPPitchManagerDelegate> delegate;

#pragma mark Managing Pitch Updates
- (void)startPitchUpdates;
- (void)stopPitchUpdates;

@end
