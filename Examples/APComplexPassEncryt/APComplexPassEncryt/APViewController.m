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
    // ---------------------------------------------------------------
    // AppPassword API - security questions
    // ---------------------------------------------------------------
    self.numberOfQuestion    = 2;
    self.question            = [APPass passQuestions:self.numberOfQuestion];
    self.question.delegate   = self;
    self.question.background = self.background;
    
    [self askForPasscode:self];
}
- (IBAction)  askForPasscode:(id)sender {
    
    if ( [self checkForIMSCrytoPass] ) {
        
        self.pass.verify         = @"verify";
        self.passControl         = PASS_VERIFY;
        
    } else {
        
        self.pass.verify         = nil;
        self.passControl         = PASS_CREATE;
    }
    // ---------------------------------------------------------------
    // setting the parent will cause the passView to be displayed
    // ---------------------------------------------------------------
    self.pass.parentView     = self.view;
}
//- (IBAction) askForQuestions:(id)sender {
- (void) askForQuestions {
    
    self.question.verifyQuestions  = IMSCryptoManagerSecurityQuestions();
    self.passControl         = (nil == self.pass.verify)
    ? PASS_CREATE_Q: PASS_VERIFY_Q;
    // ---------------------------------------------------------------
    // setting the parent will cause the passView to be displayed
    // ---------------------------------------------------------------
    
    self.question.parentView = self.view;
}
- (IBAction)   clearPassword:(id)sender {
    
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
}
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
    
    // hold on to the phrase for finialize method
    IMSCryptoManagerStoreTemporaryPasscode(phrase);
    
    // ask to create questions
    [self askForQuestions];
}
//------------------------------------------------------------------------------
// Update the stored passcode with a new one
//------------------------------------------------------------------------------
- (void)  processReset:(UIViewController*) viewController
            withPhrase:(NSString*) phrase {
    
    IMSCryptoManagerUpdatePasscode(phrase);
}
//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
- (void) processVerify:(UIViewController*) viewController
            withPhrase:(NSString*) phrase {
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
    
    IMSCryptoManagerStoreTemporarySecurityQuestionsAndAnswers(questions
                                                              ,answers);
    IMSCryptoManagerFinalize();
}

-(void)  processResetQuestion:questions withAnswers:answers {
    
    IMSCryptoManagerUpdateSecurityQuestionsAndAnswers(questions, answers);
}


-(BOOL) APPassQuestion:(UIViewController *) viewController
         verifyAnswers:(NSArray *)          answers {
    
    return IMSCryptoManagerUnlockWithAnswersForSecurityQuestions(answers);
    
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



@end

