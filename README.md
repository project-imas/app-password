# iMAS Application Password

## Background

The "iMAS App Password" provides a simple way to include a password prompt to protect your application's data. It has just enough logic to enforce password strength, show alerts when input is invalid, and provide means for a customizable user interface.

## Vulnerabilities Addressed
1. No application password
   - CWE-521: Weak Password Requirements
   - SRG-APP-000129-MAPP-000029 Severity-CAT II: The mobile application must implement automated mechanisms to enforce access control restrictions which are not provided by the operating system.
2. Open Application Authentication
   - CWE-287: Improper Authentication
3. iOS Keychain contents vulnerable to jailbreak
   - CWE-200: Information Exposure
4. Application allows any user to execute application
   - CWE-250: Execution with Unnecessary Privileges
   - SRG-APP-000022-MAPP-000009 Severity-CAT II: The mobile application must not permit execution of code without user direction.
   - SRG-APP-000128-MAPP-000028 Severity-CAT II: The mobile application must not change the file permissions of any files other than those dedicated to its own operation.

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

## Customization

You can provide your own storyboard by subclassing `IMSPasswordViewController` and overriding either `storyboardBaseName` to use the default load mechanism, or `storyboard` to perform custom storyboard loading. You do not need to call super in either of these cases. In your storyboard you should set the `passwordOneField`, `passwordTwoField`, and `passwordFields` outlets. The behavior of each of these can be seen in either of the `IMSPasswordStoryboard` files.

Custom localizations can be loaded by subclassing `IMSPasswordViewController` and overriding `localizedStringForKey:`. You do not need to call super here. The default implementation of this method looks in `IMSPassword.bundle` for localizations. If you would like to add a translation to the default set please send a pull request. Otherwise you can load your own localization table or pass calls through to `NSLocalizedString`.

## Sample App

The sample application demonstrates the use of the different password view modes, as well as its use with [SecureFoundation](https://github.com/project-imas/securefoundation) which provides additional levels of data protection.

Tests built using the [KIF](https://github.com/square/KIF) testing framework can be run by running the "Password Tests" target.

## License

Copyright 2012 The MITRE Corporation, All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this work except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
