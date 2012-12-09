//
//  IMSTestStep.m
//  Sample App
//
//  Created by Caleb Davenport on 12/9/12.
//  Copyright (c) 2012 The MITRE Corporation. All rights reserved.
//

#import "IMSTestStep.h"

@implementation IMSTestStep

+ (NSArray *)stepsToLoadCreatePasswordView {
    return @[
        [[self class] stepToWaitForTappableViewWithAccessibilityLabel:@"Create password"],
        [[self class] stepToTapViewWithAccessibilityLabel:@"Create password"],
        [[self class] stepToWaitForViewWithAccessibilityLabel:@"Create password"]
    ];
}

+ (NSArray *)stepsToLoadVerifyPasswordView {
    return @[
        [[self class] stepToWaitForTappableViewWithAccessibilityLabel:@"Verify password"],
        [[self class] stepToTapViewWithAccessibilityLabel:@"Verify password"],
        [[self class] stepToWaitForViewWithAccessibilityLabel:@"Verify password"]
    ];
}

@end
