//
//  APViewController.m
//  APComplexPassEncryt
//
//  Created by ct on 4/4/13.
//  Copyright (c) 2013 Mitre. All rights reserved.
//

#import "APViewController.h"

@interface APViewController ()

@property (nonatomic) APPass    *pass;
@property (nonatomic) APPass    *question;
@property (nonatomic) NSInteger  numberOfQuestion;
@property (nonatomic) PASS_CTL   passControl;


@property (nonatomic,strong) IBOutlet UIButton *askForPassword;
@property (nonatomic,strong) IBOutlet UIImage  *background;
@property (nonatomic,strong) IBOutlet UIButton *logoutButton;
@property (nonatomic,strong) IBOutlet UIButton *resetButton;

//@property (weak, nonatomic) IBOutlet UIButton *clearAllButton;
@property (nonatomic,strong) IBOutlet UIButton *forgotButton;

@end

@implementation APViewController

- (void)     viewDidLoad                {
    
    [super viewDidLoad];
    
    [self.askForPassword  addTarget:self
                             action:@selector(askForPasscode:)
                   forControlEvents:UIControlEventTouchUpInside];
    
    // ---------------------------------------------------------------
    // AppPassword API - passcode
    // ---------------------------------------------------------------
    self.pass                = [APPass passComplex];
    self.pass.delegate       = self;
    self.pass.background     = self.background;
    self.pass.syntax         = @"^.*(?=.*[a-zA-Z])(?=.*[0-9])(?=.{6,}).*$";
    self.pass.syntaxLabel    = @"length:6 - 1 digit, 1 capital";
    self.pass.resetEnabled   = FALSE; //** TRUE - ask user for questions and password resets after 3 failures
                                      //** FALSE - exit(0) after 3 failures
    // ---------------------------------------------------------------
    // AppPassword API - security questions
    // ---------------------------------------------------------------
    self.numberOfQuestion    = 2;
    self.question            = [APPass passQuestions:self.numberOfQuestion];
    self.question.delegate   = self;
    self.question.background = self.background;
    
    //** uncomment to automatically launch the passcode dialog
    //[self askForPasscode:self];
    
    //** initial app state check
    [self setInitialAppUI];
}

//******************
//******************
//**
//**
- (void) setInitialAppUI {
    
    //** app has passcode set, set buttons accordingly
    [self userLoggedOutSetButtons];
    if ( ![self checkForIMSCrytoPass] ) {
        //** app has no passcode, set buttons and buttons labels
        [self noPasswordSetButtons];
    }
    

    
}

- (IBAction)  askForPasscode:(id)sender {
    
    if ( [self checkForIMSCrytoPass] ) {
        
        self.pass.verify         = @"verify";
        self.passControl         = PASS_VERIFY;
        
    } else {
        
        self.pass.verify         = nil;
        self.passControl         = PASS_CREATE;
        
        //** disable forgot button
        _forgotButton.alpha = 0.6f;
        [_forgotButton setEnabled:NO];
    }
    // ---------------------------------------------------------------
    // setting the parent will cause the passView to be displayed
    // ---------------------------------------------------------------
    self.pass.parentView     = self.view;
}


//- (IBAction) askForQuestions:(id)sender {
- (void) askForQuestions {
    
    self.question.verifyQuestions  = IMSCryptoManagerSecurityQuestions();
    self.passControl         = (nil == self.pass.verify) ? PASS_CREATE_Q: PASS_VERIFY_Q;
    // ---------------------------------------------------------------
    // setting the parent will cause the passView to be displayed
    // ---------------------------------------------------------------
    
    self.question.parentView = self.view;
}


//*******************
//** DEBUG purposes - remove from production code

# if 1
- (IBAction) clearPassword:(id)sender {
    //** remove password and questions and answers
    
    IMSCryptoManagerPurge();
    
    NSArray *accounts = [IMSKeychain accounts];
    
    [accounts enumerateObjectsUsingBlock:
     
     ^(NSDictionary *account, NSUInteger idx, BOOL *stop) {
         
         NSString *serviceName = account[(__bridge NSString *)kSecAttrService];
         NSString *accountName = account[(__bridge NSString *)kSecAttrAccount];
         
         [IMSKeychain deletePasswordForService:serviceName account:accountName];
     }];
    
    [IMSKeychain synchronize];
    
    self.pass.clear     = @"clear";
    self.question.clear = @"clear";
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Passwords and Q&A cleared!" message:nil delegate:nil
                          cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    
    //** wait until user clicks OK
    NSRunLoop *rl = [NSRunLoop currentRunLoop];
    NSDate *d;
    while ([alert isVisible]) {
       d = [[NSDate alloc] init];
      [rl runUntilDate:d];
    }
    
    [self noPasswordSetButtons];
    
    //** disable forgot button
    //_forgotButton.alpha = 0.6f;
    //[_forgotButton setEnabled:NO];

}
#endif


