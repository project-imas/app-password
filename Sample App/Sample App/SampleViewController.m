//
//  IMSViewController.m
//  Passcode
//
//  Created by Caleb Davenport on 11/8/12.
//  Copyright (c) 2012 The MITRE Corporation. All rights reserved.
//

#import <SecureFoundation/SecureFoundation.h>

#import "SampleViewController.h"
#import "SamplePasswordViewController.h"

@interface SampleViewController ()

@property (nonatomic, weak) IBOutlet UIButton *createPasswordButton;
@property (nonatomic, weak) IBOutlet UIButton *verifyPasswordButton;

@end

@implementation SampleViewController

#pragma mark - button actions

- (IBAction)createPassword:(id)sender {
    UIStoryboard *storyboard = [SamplePasswordViewController storyboard];
    UINavigationController *navigationController = [storyboard instantiateInitialViewController];
    SamplePasswordViewController *passwordController = [[navigationController viewControllers] objectAtIndex:0];
    passwordController.target = self;
    passwordController.action = @selector(passwordController:didCreatePassword:);
    passwordController.passwordSecurityPattern = @"^.*(?=.*[a-zA-Z])(?=.*[0-9])(?=.{6,}).*$";
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)verifyPassword:(id)sender {
    UIStoryboard *storyboard = [SamplePasswordViewController storyboard];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"VerifyPasswordViewController"];
    SamplePasswordViewController *passwordController = [[navigationController viewControllers] objectAtIndex:0];
    passwordController.target = self;
    passwordController.action = @selector(passwordController:verifyPassword:);
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)resetPasscode:(id)sender {
    IMSCryptoManagerPurge();
    NSArray *accounts = [IMSKeychain accounts];
    [accounts enumerateObjectsUsingBlock:^(NSDictionary *account, NSUInteger idx, BOOL *stop) {
        NSString *serviceName = account[(__bridge NSString *)kSecAttrService];
        NSString *accountName = account[(__bridge NSString *)kSecAttrAccount];
        [IMSKeychain deletePasswordForService:accountName account:serviceName];
    }];
    [IMSKeychain synchronize];
    [self updateButtonEnabledStates];
}

#pragma mark - password callbacks

- (void)passwordController:(IMSPasswordViewController *)controller didCreatePassword:(NSString *)password {
    IMSCryptoManagerStoreTemporaryPasscode(password);
    IMSCryptoManagerFinalize();
    [self updateButtonEnabledStates];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)passwordController:(IMSPasswordViewController *)controller verifyPassword:(NSString *)password {
    if (IMSCryptoManagerUnlockWithPasscode(password)) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - object methods

- (void)updateButtonEnabledStates {
    if (IMSCryptoManagerIsLocked()) {
        BOOL hasPassword = IMSCryptoManagerHasPasscode();
        self.createPasswordButton.enabled = !hasPassword;
        self.verifyPasswordButton.enabled = hasPassword;
    }
    else {
        self.createPasswordButton.enabled = NO;
        self.verifyPasswordButton.enabled = NO;
    }
}

#pragma mark - view lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateButtonEnabledStates];
}

@end
