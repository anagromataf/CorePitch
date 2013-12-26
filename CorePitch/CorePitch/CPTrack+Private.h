//
//  CPTrack+Private.h
//  CorePitch
//
//  Created by Tobias Kräntzer on 26.12.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import "CPTrack.h"

@interface CPTrack (Private)

#pragma mark Managing Track Pitches
- (void)addPitch:(CPPitch *)pitch atTimestamp:(NSTimeInterval)timestamp;

@end
