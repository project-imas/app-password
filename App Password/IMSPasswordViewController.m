//
//  IMSPasswordViewController.m
//
//  Created by Caleb Davenport on 11/8/12.
//  Copyright (c) 2012 The MITRE Corporation. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

#import "IMSPasswordViewController.h"

@interface IMSPasswordViewController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *passwordOneField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTwoField;
@property (nonatomic, copy) IBOutletCollection(UITextField) NSArray *passwordFields;

@end

@implementation IMSPasswordViewController

#pragma mark - class methods

+ (UIStoryboard *)storyboard {
    static UIStoryboard *storyboard = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSMutableString *name = [NSMutableString stringWithString:[self storyboardBaseName]];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [name appendString:@"_iPad"];
        }
        else {
            [name appendString:@"_iPhone"];
        }
        storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    });
    return storyboard;
}

+ (NSString *)storyboardBaseName {
    return @"IMSPasswordStoryboard";
}

+ (NSString *)localizedStringForKey:(NSString *)key {
    static NSBundle *bundle = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSURL *URL = [[NSBundle mainBundle] URLForResource:@"IMSPassword" withExtension:@"bundle"];
        bundle = [NSBundle bundleWithURL:URL];
    });
    return [bundle localizedStringForKey:key value:nil table:nil];
}

#pragma mark - object methods

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _mode = 0;
        self.passwordSecurityPattern = @"^.*(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.{6,}).*$";
    }
    return self;
}

- (void)setMode:(IMSPasswordViewControllerMode)mode {
    NSParameterAssert(mode > 0 && mode < 3);
    if (_mode == 0) { _mode = mode; }
}

#pragma mark - view lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSParameterAssert(self.mode != 0);
    NSParameterAssert(self.target != nil);
    NSParameterAssert(self.action != nil);
    
    // ui
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.passwordFields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj setSecureTextEntry:YES];
        [obj setEnablesReturnKeyAutomatically:YES];
        [obj setDelegate:self];
        [obj addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    [self.passwordOneField becomeFirstResponder];
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
    if (self.mode == IMSPasswordViewControllerModeCreate) {
        [self createPassword];
    }
    else if (self.mode == IMSPasswordViewControllerModeVerify) {
        [self verifyPassword];
    }
}

- (void)createPassword {
    NSParameterAssert(self.mode == IMSPasswordViewControllerModeCreate);
    NSString *password = [self.passwordOneField.text copy];
    if ([password isEqualToString:self.passwordTwoField.text]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.passwordSecurityPattern];
        if ([predicate evaluateWithObject:password]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.target performSelector:self.action withObject:self withObject:password];
#pragma clang diagnostic pop
        }
        else {
            [self.passwordFields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [obj setText:nil];
            }];
            [self.passwordOneField becomeFirstResponder];
            [[[UIAlertView alloc]
              initWithTitle:[[self class] localizedStringForKey:@"CREATE_PASSWORD_SECURITY_POLICY_ERROR_TITLE"]
              message:nil
              delegate:nil
              cancelButtonTitle:[[self class] localizedStringForKey:@"OK_BUTTON_TITLE"]
              otherButtonTitles:nil]
             show];
        }
    }
    else {
        [self.passwordFields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj setText:nil];
        }];
        [self.passwordOneField becomeFirstResponder];
        [[[UIAlertView alloc]
          initWithTitle:[[self class] localizedStringForKey:@"CREATE_PASSWORD_MISMATCH_ERROR_TITLE"]
          message:nil
          delegate:nil
          cancelButtonTitle:[[self class] localizedStringForKey:@"OK_BUTTON_TITLE"]
          otherButtonTitles:nil]
         show];
    }
}

- (void)verifyPassword {
    NSParameterAssert(self.mode == IMSPasswordViewControllerModeVerify);
    NSString *password = [self.passwordOneField.text copy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    BOOL valid = (BOOL)[self.target performSelector:self.action withObject:self withObject:password];
#pragma clang diagnostic pop
    if (!valid) {
        self.passwordOneField.text = nil;
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [[[UIAlertView alloc]
          initWithTitle:[[self class] localizedStringForKey:@"VERIFY_PASSWORD_WRONG_TITLE"]
          message:nil
          delegate:nil
          cancelButtonTitle:[[self class] localizedStringForKey:@"OK_BUTTON_TITLE"]
          otherButtonTitles:nil]
         show];
    }
}

#pragma mark - text field methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.mode == IMSPasswordViewControllerModeVerify) {
        [self verifyPassword];
    }
    else if (self.mode == IMSPasswordViewControllerModeCreate) {
        if (textField == self.passwordOneField) {
            [self.passwordTwoField becomeFirstResponder];
        }
        else {
            [self createPassword];
        }
    }
    return NO;
}

- (void)textFieldTextDidChange:(UITextField *)sender {
    BOOL enabled = ([self.passwordOneField.text length] > 0);
    if (self.mode == IMSPasswordViewControllerModeCreate) {
        enabled = (enabled && [self.passwordTwoField.text length] > 0);
    }
    self.navigationItem.rightBarButtonItem.enabled = enabled;
}

@end
