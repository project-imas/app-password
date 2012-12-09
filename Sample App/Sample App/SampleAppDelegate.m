//
//  IMSAppDelegate.m
//  Passcode
//
//  Created by Caleb Davenport on 11/8/12.
//  Copyright (c) 2012 The MITRE Corporation. All rights reserved.
//

#import "SampleAppDelegate.h"

#if IMS_KIF_TESTS
#import "IMSTestController.h"
#endif

@implementation SampleAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)options {
    
    // run tests
#if IMS_KIF_TESTS
    IMSTestController *testController = [IMSTestController sharedInstance];
    [testController startTestingWithCompletionBlock:^{
        exit([testController failureCount]);
    }];
#endif
    
    // return
    return YES;
    
}

@end
