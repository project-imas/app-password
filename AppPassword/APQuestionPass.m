//
//  APQuestionPassport.m
//  AppPassword
//
//  Created by ct on 4/3/13.
//  Copyright (c) 2013 Mitre. All rights reserved.
//

#import "APQuestionPass.h"
#import <QuartzCore/CAAnimation.h>

//------------------------------------------------------------------------------
// PRIVATE
//------------------------------------------------------------------------------

@interface APQuestionPass ()

@property (nonatomic,strong) IBOutlet UILabel         * questionTitleLabel;
@property (nonatomic,strong) IBOutlet UILabel         * questionSubtitleLabel;
@property (nonatomic,strong) IBOutlet UITextField     * questionTextField;
@property (nonatomic,strong) IBOutlet UIImageView     * imageView;
@property (nonatomic,strong) IBOutlet UIView          * container;
@property (nonatomic,strong) IBOutlet UIBarButtonItem * containerButton;
@property (nonatomic,strong) IBOutlet UIToolbar       * containerToolbar;
@property (nonatomic)                 NSMutableArray  * questions;
@property (nonatomic)                 NSMutableArray  * answers;
@property (nonatomic)                 NSInteger         currentQA;

@property (nonatomic)                 NSString        * answerVerify;

@property (nonatomic)                 PASS_CTL          processControl;

@end


//------------------------------------------------------------------------------
// QUESTION
//------------------------------------------------------------------------------

@implementation APQuestionPass

- (void) didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

//------------------------------------------------------------------------------
// Init
//------------------------------------------------------------------------------

- (id)  initWithCoder:(NSCoder  *)aDecoder       {
    
    self = [super initWithCoder:aDecoder];

    if (self) {
        
        _answers   = [NSMutableArray new];
        _questions = [NSMutableArray new];
        
        self.processControl = PASS_CREATE_Q;
                
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void) viewDidLoad                             {
    [super viewDidLoad];
    
    if ( nil == _answers   ) _answers   = [NSMutableArray new];
    if ( nil == _questions ) _questions = [NSMutableArray new];
        
    self.questionTextField.delegate = self;
    [self start];

}

-(void) viewWillAppear:(BOOL)animated {
    
    [self start];
}

//------------------------------------------------------------------------------
// 
//------------------------------------------------------------------------------
- (void) start {
    
    [self.questionTextField becomeFirstResponder];

    switch (self.processControl) {
            
        case PASS_VERIFY:

                    [self setVerifyQuestion:_currentQA];
            break;
            
        case PASS_VERIFY_Q_A:
            
                    [self askQuestion:0];
            
            break;
        default:    [self createQuestion:0];
            break;
    }
}

-(void) setClear:(NSString *)clear {
    
    _questions = nil;
    _answers   = nil;
    
    _questions = [NSMutableArray new];
    _answers   = [NSMutableArray new];
    
    self.processControl = PASS_CREATE_Q;

    [self start];
}

- (void) setBackground:(UIImage  *) background   {
    
    if ( nil != _imageView ) _imageView.image = background;
}


//------------------------------------------------------------------------------
// called when 'done' key pressed. return NO to ignore.
//------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    BOOL ret = YES;
    
    switch (self.processControl) {
            
        case PASS_CREATE_Q:
                                self.questions[_currentQA] =
                                self.questionTextField.text;
                                self.questionTextField.text = @"";
                                [self createAnswer];
            break;

        case PASS_CREATE_A:
                                self.answers[_currentQA] =
                                self.questionTextField.text;
                                self.questionTextField.text = @"";
                                
                                (_currentQA  < _numberOfQuestions - 1)
                                ? [self createQuestion:++_currentQA]
                                : [self questionAnswerFinished];
            break;

        case PASS_VERIFY:
                                self.answerVerify =
                                self.questionTextField.text;
                                self.questionTextField.text = @"";
                                [self verifyAnswer];
            break;

        case PASS_VERIFY_Q_A:
            
                                self.answers[_currentQA] =
                                self.questionTextField.text;
                                self.questionTextField.text = @"";
                                (_currentQA  < _numberOfQuestions - 1)
                                ? [self askQuestion:++_currentQA]
                                : [self verifyAnswers];

            break;

        default:
            break;
    }
    
    
    return ret;
}

