//
//  IMSTestScenario.m
//  Sample App
//
//  Created by Caleb Davenport on 12/9/12.
//  Copyright (c) 2012 The MITRE Corporation. All rights reserved.
//

#import "IMSTestScenario.h"
#import "IMSTestStep.h"

@implementation IMSTestScenario

+ (instancetype)scenarioToCreatePasswordWithDifferentInputValues {
    IMSTestScenario *scenario = [IMSTestScenario scenarioWithDescription:@"Test creating a password with different input values."];
    
    [scenario addStepsFromArray:[IMSTestStep stepsToLoadCreatePasswordView]];
    [scenario addStep:[IMSTestStep stepToEnterText:@"one" intoViewWithAccessibilityLabel:@"Create password"]];
    [scenario addStep:[IMSTestStep stepToEnterText:@"two" intoViewWithAccessibilityLabel:@"Verify password"]];
    [scenario addStep:[IMSTestStep stepToTapViewWithAccessibilityLabel:@"Done"]];
    [scenario addStep:[IMSTestStep stepToWaitForViewWithAccessibilityLabel:@"The provided passcodes do not match."]];
    [scenario addStep:[IMSTestStep stepToTapViewWithAccessibilityLabel:@"OK"]];
    [scenario addStep:[IMSTestStep stepToTapViewWithAccessibilityLabel:@"Cancel"]];
    
    return scenario;
}

+ (instancetype)scenarioToCreatePasswordThatFailsToMeetSecurityRequirements {
    IMSTestScenario *scenario = [IMSTestScenario scenarioWithDescription:@"Test creating an insecure password."];
    
    [scenario addStepsFromArray:[IMSTestStep stepsToLoadCreatePasswordView]];
    [scenario addStep:[IMSTestStep stepToEnterText:@"password" intoViewWithAccessibilityLabel:@"Create password"]];
    [scenario addStep:[IMSTestStep stepToEnterText:@"password" intoViewWithAccessibilityLabel:@"Verify password"]];
    [scenario addStep:[IMSTestStep stepToTapViewWithAccessibilityLabel:@"Done"]];
    [scenario addStep:[IMSTestStep stepToWaitForViewWithAccessibilityLabel:@"The password does not meet security requirements."]];
    [scenario addStep:[IMSTestStep stepToTapViewWithAccessibilityLabel:@"OK"]];
    [scenario addStep:[IMSTestStep stepToTapViewWithAccessibilityLabel:@"Cancel"]];
    
    return scenario;
}

+ (instancetype)scenarioToCreatePasswordThatSucceeds {
    IMSTestScenario *scenario = [IMSTestScenario scenarioWithDescription:@"Test creating a password that succeeds."];
    
    [scenario addStepsFromArray:[IMSTestStep stepsToLoadCreatePasswordView]];
    [scenario addStep:[IMSTestStep stepToEnterText:@"password1" intoViewWithAccessibilityLabel:@"Create password"]];
    [scenario addStep:[IMSTestStep stepToEnterText:@"password1" intoViewWithAccessibilityLabel:@"Verify password"]];
    [scenario addStep:[IMSTestStep stepToTapViewWithAccessibilityLabel:@"Done"]];
    [scenario addStep:[IMSTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Verify Password"]];
    
    return scenario;
}

+ (instancetype)scenarioToVerifyPassword {
    IMSTestScenario *scenario = [IMSTestScenario scenarioWithDescription:@"Test verifying a password."];
    
    [scenario addStepsFromArray:[IMSTestStep stepsToLoadVerifyPasswordView]];
    [scenario addStep:[IMSTestStep stepToEnterText:@"a" intoViewWithAccessibilityLabel:@"Verify password"]];
    [scenario addStep:[IMSTestStep stepToTapViewWithAccessibilityLabel:@"Go"]];
    [scenario addStep:[IMSTestStep stepToWaitForViewWithAccessibilityLabel:@"The provided password is incorrect."]];
    [scenario addStep:[IMSTestStep stepToTapViewWithAccessibilityLabel:@"OK"]];
    [scenario addStep:[IMSTestStep stepToEnterText:@"password1" intoViewWithAccessibilityLabel:@"Verify password"]];
    [scenario addStep:[IMSTestStep stepToTapViewWithAccessibilityLabel:@"Go"]];
    [scenario addStep:[IMSTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Reset keychain"]];
    
    return scenario;
}

+ (instancetype)scenarioToResetKeychain {
    IMSTestScenario *scenario = [IMSTestScenario scenarioWithDescription:@"Test verifying a password."];
    
    [scenario addStep:[IMSTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Reset keychain"]];
    [scenario addStep:[IMSTestStep stepToTapViewWithAccessibilityLabel:@"Reset keychain"]];
    
    return scenario;
}

@end
