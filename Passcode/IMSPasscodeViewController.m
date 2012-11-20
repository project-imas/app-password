//
//  IMSPasscodeViewController.m
//
//  Created by Caleb Davenport on 11/8/12.
//  Copyright (c) 2012 The MITRE Corporation. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

#import "IMSPasscodeViewController.h"

@interface IMSPasscodeViewController ()

@property (nonatomic, weak) IBOutlet UITextField *passcodeOneField;
@property (nonatomic, weak) IBOutlet UITextField *passcodeTwoField;
@property (nonatomic, copy) IBOutletCollection(UITextField) NSArray *passcodeFields;

@end

@implementation IMSPasscodeViewController

#pragma mark - object methods

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _mode = 0;
        self.passcodeSecurityPattern = @"^.*(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.{6,}).*$";
    }
    return self;
}

- (void)setMode:(IMSPasscodeViewControllerMode)mode {
    NSParameterAssert(mode > 0 && mode < 3);
    if (_mode == 0) { _mode = mode; }
}

#pragma mark - view lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSParameterAssert(self.mode != 0);
    NSParameterAssert(self.target != nil);
    NSParameterAssert(self.action != 0);
    
    // ui
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.passcodeFields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj setSecureTextEntry:YES];
        [obj setEnablesReturnKeyAutomatically:YES];
        [obj setDelegate:self];
        [obj addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    [self.passcodeOneField becomeFirstResponder];
    [self.navigationItem.rightBarButtonItem setAction:@selector(doneButtonAction:)];
    
}

- (NSUInteger)supportedInterfaceOrientations {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskLandscape;
    }
    else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

#pragma mark - button actions

- (IBAction)doneButtonAction:(id)sender {
    if (self.mode == IMSPasscodeViewControllerModeCreate) {
        [self createPasscode];
    }
    else if (self.mode == IMSPasscodeViewControllerModeVerify) {
        [self verifyPasscode];
    }
}

- (void)createPasscode {
    NSParameterAssert(self.mode == IMSPasscodeViewControllerModeCreate);
    NSString *passcode = [self.passcodeOneField.text copy];
    if ([passcode isEqualToString:self.passcodeTwoField.text]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.passcodeSecurityPattern];
        if ([predicate evaluateWithObject:passcode]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.target performSelector:self.action withObject:self withObject:passcode];
#pragma clang diagnostic pop
        }
        else {
            [[[UIAlertView alloc]
              initWithTitle:@"The passcode does not meet security requirements."
              message:nil
              delegate:nil
              cancelButtonTitle:@"OK"
              otherButtonTitles:nil]
             show];
        }
    }
    else {
        [self.passcodeFields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj setText:nil];
        }];
        [self.passcodeOneField becomeFirstResponder];
        [[[UIAlertView alloc]
          initWithTitle:@"The provided passcodes do not match."
          message:nil
          delegate:nil
          cancelButtonTitle:@"OK"
          otherButtonTitles:nil]
         show];
    }
}

- (void)verifyPasscode {
    NSParameterAssert(self.mode == IMSPasscodeViewControllerModeVerify);
    NSString *passcode = [self.passcodeOneField.text copy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    BOOL valid = (BOOL)[self.target performSelector:self.action withObject:self withObject:passcode];
#pragma clang diagnostic pop
    if (!valid) {
        self.passcodeOneField.text = nil;
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [[[UIAlertView alloc]
          initWithTitle:@"MESSAGE"
          message:nil
          delegate:nil
          cancelButtonTitle:@"OK"
          otherButtonTitles:nil]
         show];
    }
}

#pragma mark - text field methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.mode == IMSPasscodeViewControllerModeVerify) {
        [self verifyPasscode];
    }
    else if (self.mode == IMSPasscodeViewControllerModeCreate) {
        if (textField == self.passcodeOneField) {
            [self.passcodeTwoField becomeFirstResponder];
        }
        else {
            [self createPasscode];
        }
    }
    return NO;
}

- (IBAction)textFieldTextDidChange:(UITextField *)sender {
    BOOL enabled = ([self.passcodeOneField.text length] > 0);
    if (self.mode == IMSPasscodeViewControllerModeCreate) {
        enabled = (enabled && [self.passcodeTwoField.text length] > 0);
    }
    self.navigationItem.rightBarButtonItem.enabled = enabled;
}

@end
