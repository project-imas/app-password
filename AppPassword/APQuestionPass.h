//
//  APQuestionPassport.h
//  AppPassword
//
//  Created by ct on 4/3/13.
//  Copyright (c) 2013 Mitre. All rights reserved.
//

#import "APPass.h"

@interface APQuestionPass : APPass <UITextFieldDelegate>

@property (nonatomic)  NSInteger numberOfQuestions;

@property (nonatomic, weak)      id  <APQuestionProtocol>  delegate;

@end