-(void) createQuestion:(NSInteger) q {
    
    NSInteger qCount                 = self.currentQA;
    
    self.currentQA                   = q;
    self.containerButton.enabled     = NO;
    self.containerButton.title       = @"";
    
    self.questionTextField.text      = @"";
    self.questionSubtitleLabel.text  = @"";

    self.processControl              = PASS_CREATE_Q;
    self.questionTitleLabel.text     = [NSString stringWithFormat:
                                       @"Set Question:%d",++qCount];

    [self.questionTextField becomeFirstResponder];
}
-(void)    createAnswer {
    
    NSInteger qCount                 = self.currentQA;

    self.containerButton.enabled     = NO;
    self.containerButton.title       = @"";
    self.questionTextField.text      = @"";
    self.processControl              = PASS_CREATE_A;
    self.questionTitleLabel.text     = [NSString stringWithFormat:
                                        @"Set Answer:%d",++qCount];
    self.questionSubtitleLabel.text  = [NSString stringWithFormat:@"%@ ?",
                                        self.questions[_currentQA]];
    
    [self.questionTextField becomeFirstResponder];
}
-(void)   setVerifyQuestions:(NSArray *) q {
    
    if ( q.count ) {
    
        self.numberOfQuestions           = q.count;
        _questions                       = [NSMutableArray arrayWithArray:q];
        self.currentQA                   = 0;
        self.containerButton.enabled     = NO;
        self.containerButton.title       = @"";
        self.questionTextField.text      = @"";
        self.processControl              = PASS_VERIFY_Q_A;
        self.questionTitleLabel.text     = @"";
        
        if ( self.questions.count > self.numberOfQuestions )  {
            
            self.questionTitleLabel.text = [NSString stringWithFormat:@"%@ ?",
                                            self.questions[_currentQA]];
        }
    }
}
- (void)   askQuestion:(NSInteger) q {
    
    NSInteger qCount                 = self.currentQA;
    
    self.currentQA                   = q;
    self.containerButton.enabled     = NO;
    self.containerButton.title       = @"";
    
    self.questionTextField.text      = @"";
    self.questionSubtitleLabel.text  = [NSString stringWithFormat:
                                        @"please answer question %d",++qCount];
    
    self.processControl              = PASS_VERIFY_Q_A;
    
    if ( self.questions.count > q )  {
        
        self.questionTitleLabel.text = [NSString stringWithFormat:@"%@ ?",
                                        self.questions[_currentQA]];
    }
}

//------------------------------------------------------------------------------
// Questions and answers created
//------------------------------------------------------------------------------
-(void)    questionAnswerFinished{
    
    self.currentQA              = 0;
    self.questionTextField.text = @"";

    if ( nil != self.parentView ) [self.view removeFromSuperview];
    else                          [self dismissViewControllerAnimated:NO
                                                           completion:nil];
    
    if ( [self.delegate respondsToSelector:
          @selector(APPassComplete:withQuestions:andAnswers:)] ) {
        
        [self.delegate APPassComplete:self
                        withQuestions:self.questions
                           andAnswers:self.answers];
    }
    
}



//------------------------------------------------------------------------------
// Verify
//------------------------------------------------------------------------------

-(void)   setVerifyQuestion:(NSInteger) q {
    
    self.currentQA                   = q;
    self.containerButton.enabled     = NO;
    self.containerButton.title       = @"";
    self.questionTextField.text      = @"";
    self.processControl              = PASS_VERIFY;
    self.questionTitleLabel.text     = @"";
    
    if ( self.questions.count > q )  {

        self.questionSubtitleLabel.text  = [NSString stringWithFormat:@"%@ ?",
                                            self.questions[_currentQA]];
    }
}
-(void)   verifyAnswers {
 
    BOOL verified = NO;
    
    if ( self.delegate ) {
        
        if ( [self.delegate respondsToSelector:
              
              @selector(APPassQuestion:verifyAnswers:)] ) {
            
            verified = [self.delegate APPassQuestion:self
                                       verifyAnswers:self.answers];

        }
    }
    
    if ( verified ) [self verifyFinished:verified];
    else            [self verifyAlert];
}
-(void)   verifyAnswer  {
    
    NSString* s1 = self.answers[_currentQA];
    NSString* s2 = self.answerVerify;
                                            
    if ( [s1 isEqualToString:s2] ) [self verifyFinished:YES];
    else                           [self verifyAlert];
}
-(void)   verifyAlert   {
    
    //--------------------
    // Shake
    //--------------------
    [self shakeEntry];
    self.currentQA              = 0;
    self.questionTextField.text = @"";
    self.processControl         = PASS_VERIFY_Q_A;

    [self start];
}
-(void)   shakeEntry    {
    
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
    
    [ _questionTextField.layer addAnimation:anim forKey:nil ] ;
}

-(void)   verifyFinished:(BOOL) verified  {
    
    self.currentQA              = 0;
    self.questionTextField.text = @"";

    if ( nil != self.parentView ) [self.view removeFromSuperview];
    else                          [self dismissViewControllerAnimated:NO
                                                           completion:nil];

    if ( [self.delegate respondsToSelector:
          @selector(APPassQuestionVerified:verifyState:)] ) {
        
        [self.delegate APPassQuestionVerified:self verifyState:verified];
    }
}

@end
