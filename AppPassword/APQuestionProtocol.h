//
//  APQuestionProtocol.h
//  AppPassword
//
//  Created by ct on 4/8/13.
//  Copyright (c) 2013 MITRE. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APQuestionProtocol <NSObject>

// -----------------------------------------------------------------------------
// Implement if using questions
// Array of dictionaries with key(question) value(answer)
// -----------------------------------------------------------------------------

-(void) APPassComplete:(UIViewController *) viewController
         withQuestions:(NSArray *)          questions
            andAnswers:(NSArray *)          answers;


@optional

-(BOOL) APPassQuestion:(UIViewController *) viewController
         verifyAnswers:(NSArray *)          answers;

-(void) APPassQuestionVerified:(UIViewController *) viewController
                   verifyState:(BOOL)               verify;

-(void) resetQuestionAP;

@end
