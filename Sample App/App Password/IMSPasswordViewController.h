//
//  IMSPasswordViewController.h
//
//  Created by Caleb Davenport on 11/8/12.
//  Copyright (c) 2012 The MITRE Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(short, IMSPasswordViewControllerMode) {
    
    /*
     
     Create a new password. This allows the user to enter a new password then
     imediately verify it.
     
     */
    IMSPasswordViewControllerModeCreate = 1,
    
    /*
     
     Verify a password. This allows the user to input a password then have it
     checked by the caller.
     
     */
    IMSPasswordViewControllerModeVerify
    
};

@interface IMSPasswordViewController : UIViewController <UITextFieldDelegate>

/*
 
 Refer to `IMSPasswordViewControllerMode`. This must be set before the view is
 loaded (before you present the controller).
 
 */
@property (nonatomic, assign) IMSPasswordViewControllerMode mode;

/*
 
 Object that is interested in callbacks from the password controller.
 
 */
@property (nonatomic, weak) id target;

/*
 
 Action called on the `target`. This must take two parameters. The first is
 an instance of `IMSPasswordViewController` and the second is the resulting
 password.
 
 In password creation mode, this method can have a `void` return type as its
 return value is ignored. Use it to save the provided password.
 
 In password verification mode, this method must have a `BOOL` return type so
 that the controller can update its interface and show an error message.
 
 You should dismiss the provided controller in this action if the data is
 acceptable.
 
 */
@property (nonatomic, assign) SEL action;

/*
 
 Used when creating a password to make sure that it meets security policy
 requirements. This is evaulated as a regex on the user provided text. The
 default pattern enforces one upper-case letter, one lower-case letter, one
 number, and at least six characters.
 
 */
@property (nonatomic, copy) NSString *passwordSecurityPattern;

/*
 
 
 
 */
+ (UIStoryboard *)storyboard;

/*
 
 
 
 */
+ (NSString *)storyboardBaseName;

@end
