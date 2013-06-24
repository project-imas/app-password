//
//  APComplexPassport.m
//  AppPassword
//
//  Created by ct on 4/3/13.
//  Copyright (c) 2013 Mitre. All rights reserved.
//

#import "APComplexPass.h"
#import <QuartzCore/CAAnimation.h>

//------------------------------------------------------------------------------
// PRIVATE
//------------------------------------------------------------------------------
@interface APComplexPass ()

@property (nonatomic,strong) IBOutlet UILabel         * phraseTitleLabel;
@property (nonatomic,strong) IBOutlet UILabel         * phraseSubtitleLabel;
@property (nonatomic,strong) IBOutlet UITextField     * phraseTextField;
@property (nonatomic,strong) IBOutlet UIImageView     * imageView;
@property (nonatomic,strong) IBOutlet UIView          * container;
@property (nonatomic,strong) IBOutlet UIBarButtonItem * containerButton;
@property (nonatomic,strong) IBOutlet UIToolbar       * containerToolbar;

@property (nonatomic)                 NSString        * phrase;
@property (nonatomic)                 NSString        * phraseVerify;

@property (nonatomic)                 NSMutableArray  * questions;
@property (nonatomic)                 NSMutableArray  * answers;

@property (nonatomic)                 PASS_CTL          processControl;
@property (nonatomic)                 NSInteger         numberOfTries;
@end


//------------------------------------------------------------------------------
// COMPLEX
//------------------------------------------------------------------------------

@implementation APComplexPass

- (id) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {

        [self setClear:@"clear"];

    }
    return self;
}

- (void) viewDidLoad                             {
    [super viewDidLoad];
    
    self.phraseTextField.text = @"";
    self.phraseTextField.delegate = self;
    [self.phraseTextField becomeFirstResponder];
    
    [self displayPhrase];

}

- (void) viewWillAppear:(BOOL)animated  {
    
    self.phraseTextField.text = @"";
    self.phraseTextField.delegate = self;
   [self.phraseTextField becomeFirstResponder];
    
    [self displayPhrase];
}
- (void) didReceiveMemoryWarning                 { [super didReceiveMemoryWarning]; }

-(void) setBackground:(UIImage  *) background    {
    
    if ( nil != _imageView ) _imageView.image = background;
}
-(void)     setVerify:(NSString *) verify        {
    
    self.phraseVerify = verify;
}

-(void) setClear:(NSString *)clear {
    
    self.phraseVerify             = nil;
    self.phrase                   = nil;
    self.processControl           = PASS_CREATE;
    self.phraseTitleLabel.text    = @"Set Passcode";
    self.phraseTextField.text     = @"";
    self.phraseSubtitleLabel.text = @"";
    self.numberOfTries            = 0;
}

// called when 'done' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    BOOL ret = YES;
    
    switch (self.processControl) {
            
        case PASS_CREATE:           self.phrase =
                                    self.phraseTextField.text;
                                    ( [self verifySyntax] )
                                    ? [self displayVerify]
                                    : [self syntaxAlert];
            break;

        case PASS_VERIFY_CREATE:    self.phraseVerify =
                                    self.phraseTextField.text;
                                    [self verifyPhrase];
            break;

        case PASS_VERIFY_EXISTING:  self.phrase =
                                    self.phraseTextField.text;
                                    [self verifyPhrase];
            
            break;
            
        default:
            break;
    }
    
    
    return ret;
}

