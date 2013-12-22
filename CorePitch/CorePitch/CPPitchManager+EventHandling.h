//
//  CPPitchManager+EventHandling.h
//  CorePitch
//
//  Created by Tobias Kräntzer on 20.12.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import "CPPitchManager.h"

@interface CPPitchManager (EventHandling)

#pragma mark Handle Event

- (void)handleEvent:(CPEvent *)event;

@end
