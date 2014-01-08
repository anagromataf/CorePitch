//
//  CPAppDelegate.m
//  Demo
//
//  Created by Tobias Kräntzer on 08.01.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "CPAppDelegate.h"

@interface CPAppDelegate () <CPPitchManagerDelegate>

@end

@implementation CPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    // Set up pitch manager
    self.pitchManager = [[CPPitchManager alloc] init];
    self.pitchManager.delegate = self;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self.pitchManager stopPitchUpdates];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            [self.pitchManager startPitchUpdates];
        }
    }];
}

#pragma mark - CPPitchManagerDelegate

- (void)pitchManager:(CPPitchManager *)pitchManager tracksBegan:(NSSet *)tracks withEvent:(CPEvent *)event
{
    
}

- (void)pitchManager:(CPPitchManager *)pitchManager tracksChanged:(NSSet *)tracks withEvent:(CPEvent *)event
{
    
}

- (void)pitchManager:(CPPitchManager *)pitchManager tracksEnded:(NSSet *)tracks withEvent:(CPEvent *)event
{
    
}

@end
