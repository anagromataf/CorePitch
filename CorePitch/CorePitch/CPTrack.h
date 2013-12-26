//
//  CPTrack.h
//  CorePitch
//
//  Created by Tobias Kräntzer on 26.12.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CPPitch.h"

@interface CPTrack : NSObject

#pragma mark Getting Track Attributes
- (CPPitch *)pitchAtTimestamp:(NSTimeInterval)timestamp;

@end
