//
//  CPAppDelegate.h
//  Demo
//
//  Created by Tobias Kräntzer on 08.01.14.
//  Copyright (c) 2014 Tobias Kräntzer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CorePitch/CorePitch.h>

@interface CPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CPPitchManager *pitchManager;

@end