//------------------------------------------------------------------------------
// APPassProtocol - required
//------------------------------------------------------------------------------
-(void) APPassComplete:(UIViewController*) viewController
            withPhrase:(NSString*)         phrase {
    
    if ( nil != phrase ) {
        
        switch (self.passControl) {
                
            case PASS_CREATE: [self processCreate:viewController
                                       withPhrase:phrase];
                break;
                
            case PASS_RESET:  [self  processReset:viewController
                                       withPhrase:phrase];
                break;
                
            case PASS_VERIFY: [self processVerify:viewController
                                       withPhrase:phrase];
                break;
                
            default: break;
        }
    }
}


//------------------------------------------------------------------------------
// The passcode has been entered now present the questions
//------------------------------------------------------------------------------
- (void) processCreate:(UIViewController*) viewController
            withPhrase:(NSString*) phrase {

    NSLog(@"here in processCreate");
    
    //** hold on to the phrase for finialize method
    //** only called during the initial creation of the passcode, otherwise the temporary variable is never used.
    IMSCryptoManagerStoreTP(phrase);
    
    // ask to create questions
    [self askForQuestions];

    //** USER logged in
    [self userLoggedInSetButtons];
}


//------------------------------------------------------------------------------
// Update the stored passcode with a new one
//------------------------------------------------------------------------------
- (void)  processReset:(UIViewController*) viewController
            withPhrase:(NSString*) phrase {
    
    NSLog(@"here in processReset");

    IMSCryptoManagerUpdatePasscode(phrase);
    
    //** USER logged in
    [self userLoggedInSetButtons];
}


//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
- (void) processVerify:(UIViewController*) viewController
            withPhrase:(NSString*) phrase {
    
    NSLog(@"here in processVerify USER Logged in");
    
    //** USER logged in
    [self userLoggedInSetButtons];    
}

//------------------------------------------------------------------------------
// APPassProtocol - required if implementing secureFoundation
//------------------------------------------------------------------------------
-(BOOL) verifyPhraseWithSecureFoundation:(NSString*) phrase {
    
    BOOL ret = NO;
    
    ret = IMSCryptoManagerUnlockWithPasscode(phrase);
    
    return ret;
}


//------------------------------------------------------------------------------
// Required if implementing secureFoundation
//------------------------------------------------------------------------------
-(NSString*) checkForIMSCrytoPass {
    
    NSString* key = nil;
    
    if (IMSCryptoManagerHasPasscode()) key = @"verify";
    
    return key;
}


-(void) resetPassAP {
    
    [self askForQuestions];
}


//------------------------------------------------------------------------------
// APQuestionProtocol - required
//------------------------------------------------------------------------------
-(void) APPassComplete:(UIViewController *) viewController
         withQuestions:(NSArray *)          questions
            andAnswers:(NSArray *)          answers {
    
    if ( nil != questions && nil != answers ) {
        
        switch (self.passControl) {
                
            case PASS_CREATE_Q: [self processCreateQuestion:questions
                                                withAnswers:answers];
                break;
                
            case PASS_RESET_Q:  [self processResetQuestion:questions
                                               withAnswers:answers];
                break;
                
            default: break;
        }
    }
}

-(void) processCreateQuestion:questions withAnswers:answers {
    
    IMSCryptoManagerStoreTSQA(questions,answers);
    IMSCryptoManagerFinalize();
}

-(void)  processResetQuestion:questions withAnswers:answers {
    
    IMSCryptoManagerUpdateSecurityQuestionsAndAnswers(questions, answers);
}


