//
//  CPPitch.m
//  CorePitch
//
//  Created by Tobias Kräntzer on 16.12.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import "CPPitch.h"
#import "CPPitch+Private.h"

@implementation CPPitch


@end

#pragma mark -

@implementation CPPitch (Private)

#pragma mark Life-cycle

- (id)initWithFrequency:(double)frequency
{
    self = [super init];
    if (self) {
        _frequency = frequency;
    }
    return self;
}

@end