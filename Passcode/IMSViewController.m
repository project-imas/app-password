//
//  IMSViewController.m
//  Passcode
//
//  Created by Caleb Davenport on 11/8/12.
//  Copyright (c) 2012 The MITRE Corporation. All rights reserved.
//

#import <SecureFoundation/SecureFoundation.h>

#import "IMSViewController.h"
#import "IMSPasscodeViewController.h"

@interface IMSViewController ()

@property (nonatomic, weak) IBOutlet UIButton *createPasscodeButton;
@property (nonatomic, weak) IBOutlet UIButton *verifyPasscodeButton;

@end

@implementation IMSViewController

#pragma mark - button actions

- (IBAction)createPasscode:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"IMSPasscodeStoryboard_iPhone" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateInitialViewController];
    IMSPasscodeViewController *passcodeController = [[navigationController viewControllers] objectAtIndex:0];
    passcodeController.target = self;
    passcodeController.action = @selector(passcodeController:didCreatePasscode:);
    passcodeController.passcodeSecurityPattern = @"^.*(?=.*[a-zA-Z])(?=.*[0-9])(?=.{6,}).*$";
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)verifyPasscode:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"IMSPasscodeStoryboard_iPhone" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"VerifyPasscodeViewController"];
    IMSPasscodeViewController *passcodeController = [[navigationController viewControllers] objectAtIndex:0];
    passcodeController.target = self;
    passcodeController.action = @selector(passcodeController:verifyPasscode:);
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)resetPasscode:(id)sender {
    
}

#pragma mark - passcode callbacks

- (void)passcodeController:(IMSPasscodeViewController *)controller didCreatePasscode:(NSString *)passcode {
    IMSCryptoManagerStoreTemporaryPasscode(passcode);
    IMSCryptoManagerFinalize();
    [self updateButtonEnabledStates];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)passcodeController:(IMSPasscodeViewController *)controller verifyPasscode:(NSString *)passcode {
    if (IMSCryptoManagerUnlockWithPasscode(passcode)) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - object methods

- (void)updateButtonEnabledStates {
    BOOL hasPasscode = IMSCryptoManagerHasPasscode();
    self.createPasscodeButton.enabled = !hasPasscode;
    self.verifyPasscodeButton.enabled = hasPasscode;
}

#pragma mark - view lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateButtonEnabledStates];
}

@end
