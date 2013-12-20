//
//  CPEvent+Private.h
//  CorePitch
//
//  Created by Tobias Kräntzer on 20.12.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import "CPEvent.h"

@interface CPEvent (Private)

- (id)initWithTimestamp:(NSTimeInterval)timestamp pitches:(NSSet *)pitches;

@end
