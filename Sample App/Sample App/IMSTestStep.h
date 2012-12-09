//
//  IMSTestStep.h
//  Sample App
//
//  Created by Caleb Davenport on 12/9/12.
//  Copyright (c) 2012 The MITRE Corporation. All rights reserved.
//

#import "KIFTestStep.h"

@interface IMSTestStep : KIFTestStep

//+ (instancetype)stepToReset;

+ (NSArray *)stepsToLoadCreatePasswordView;

+ (NSArray *)stepsToLoadVerifyPasswordView;

@end
