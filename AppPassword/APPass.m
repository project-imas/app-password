//
//  APPassport.m
//  AppPassword
//
//  Created by ct on 4/2/13.
//  Copyright (c) 2013 Mitre. All rights reserved.
//

#import "APPass.h"
#import "APSimplePass.h"
#import "APComplexPass.h"
#import "APQuestionPass.h"

@implementation APPass

//------------------------------------------------------------------------------
// Simple Passcode
//------------------------------------------------------------------------------

+(APPass*) passWithCodes:(NSInteger) numberOfCodes
        rotatingKeyboard:(BOOL)      rotating       {
    
    APSimplePass *simplePass;
    UIStoryboard *storyboard;
    NSString     *name = @"APSimplePass";
    NSString     *storyboardName;
    NSString     *bundlePath;
    NSBundle     *storyboardBundle;
    
    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        storyboardName = [name stringByAppendingString:@"_iPad"];
    else
        storyboardName = [name stringByAppendingString:@"_iPhone"];

    
    bundlePath         = [[NSBundle mainBundle] pathForResource:@"AppPassword"
                                                         ofType:@"framework"];
    
    storyboardBundle   = [NSBundle bundleWithPath:bundlePath];
    
    
    storyboard         = [UIStoryboard storyboardWithName:storyboardName
                                                   bundle:storyboardBundle];
    
    simplePass         = [storyboard
                          instantiateViewControllerWithIdentifier:name];
    
    simplePass.keyboardRotating = rotating;
    
    simplePass.iPad             = [storyboardName hasSuffix:@"iPad"];
    
    [simplePass setNumberOfCodes:numberOfCodes];
    
   return simplePass;
}

+(APPass*)  passWithName:(NSString*) name
                   codes:(NSInteger) numberOfCodes
        rotatingKeyboard:(BOOL)      rotating
  fromStoryboardWithName:(NSString*) storyboardName {
    APSimplePass  *simplePass;
    UIStoryboard  *storyboard;
    
    storyboard         = [UIStoryboard storyboardWithName:storyboardName
                                                   bundle:nil];
    simplePass         = [storyboard
                          instantiateViewControllerWithIdentifier:name];
    
    simplePass.keyboardRotating = rotating;
    
    simplePass.iPad             = [storyboardName hasSuffix:@"iPad"];
    
    [simplePass setNumberOfCodes:numberOfCodes];

    return simplePass;
}

//------------------------------------------------------------------------------
// Complex Passcode
//------------------------------------------------------------------------------
+(id) passComplex {
    
    APComplexPass *complexPass;
    UIStoryboard  *storyboard;
    NSString      *name = @"APComplexPass";
    NSString      *storyboardName;
    NSString      *bundlePath;
    NSBundle      *storyboardBundle;
    
    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        storyboardName = [name stringByAppendingString:@"_iPad"];
    else
        storyboardName = [name stringByAppendingString:@"_iPhone"];
    
    bundlePath         = [[NSBundle mainBundle] pathForResource:@"AppPassword"
                                                         ofType:@"framework"];
    
    storyboardBundle   = [NSBundle bundleWithPath:bundlePath];
    
    
    storyboard         = [UIStoryboard storyboardWithName:storyboardName
                                                   bundle:storyboardBundle];
    
    complexPass        = [storyboard
                          instantiateViewControllerWithIdentifier:name];
        
    return complexPass;
}

+(APPass*)  complexPassWithName:(NSString*) name
         fromStoryboardWithName:(NSString*) storyboardName        {
    
    APComplexPass *complexPass;
    UIStoryboard  *storyboard;
    
    storyboard         = [UIStoryboard storyboardWithName:storyboardName
                                                   bundle:nil];
    complexPass        = [storyboard
                          instantiateViewControllerWithIdentifier:name];
    
    return complexPass;
}


//------------------------------------------------------------------------------
// Questions
//------------------------------------------------------------------------------

+(APPass*)       passQuestions:(NSInteger) numberOfQuestions {
    
    APQuestionPass *questionPass;
    UIStoryboard   *storyboard;
    NSString       *name = @"APQuestionPass";
    NSString       *storyboardName;
    NSString       *bundlePath;
    NSBundle       *storyboardBundle;
    
    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        
        storyboardName = [name stringByAppendingString:@"_iPad"];
    else
        storyboardName = [name stringByAppendingString:@"_iPhone"];
    
    
    bundlePath         = [[NSBundle mainBundle] pathForResource:@"AppPassword"
                                                         ofType:@"framework"];
    
    storyboardBundle   = [NSBundle bundleWithPath:bundlePath];
    
    
    storyboard         = [UIStoryboard storyboardWithName:storyboardName
                                                   bundle:storyboardBundle];
    
    questionPass       = [storyboard
                          instantiateViewControllerWithIdentifier:name];
    
    questionPass.numberOfQuestions = numberOfQuestions;
    
    return questionPass;
}

+(APPass*)        passWithName:(NSString*) name
        fromStoryboardWithName:(NSString*) storyboardName
                 withQuestions:(NSInteger) numberOfQuestions {
    
    APQuestionPass *questionPass;

    UIStoryboard  *storyboard;
    
    storyboard         = [UIStoryboard storyboardWithName:storyboardName
                                                   bundle:nil];
    questionPass       = [storyboard
                          instantiateViewControllerWithIdentifier:name];

    questionPass.numberOfQuestions = numberOfQuestions;
    
    return questionPass;
}

//------------------------------------------------------------------------------
// 
//------------------------------------------------------------------------------

-(void) viewDidLoad {
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    _isLandscape = UIDeviceOrientationIsLandscape(orientation);

}
-(void) setParentController:(UIViewController *)parent {

    if ( nil != parent ) {
            
        UINavigationController *navController =
        
        [[UINavigationController alloc] initWithRootViewController:self];        
        
        [parent presentViewController:navController
                             animated:YES
                           completion:nil];
    }
}

-(void) setParentView:(UIView *)parentView {
    
    _parentView = parentView;
    [parentView addSubview:self.view];
}

@end
