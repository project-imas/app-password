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
        
        IMSCryptoManagerStoreTemporaryPasscode(phrase);
 
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

@end
