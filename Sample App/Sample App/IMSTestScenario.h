//
//  IMSTestScenario.h
//  Sample App
//
//  Created by Caleb Davenport on 12/9/12.
//  Copyright (c) 2012 The MITRE Corporation. All rights reserved.
//

#import "KIFTestScenario.h"

@interface IMSTestScenario : KIFTestScenario

+ (instancetype)scenarioToCreatePasswordWithDifferentInputValues;

+ (instancetype)scenarioToCreatePasswordThatFailsToMeetSecurityRequirements;

+ (instancetype)scenarioToCreatePasswordThatSucceeds;

+ (instancetype)scenarioToVerifyPassword;

+ (instancetype)scenarioToResetKeychain;

@end
