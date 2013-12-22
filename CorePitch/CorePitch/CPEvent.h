//
//  CPEvent.h
//  CorePitch
//
//  Created by Tobias Kräntzer on 16.12.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPEvent : NSObject

#pragma mark Getting Event Attributes
@property (nonatomic, readonly) NSTimeInterval timestamp;

#pragma mark Getting the Pitches for an Event
@property (nonatomic, readonly) NSSet *allPitches;

@end
