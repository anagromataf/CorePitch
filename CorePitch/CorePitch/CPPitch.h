//
//  CPPitch.h
//  CorePitch
//
//  Created by Tobias Kräntzer on 16.12.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CPPitchPhase) {
    CPPitchBegan,
    CPPitchChanged,
    CPPitchStationary,
    CPPitchEnded
};

typedef NS_ENUM(NSUInteger, CPPitchStepType) {
    CPPitchStepTypeUndefined    = 0,
    CPPitchStepTypeC            = 1,
    CPPitchStepTypeD            = 2,
    CPPitchStepTypeE            = 3,
    CPPitchStepTypeF            = 4,
    CPPitchStepTypeG            = 5,
    CPPitchStepTypeA            = 6,
    CPPitchStepTypeB            = 7
};

@interface CPPitch : NSObject

@property (nonatomic, readonly) NSTimeInterval timespamp;
@property (nonatomic, readonly) CPPitchPhase phase;

@property (nonatomic, readonly) double frequency;
@property (nonatomic, readonly) double amplitude;

#pragma mark Pitch Properties
@property (nonatomic, readonly) CPPitchStepType step;
@property (nonatomic, readonly) NSInteger alter;
@property (nonatomic, readonly) NSInteger octave;

#pragma mark Piano Key
@property (nonatomic, readonly) NSInteger key;

@end
