# iMAS Application Password

## Background

The "iMAS App Password" framework provides a simple way to include passcode support into your application. It has the logic to enforce passcode strength, and can react to any passcode input. The framework contains two types of passcode controls, a simple passcode (numeric) and a complex passcode (a combination of numbers and characters). The framework utilizes the "iMAS Secure Foundation" framework in order to provide advanced security for both types of controls.

## Vulnerabilities Addressed
1. No application password
   - CWE-521: Weak Password Requirements
   - SRG-APP-000129-MAPP-000029 Severity-CAT II: The mobile application must implement automated mechanisms to enforce access control restrictions which are not provided by the operating system.
2. Open Application Authentication
   - CWE-287: Improper Authentication
3. iOS Keychain contents vulnerable to jailbreak
   - CWE-200: Information Exposure
   - SRG-APP-000133-MAPP-000030 Severity-CAT II: The mobile application must not enable other applications or non-privileged processes to modify software libraries.
   - SRG-APP-000243-MAPP-000049 Severity-CAT II: The mobile application must not write data to persistent memory accessible to other applications.
   - SRG-APP-000243-MAPP-000050 Severity_CAT II: The mobile application must not share working memory with other applications or processes.
4. Finger smudge on screen attack
  - CWE-807: Reliance on Untrusted Inputs in a Security Decision
5. Application allows any user to execute application
   - CWE-250: Execution with Unnecessary Privileges
   - SRG-APP-000022-MAPP-000009 Severity-CAT II: The mobile application must not permit execution of code without user direction.

## Installation

- Add the App Password repository as a submodule to your project. `git submodule add git@github.com:project-imas/app-password.git vendor/app-password`
- Add the Secure Foundation repository as a submodule to your project. `git submodule add git@github.com:project-imas/securefoundation.git vendor/securefoundation`

- Drag AppPassword.xcodeproj      into the your project as a subproject
- Drag SecureFoundation.xcodeproj into the your project as a subproject

- Add AppPassword           to target’s build phase - target dependancies 
- Add libSecureFoundation.a to target’s build phase - target dependancies 

- Drag AppPassword.framework to target’s build phase - link binary with libraries
- Add libSecureFoundation.a to target’s build phase - link binary with libraries 
- Add Security.framework    to target’s build phase - link binary with libraries 
- Add QuartzCore.framework  to target’s build phase - link binary with libraries

- Add AppPassword.framework to target’s build phase - copy bundle resources (if using the "out of the box" storyboards)
- Drag AppPassword.framework to your application’s framework folder (accept the defaults on the pop-up dialog)

## Usage

The "App Password" folder contains one key class: `APPass`. It is designed as a class factory that provides either a simple or complex control for your AppViewController. The following are examples of instantiating and launching a control.

###Simple:  

```objc
	// ---------------------------------------------------------------
	// AppPassword API - passcode
	// ---------------------------------------------------------------
	APPass *pass;
	self.pass            = [APPass passWithCodes:6 rotatingKeyboard:YES];
	self.pass.delegate   = self;
    // ---------------------------------------------------------------
    // setting the parentView will cause the passView to be displayed
    // ---------------------------------------------------------------
    self.pass.parentView = self.view;
```

- Set the required passcode strength by specifying the number of codes
- Set the keyboard as rotating in order to confuse onlookers 
- Receive actions within the delegate protocol methods (see example app)

###Complex: 	

```objc	
	// ---------------------------------------------------------------
    // AppPassword API - passcode
    // ---------------------------------------------------------------
	APPass *pass;
	self.pass             = [APPass passComplex];
	self.pass.delegate    = self;
	self.pass.syntax      = @"^.*(?=.*[a-zA-Z])(?=.*[0-9])(?=.{6,}).*$";
    self.pass.syntaxLabel = @"length:6 - 1 digit";
    // ---------------------------------------------------------------
    // AppPassword API - security questions
    // ---------------------------------------------------------------
	APPass *question;
    self.numberOfQuestion    = 2;
    self.question            = [APPass passQuestions:self.numberOfQuestion];
    self.question.delegate   = self;
    // ---------------------------------------------------------------
    // setting the parentView will cause the passView to be displayed
    // ---------------------------------------------------------------
    self.pass.parentView     = self.view;
```
	
- Set the required passcode strength with a regular expression
- Set the number of questions required to reset the passcode
- Receive actions within the delegate protocol methods (see example app)

## Customization

The APPass class allows you to specify your own storyboard with the following methods:

###Simple:  

```objc	

	+(APPass*)  passWithName:(NSString*) name
	                   codes:(NSInteger) numberOfCodes
	        rotatingKeyboard:(BOOL)      rotating
	  fromStoryboardWithName:(NSString*) storyboardName;
```

#####Parameters

name

	The Storyboard ID e.g. APSimplePass within the framework's provided storyboard.
	
numberOfCodes

	The number of codes (digits) that will be required to create a passcode.
	
rotating

	A boolean that indicates whether or not to rotate the keyboard keys.

storyboardName  

	The storyboard's name without the extension e.g. APSimplePass_iPhone within the framework's provided storyboards.

#####Required IBOutlets 

```objc
@property (nonatomic,strong) IBOutlet UILabel         * phraseTitleLabel;
@property (nonatomic,strong) IBOutlet UILabel         * phraseSubtitleLabel;
@property (nonatomic,strong) IBOutlet UITextField     * phraseTextField;
```


###Complex: 	

```objc	
	+(APPass*)  complexPassWithName:(NSString*) name
	         fromStoryboardWithName:(NSString*) storyboardName
```

#####Parameters

name  

	The Storyboard ID e.g. APComplexPass within the framework's provided storyboard.

storyboardName  

	The storyboard's name without the extension e.g. APComplexPass_iPhone within the framework's provided storyboards.


#####Required IBOutlets 

```objc
@property (nonatomic,strong) IBOutlet UILabel         * phraseTitleLabel;
@property (nonatomic,strong) IBOutlet UILabel         * phraseSubtitleLabel;
@property (nonatomic,strong) IBOutlet UITextField     * phraseTextField;
```


## Sample App

The sample applications demonstrate the implementation of the "out of the box" passcode controls, as well as, the implementation of the delegation methods. 

### APSimplePass

<img align="center" src="https://github.com/project-imas/app-password/raw/master/APSimplePass.png">

Instructions for running the sample apps:
- git pull app-password
- open XCode and open APSimplepass project file
- Ensure XCode scheme is set to APSimplepass > < sim or device >
- Clean, run and explore

### APComplexPassEncryt

<img align="center" src="https://github.com/project-imas/app-password/raw/master/APComplexPass.png">

Instructions for running the sample apps:
- git pull app-password
- open XCode and open APComplexPassEncryt project file.
- Ensure XCode scheme is set to APComplexPassEncryt > < sim or device >
- Clean, run and explore

## Recognition

MITRE wishes to thank [Kevin O'Keefe](https://github.com/centerthread) for thoroughly revamping and re-implementing this security control from the ground up.

## License

Copyright 2012,2013 The MITRE Corporation, All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this work except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/1872ba534d9159e437208c392bade83f "githalytics.com")](http://githalytics.com/project-imas/app-password)


