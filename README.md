# iMAS Application Password

## Background

The "iMAS App Password" provides a simple way to include a password prompt to protect your application's data. It has just enough logic to enforce password strength, show alerts when input is invalid, and provide means for a customizable user interface.

## Installation

- Add the App Password repository as a submodule to your project. `git submodule add git@github.com:project-imas/app-password.git vendor/app-password`
- Drag the "App Password" folder to your Xcode Project and add to the appropriate target
- If you wish to run the sample app or the test suite, run `git submodule update --init --recursive`

## Usage

The "App Password" folder contains one key class: `IMSPasswordViewController`. This class contains basic logic for controlling password input inside your app.

It is highly customizable. You can change the following:

- Set the required password strength with a regular expression
- Subclass `IMSPasswordViewController` and override `+ storyboard` or `+ storybaordBaseName` to provide a custom storyboard
- Subclass `IMSPasswordViewController` and override `+ localizedStringForKey:` to provide custom localized strings
- Perform actions in callbacks on key events

To allow a user to set their passcode your code would look like:

```objc
UIStoryboard *storyboard = [SamplePasswordViewController storyboard];
UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"CreatePasswordViewController"];
IMSPasswordViewController *passwordController = [[navigationController viewControllers] objectAtIndex:0];
passwordController.target = self;
passwordController.action = @selector(passwordController:didCreatePassword:);
passwordController.passwordSecurityPattern = @"^.*(?=.*[a-zA-Z])(?=.*[0-9])(?=.{6,}).*$";
[self presentViewController:navigationController animated:YES completion:nil];
```

The code for showing a password verification screen would look very similar. Perform any required actions in the action method you provide, including dismissing the view.

## Sample App

The sample application demonstrates the use of the different password view modes, as well as its use with [SecureFoundation](https://github.com/project-imas/securefoundation) which provides additional levels of data protection.

Tests built using the [KIF](https://github.com/square/KIF) testing framework can be run by running the "Password Tests" target.
