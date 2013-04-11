//
//  APComplexPassport.h
//  AppPassword
//
//  Created by ct on 4/3/13.
//  Copyright (c) 2013 Mitre. All rights reserved.
//

#import "APPass.h"

@interface APComplexPass : APPass <UITextFieldDelegate>

@property (nonatomic, weak)      id  <APPassProtocol>  delegate;

@end