-(BOOL) APPassQuestion:(UIViewController *) viewController
         verifyAnswers:(NSArray *)          answers {
    
    if (IMSCryptoManagerUnlockWithAnswersForSecurityQuestions(answers) == FALSE) {
        //** wrong answers to questions
        //** display a dialog and then quit app
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Answers do not match Questions, exiting" message:nil delegate:self
                              cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert setTag:0];
        [alert show];
        
        return FALSE;
    }
    else {
        //** App Password will prompt for new passcode
        //** display a dialog and then quit app
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Reset success, enter new passcode" message:nil delegate:self
                              cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert setTag:1];
        [alert show];
        
        return TRUE;
    }
}

//------------------------------------------------------------------------------
// user forgot the passcode and is answering security questions in order to
// reset it
//------------------------------------------------------------------------------
-(void) APPassQuestionVerified:(UIViewController *) viewController
                   verifyState:(BOOL)               verify {
    
    if ( verify ) {
        
        self.passControl     = PASS_RESET;
        self.pass.verify     = nil;
        self.pass.parentView = self.view;
        
    } else {
        
        exit(0);
    }
}

//** Forgot my password
- (IBAction)passForgotten:(id)sender {
    // ask questions, if correct, allow password to be reset
    //[self resetPassAP];
    [self askForQuestions];
}

- (IBAction)resetPasscode:(id)sender {
    
    //** check and confirm passcode was entered by user already
    if (IMSCryptoManagerHasPasscode()) {
        self.passControl     = PASS_RESET;
        self.pass.verify     = nil;
        self.pass.parentView = self.view;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex]) return;

    //** question reset - failed Q&A
    if (alertView.tag == 0)
    {
        //** user entered bad answers to questions
        exit(0);
    }
    
    //** question reset - good Q&A, just return when OK is pressed
    if (alertView.tag == 1)
    {
        return;
    }

    //** logout
    if (alertView.tag == 2)
    {
       NSLog(@"User Logged out");
       IMSCryptoManagerPurge();
    }
    
    
    if (alertView.tag == 2 || alertView.tag == 3) {
        //** user logged out or cleared all passwords and questions
        [self userLoggedOutSetButtons];
    }

    //** clear all
    if (alertView.tag == 3)
    {
        NSLog(@"User CLEARED ALL!");
        [self clearPassword:nil];
    }

}


- (IBAction)passLogout:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Logout, are you sure?" message:nil delegate:self
                          cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert setTag:2];
    [alert show];
    
}

- (IBAction)passClearAll:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Clear All, are you sure?" message:nil delegate:self
                          cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert setTag:3];
    [alert show];
}

- (void) userLoggedInSetButtons {
    [_askForPassword setTitle: @"Passcode" forState:UIControlStateNormal];
    
    //** enable these buttons
    _logoutButton.alpha = 1.0f;
    [_logoutButton setEnabled:YES];
    _resetButton.alpha = 1.0f;
    [_resetButton setEnabled:YES];
  //  _clearAllButton.alpha = 1.0f;
  //  [_clearAllButton setEnabled:YES];

    //** disable buttons
    _askForPassword.alpha = 0.6f;
    [_askForPassword setEnabled:NO];
    _forgotButton.alpha = 0.6f;
    [_forgotButton setEnabled:NO];
}

- (void) userLoggedOutSetButtons {
    [_askForPassword setTitle: @"Passcode" forState:UIControlStateNormal];
    
    //** disable buttons
    _logoutButton.alpha = 0.6f;
    [_logoutButton setEnabled:NO];
    _resetButton.alpha = 0.6f;
    [_resetButton setEnabled:NO];
 //   _clearAllButton.alpha = 0.6f;
 //   [_clearAllButton setEnabled:NO];
    
    //** enable buttons
    _askForPassword.alpha = 1.0f;
    [_askForPassword setEnabled:YES];
    _forgotButton.alpha = 1.0f;
    [_forgotButton setEnabled:YES];
}

- (void) noPasswordSetButtons {
    //** disable buttons
    _logoutButton.alpha = 0.6f;
    [_logoutButton setEnabled:NO];
    _resetButton.alpha = 0.6f;
    [_resetButton setEnabled:NO];
    _forgotButton.alpha = 0.6f;
    [_forgotButton setEnabled:NO];
    //   _clearAllButton.alpha = 0.6f;
    //   [_clearAllButton setEnabled:NO];
    
    //** enable buttons
    _askForPassword.alpha = 1.0f;
    [_askForPassword setEnabled:YES];
    [_askForPassword setTitle: @"Create Passcode" forState:UIControlStateNormal];
}


@end

