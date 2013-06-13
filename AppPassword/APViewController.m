//
//  APViewController.m
//  AppPassword
//
//  Created by ct on 4/2/13.
//  Copyright (c) 2013 Mitre. All rights reserved.
//

#import "APViewController.h"
#import "APPass.h"
#import <SecureFoundation/SecureFoundation.h>


@interface APViewController ()

@property (nonatomic) APPass *pass;

@end

@implementation APViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self resetPass];

#if (0)
    self.pass   = [APPass passWithCodes:4 roatingKeyboard:YES];
#else
    self.pass   = [APPass passComplex];
#endif
    
    self.pass.delegate  = self;
    self.pass.verify    = [self checkForIMSCrytoPass];
    // used by passComplex 
    self.pass.syntax    = @"^.*(?=.*[a-zA-Z])(?=.*[0-9])(?=.{6,}).*$";
    // ---------------------------------------------------------------
    // setting the parent will cause the passView to be displayed
    // ---------------------------------------------------------------
    self.pass.parentView = self.view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//------------------------------------------------------------------------------
// APPassProtocol - required
//------------------------------------------------------------------------------
-(void) APPassComplete:(UIViewController*) viewController
            withPhrase:(NSString*)         phrase {
 
    if ( nil != phrase ) {
        
        NSLog(@"store:%@",phrase);
        
        IMSCryptoManagerStoreTemporaryPasscode(phrase);
        IMSCryptoManagerFinalize();
    }
}
//------------------------------------------------------------------------------
// APPassProtocol - optional
//                - required if implementing secureFoundation
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
-(void) resetPass {
    
    IMSCryptoManagerPurge();
}
@end