-(void)    displayPhrase {
    
    self.containerButton.enabled   = NO;
    self.containerButton.title     = @"";
    self.phrase                    = @"";
    self.phraseTextField.text      = @"";
    self.phraseSubtitleLabel.text  = (self.syntaxLabel)
                                   ? self.syntaxLabel
                                   : @"";
        
    if ( self.phraseVerify ) {
        
        self.processControl        = PASS_VERIFY_EXISTING;
        self.phraseTitleLabel.text = @"Passcode";
        
    } else {
        
        self.processControl        = PASS_CREATE;
        self.phraseTitleLabel.text = @"Set Passcode";
    }
}
-(void)    displayVerify {

    self.phrase                   = self.phraseTextField.text;
    self.phraseTextField.text     = @"";
    self.phraseTitleLabel.text    = @"Verify Passcode";
    self.phraseSubtitleLabel.text = (self.syntaxLabel)
                                  ? self.syntaxLabel
                                  : @"";
            
    self.processControl           = PASS_VERIFY_CREATE;
}
-(BOOL)    verifySyntax  {
    
    BOOL ret = NO;
    
    if ( nil != self.syntax ) {
        
    
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"SELF MATCHES %@", self.syntax];
        
        if ([predicate evaluateWithObject:_phraseTextField.text]) ret = YES;
        
    } else {
        
        ret = YES;
    }
    
    return ret;
}
-(void)    verifyPhrase  {
    
    NSString* s1 = self.phrase;
    NSString* s2 = self.phraseVerify;
        
    switch (self.processControl) {
                        
        case PASS_VERIFY_CREATE:
            
            if ( [s1 isEqualToString:s2] ) [self phraseFinished];
            else                           [self verifyAlert];
           
        case PASS_VERIFY_EXISTING:  
            
            if ( [self verifyExisting]  )  [self phraseFinished];
            else                           [self verifyAlert];
            
            break;
            
        default:
            break;
    }

}
-(BOOL)    verifyExisting{
    
    BOOL      ret = NO;
    NSString* s1  = self.phrase;
    NSString* s2  = self.phraseVerify;

    if ( [self.delegate respondsToSelector:
          @selector(verifyPhraseWithSecureFoundation:)] ) {
        
        ret = [self.delegate verifyPhraseWithSecureFoundation:s1];
        
    } else {
        
        ret = [s1 isEqualToString:s2];
    }
    
    return ret;
}
-(void)    syntaxAlert   {
    
    //--------------------
    // Shake
    //--------------------
    [self shakeEntry];
}
-(void)    verifyAlert   {
    
    //--------------------
    // Shake
    //--------------------
    [self shakeEntry];
}
-(void)    shakeEntry    {
    
    CATransform3D left  = CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f);
    CATransform3D right = CATransform3DMakeTranslation( 5.0f, 0.0f, 0.0f);
    
    CAKeyframeAnimation * anim =
    [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    
    anim.values = [ NSArray arrayWithObjects:
                   [ NSValue valueWithCATransform3D: left ],
                   [ NSValue valueWithCATransform3D: right],
                   nil ] ;
    
    anim.autoreverses = YES ;
    anim.repeatCount = 2.0f ;
    anim.duration = 0.07f ;
    
    [ _phraseTextField.layer addAnimation:anim forKey:nil ] ;
    
    self.numberOfTries++;
    
    if ( self.numberOfTries > 2 ) [self retryAlert];
}
-(void)    phraseFinished{
    
    NSString* thePhrase = self.phraseTextField.text;
    
    [self clear];

    [self closeWindow];
    
    if ( [self.delegate respondsToSelector:
          @selector(APPassComplete:withPhrase:)] ) {
        
        [self.delegate APPassComplete:self withPhrase:thePhrase];
    }
}

-(void) closeWindow {
    
    if ( nil != self.parentView ) [self.view removeFromSuperview];
    else                          [self dismissViewControllerAnimated:NO
                                                           completion:nil];
}
-(void) retryAlert {

    if (self.resetEnabled == FALSE) {
        //** exit code
        exit(0);
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Reset passcode?"
                                message:nil
                               delegate:self
                      cancelButtonTitle:@"CANCEL"
                      otherButtonTitles:@"OK",nil]
     show];

}

- (void)    alertView:(UIAlertView *)alertView
 clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0: self.numberOfTries = 0;
            
            break;
            
        case 1: self.numberOfTries = 0;
            
            if (self.delegate) {

                if ( [self.delegate
                      respondsToSelector:@selector(resetPassAP)] ) {
                    
                        [self closeWindow];

                        [self.delegate resetPassAP];
                }
            }
        default:
            break;
    }    
}
@end
