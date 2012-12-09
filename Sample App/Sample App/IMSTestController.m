//
//  IMSTestController.m
//  Sample App
//
//  Created by Caleb Davenport on 12/9/12.
//  Copyright (c) 2012 The MITRE Corporation. All rights reserved.
//

#import "IMSTestController.h"
#import "IMSTestScenario.h"

@implementation IMSTestController

- (void)initializeScenarios {
    [self addScenario:[IMSTestScenario scenarioToCreatePasswordWithDifferentInputValues]];
    [self addScenario:[IMSTestScenario scenarioToCreatePasswordThatFailsToMeetSecurityRequirements]];
    [self addScenario:[IMSTestScenario scenarioToCreatePasswordThatSucceeds]];
    [self addScenario:[IMSTestScenario scenarioToVerifyPassword]];
    [self addScenario:[IMSTestScenario scenarioToResetKeychain]];
    
}

@end
