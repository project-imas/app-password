//
//  IMSPasscodeViewController.m
//
//  Created by Caleb Davenport on 11/8/12.
//  Copyright (c) 2012 The MITRE Corporation. All rights reserved.
//

#import "IMSPasscodeViewController.h"

@interface IMSPasscodeViewController ()

@property (nonatomic, weak) IBOutlet UITextField *passcodeOneField;
@property (nonatomic, weak) IBOutlet UITextField *passcodeTwoField;

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
    
}

#pragma mark - button actions

- (IBAction)createPasscode {
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
        [[[UIAlertView alloc]
          initWithTitle:@"The provided passcodes do not match."
          message:nil
          delegate:nil
          cancelButtonTitle:@"OK"
          otherButtonTitles:nil]
         show];
    }
}

- (IBAction)verifyPasscode {
    NSParameterAssert(self.mode == IMSPasscodeViewControllerModeVerify);
    NSString *passcode = [self.passcodeOneField.text copy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    BOOL valid = (BOOL)[self.target performSelector:self.action withObject:self withObject:passcode];
#pragma clang diagnostic pop
    if (!valid) {
        self.passcodeOneField.text = nil;
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
