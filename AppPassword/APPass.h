//
//  APPassport.h
//  AppPassword
//
//  Created by ct on 4/2/13.
//  Copyright (c) 2013 Mitre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APProtocol.h"

typedef enum {
    
    PASS_CREATE = 1,
    PASS_VERIFY_CREATE,
    PASS_VERIFY_EXISTING,
    PASS_CREATE_Q,
    PASS_CREATE_A,
    PASS_VERIFY_Q,
    PASS_VERIFY_A,
    PASS_VERIFY_Q_A,
    PASS_VERIFY,
    PASS_RESET,
    PASS_RESET_Q
    
}   PASS_CTL;

@interface APPass : UIViewController 

@property (nonatomic, weak)   UIView              *parentView;
@property (nonatomic, weak)   UIViewController    *parentController;
@property (nonatomic, weak)   id                   delegate;
@property (nonatomic, weak)   UIImage             *background;
@property (nonatomic)         BOOL                 isLandscape;
@property (nonatomic)         NSString            *verify;
@property (nonatomic)         NSArray             *verifyQuestions;
@property (nonatomic, strong) NSString            *syntax;
@property (nonatomic)         BOOL                resetEnabled;
@property (nonatomic)         NSString            *syntaxLabel;
@property (nonatomic)         UIColor             *keyboardKeycolor;
@property (nonatomic)         NSString            *clear;


//------------------------------------------------------------------------------
// SIMPLE PASS
//------------------------------------------------------------------------------
+(APPass*) passWithCodes:(NSInteger) numberOfCodes
        rotatingKeyboard:(BOOL)      rotating;
//------------------------------------------------------------------------------
// SIMPLE PASS - use main bundle
//------------------------------------------------------------------------------
+(APPass*)  passWithName:(NSString*) name
                   codes:(NSInteger) numberOfCodes
        rotatingKeyboard:(BOOL)      rotating
  fromStoryboardWithName:(NSString*) storyboardName;

//------------------------------------------------------------------------------
// COMPLEX PASS
//------------------------------------------------------------------------------
+(APPass*) passComplex;

//------------------------------------------------------------------------------
// COMPLEX PASS - use main bundle
//------------------------------------------------------------------------------
+(APPass*) complexPassWithName:(NSString*) name
        fromStoryboardWithName:(NSString*) storyboardName;


//------------------------------------------------------------------------------
// QUESTION PASS
//------------------------------------------------------------------------------
+(APPass*)       passQuestions:(NSInteger) numberOfQuestions;

//------------------------------------------------------------------------------
// QUESTION PASS - use main bundle
//------------------------------------------------------------------------------
+(APPass*)        passWithName:(NSString*) name
        fromStoryboardWithName:(NSString*) storyboardName
                 withQuestions:(NSInteger) numberOfQuestions;


//-(void) setParentController:(UIViewController *)parent;
@end
