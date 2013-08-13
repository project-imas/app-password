//
//  APViewController.m
//  APSimplePass
//
//  Created by ct on 4/4/13.
//  Copyright (c) 2013 Mitre. All rights reserved.
//

#import "APViewController.h"

@interface APViewController ()

@property (nonatomic) APPass *pass;
@property (nonatomic) APPass    *question;
@property (nonatomic) NSInteger  numberOfQuestion;

@property (nonatomic,strong) IBOutlet UIImage  *background;
@property (nonatomic,strong) IBOutlet UIButton *askForPassword;

@end

@implementation APViewController


- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

//------------------------------------------------------------------------------
// APPass
//------------------------------------------------------------------------------
- (void)viewDidLoad             {
    
    [super viewDidLoad];

    [self.askForPassword  addTarget:self
                             action:@selector(askForPasscode:)
                   forControlEvents:UIControlEventTouchUpInside];

    // -----------------------------------------------------------
    // AppPassword API
    // -----------------------------------------------------------
    self.pass                  = [APPass passWithCodes:6
                                      rotatingKeyboard:YES];
    self.pass.delegate         = self;
    self.pass.syntaxLabel      = @"application passcode";
    
    // ---------------------------------------------------------------
    // AppPassword API - security questions
    // ---------------------------------------------------------------
    self.numberOfQuestion    = 1;
    self.question            = [APPass passQuestions:self.numberOfQuestion];
    self.question.delegate   = self;
    self.question.background = self.background;
    
    // -----------------------------------------------------------
    // Keycolor is optional - defaults to black
    // -----------------------------------------------------------
    //    self.pass.keyboardKeycolor = [UIColor colorWithRed:0.43f
    //                                                 green:0.55f
    //                                                  blue:0.45f
    //                                                 alpha:1.0f];
    
    [self askForPasscode:self];
}

- (IBAction)  askForPasscode:(id)sender {
    
    //** DEBUG call
    //[self clearPassword:nil];
    
    if ( [self checkForIMSCrytoPass] ) {
        
        self.pass.verify         = @"verify";
        
    } else {
        
        self.pass.verify         = nil;
    }
    // ---------------------------------------------------------------
    // setting the parent will cause the passView to be displayed
    // ---------------------------------------------------------------
    self.pass.parentView     = self.view;
}

//------------------------------------------------------------------------------
// APPassProtocol - required
//------------------------------------------------------------------------------
-(void) APPassComplete:(UIViewController*) viewController
            withPhrase:(NSString*)         phrase {
    
    if ( nil != phrase ) {
        
        IMSCryptoManagerStoreTP(phrase);
 
        IMSCryptoManagerFinalize();        
    }
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
- (IBAction)clearAll:(id)sender {
}


//*******************
//** DEBUG purposes - remove from production code

# if 1
- (IBAction)clearPassword:(id)sender {
    
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
   // self.question.clear = @"clear";
    
    if (sender == nil)
        return;
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Passwords cleared!"
                          message:nil delegate:nil
                          cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    
    //** wait until user clicks OK
    NSRunLoop *rl = [NSRunLoop currentRunLoop];
    NSDate *d;
    while ([alert isVisible]) {
        d = [[NSDate alloc] init];
        [rl runUntilDate:d];
    }
    
    //** disable forgot button
    //_forgotButton.alpha = 0.6f;
    //[_forgotButton setEnabled:NO];
    
    
}
#endif

@end
