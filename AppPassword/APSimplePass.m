//
//  APSimplePassport.m
//  AppPassword
//
//  Created by ct on 4/2/13.
//  Copyright (c) 2013 Mitre. All rights reserved.
//

#import "APSimplePass.h"
#import "APKeyboardCell.h"
#import "APSimplePassCell.h"
#import <QuartzCore/CAAnimation.h>

//------------------------------------------------------------------------------
// PRIVATE
//------------------------------------------------------------------------------

@interface APSimplePass ()

//------------------------------------------------------------------------------
@property (nonatomic,strong) IBOutlet UILabel           * phraseTitleLabel;
@property (nonatomic,strong) IBOutlet UILabel           * phraseSubtitleLabel;
@property (nonatomic,strong) IBOutlet UITextField       * phraseTextField;
@property (nonatomic,strong) IBOutlet UIImageView       * imageView;
@property (nonatomic,strong) IBOutlet UIView            * container;
@property (nonatomic,strong) IBOutlet UIBarButtonItem   * containerButton;
@property (nonatomic,strong) IBOutlet UIToolbar         * containerToolbar;
//------------------------------------------------------------------------------
@property (nonatomic, strong) UICollectionView          * keyboardCV;
@property (nonatomic, strong) UICollectionView          * passportCV;
//------------------------------------------------------------------------------
@property (nonatomic)         NSInteger                   numberOfCodes;
@property (nonatomic)         CGRect                      keyboardFrame;
@property (nonatomic)         CGRect                      passportFrame;
@property (nonatomic)         NSMutableArray            * keys;
@property (nonatomic)         NSMutableArray            * keyLabels;
@property (nonatomic)         NSInteger                   code;
@property (nonatomic)         NSMutableArray            * phrase;
@property (nonatomic)         NSMutableArray            * phraseVerify;
@property (nonatomic)         NSMutableArray            * phraseCurrent;
@property (nonatomic)         UIImage                   * backKey;

@property (nonatomic)         PASS_CTL                    processControl;

@end

//------------------------------------------------------------------------------
// SIMPLE
//------------------------------------------------------------------------------

@implementation APSimplePass

-(void) viewDidLoad {
    
    [self setLabel];
    [self setKeys];
    [self initCodes:self.numberOfCodes];
    [self initKeyboard];
    [self chkLabelText];

}

//------------------------------------------------------------------------------
// Setup
//------------------------------------------------------------------------------
-(void) setNumberOfCodes:(NSInteger) numberOfCodes {
    
    _numberOfCodes = numberOfCodes;
    _phrase        = [[NSMutableArray alloc] initWithCapacity:numberOfCodes];
    _phraseVerify  = [[NSMutableArray alloc] initWithCapacity:numberOfCodes];
    _phraseCurrent = _phrase;
    
    for (int i = 0;i < numberOfCodes; i++) _phraseVerify[i] = _phrase[i] = @" ";
}


//******************
//******************
//**
//**
-(void)        initCodes:(NSInteger) numberOfCodes {
    
    UICollectionViewFlowLayout * layout;
    CGRect                       frame;
    UIEdgeInsets                 insets;

    frame.origin.x     = (self.iPad == YES)
    
                       ? (self.isLandscape) ? 382 : 244
    
                       : (self.isLandscape) ? 154 : 30;

    frame.origin.y     = 100;
    frame.size.height  = 70;
    frame.size.width   = 260;
    
    insets.bottom      =  0.0f;
    insets.top         =  0.0f;
    insets.left        =  0.0f;
    insets.right       =  0.0f;
    
    float width        = frame.size.width / (numberOfCodes + 1);
    
    self.passportFrame = CGRectMake(0.0f, 0.0f, width, 50.0f);

    layout             = [UICollectionViewFlowLayout new];
    
    layout.headerReferenceSize      = CGSizeMake( 0.0f,  0.0f);
    layout.footerReferenceSize      = CGSizeMake( 0.0f,  0.0f);
    layout.itemSize                 = CGSizeMake(width, 50.0f);
    layout.minimumInteritemSpacing  = 1.0f;
    layout.minimumLineSpacing       = 1.0f;
    layout.sectionInset             = insets;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(220.0, 0 /*170*/, 100.0, 30.0);
    [button setTitle:@"Forgot?" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(forgotPass:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    if ( nil != self.container ) {
        
        CGRect bFrame  = self.container.frame;
        
        frame.origin.x = (bFrame.size.width  - frame.size.width) / 2;
        
        frame.origin.y = bFrame.size.height / 3.75;
    }
    
    self.passportCV                 = [[UICollectionView alloc]
                                       initWithFrame:frame
                                       collectionViewLayout:layout];

    [self.passportCV registerClass:[APSimplePassCell class]
        forCellWithReuseIdentifier:@"APSimplePassportCell"];
    
    self.passportCV.backgroundColor = [UIColor clearColor];
    
    if ( nil != self.container )
        
        [self.container addSubview:self.passportCV];
    else
        [self.view addSubview:self.passportCV];
    
    self.passportCV.delegate        = self;
    self.passportCV.dataSource      = self;
    self.code                       = 0;
}


//******************
//******************
//**
//**
-(void)    setBackground:(UIImage *) background    {
    
    if ( nil != _imageView ) _imageView.image = background;
}


//******************
//******************
//**
//**
-(void) initKeyboard {
    
    UICollectionViewFlowLayout * layout;
    CGRect                       frame;
    CGSize                       itemSize = CGSizeMake(106.0f,60.0f);
    
    self.keyboardFrame = CGRectMake(0.0f, 10.0f, 106.0f, 90.0f);

    
    frame.origin.x     = (self.iPad == YES)
    
                       ? (self.isLandscape) ? 352 : 214
    
                       : (self.isLandscape) ? 124 : 0;

    frame.origin.y     = 220;
    frame.size.height  = 360;
    frame.size.width   = 320;

    if ( nil != self.container ) {
        
        CGRect bFrame  = self.container.frame;
        
        frame.origin.x = (bFrame.size.width - frame.size.width) / 2;
        frame.origin.y =
        
        (bFrame.size.height - frame.size.height) + (2 * itemSize.height) - 20;
        
        [self adjustForContainer];
    }
    
    
    layout = [UICollectionViewFlowLayout new];
    
    layout.headerReferenceSize      = CGSizeMake(0.0f, 0.0f);
    layout.footerReferenceSize      = CGSizeMake(0.0f, 0.0f);
    layout.itemSize                 = itemSize;
    layout.minimumInteritemSpacing  = 1.0f;
    layout.minimumLineSpacing       = 1.0f;

    self.keyboardCV   = [[UICollectionView alloc]
                                initWithFrame:frame
                         collectionViewLayout:layout];

    
    [self.keyboardCV registerClass:[APKeyboardCell class]
        forCellWithReuseIdentifier:@"APKeyboardCell"];
    
    self.keyboardCV.backgroundColor = [UIColor clearColor];

    if ( nil != self.container )
    
        [self.container addSubview:self.keyboardCV];
    else
        [self.view addSubview:self.keyboardCV];

    
    self.keyboardCV.delegate   = self;
    self.keyboardCV.dataSource = self;
    
    if ( self.keyboardRotating ) [self rotateKeyboard];
}


//******************
//******************
//**
//**
-(void) setKeys      {
    
    _keys      = [[NSMutableArray alloc] initWithObjects: @"9"
                                                         ,@"8"
                                                         ,@"7"
                                                         ,@"6"
                                                         ,@"5"
                                                         ,@"4"
                                                         ,@"3"
                                                         ,@"2"
                                                         ,@"1"
                                                         ,@"0"
                                                         ,@" "
                                                         ,@"X"
                                                         , nil];
    
    _keyLabels = [[NSMutableArray alloc] initWithObjects: @"WXYZ"
                                                         ,@"TUV"
                                                         ,@"PQRS"
                                                         ,@"MNO"
                                                         ,@"JKL"
                                                         ,@"GHI"
                                                         ,@"DEF"
                                                         ,@"ABC"
                                                         ,@" "
                                                         ,@" "
                                                         ,@" "
                                                         ,@" "
                                                         , nil];
    
    NSString *bndlePath = [[NSBundle mainBundle] pathForResource:@"AppPassword"
                                                          ofType:@"framework"];
    
    NSBundle *bndl      = [NSBundle bundleWithPath:bndlePath];
    
    NSURL    *url       = [bndl URLForResource:@"back" withExtension:@"png"];
            
    if ( url ) _backKey = [UIImage imageWithContentsOfFile:url.path];
    
}


//******************
//******************
//**
//**
-(void) setLabel     {
    
    self.phraseTitleLabel.text     = (_phraseCurrent == _phrase)
                                   ? @"Set Passcode"
                                   : @"Verify Passcode";
    
    self.phraseSubtitleLabel.text  = (self.syntaxLabel)
                                   ? self.syntaxLabel
                                   : @"";

}



//******************
//******************
//**
//**
-(void) chkLabelText {
    
    if ( nil != _phraseVerify ) {
        
        if ( ![_phraseVerify[0] isEqualToString:@" "] )
            
            _phraseTitleLabel.text = @"Passcode";
    }
}


//******************
//******************
//**
//**
-(void) setVerify:(NSString *)verify {

    self.processControl        = PASS_CREATE;
    
    for (int i = 0;i < _numberOfCodes; i++)
        
        _phraseVerify[i] = _phrase[i] = @" ";

    if ( verify ) {
        
        _phraseTitleLabel.text = @"Passcode";
                
        self.processControl    = PASS_VERIFY_EXISTING;
        
        _phraseCurrent         = _phraseVerify;
        
        self.code              = 0;

        [self.passportCV reloadData];
        
        if ( self.keyboardRotating ) [self rotateKeyboard];
    }
}


//******************
//******************
//**
//**
-(void) adjustForContainer           {
    
    CGRect   lFrame   = self.phraseTitleLabel.frame;  //phraseTitleLabel
    CGRect  slFrame   = self.phraseTitleLabel.frame;  //phraseSubtitleLabel
    CGRect   cFrame   = self.container.frame;
    UIColor *bckgrnd  = (self.keyboardKeycolor)
                      ? (self.keyboardKeycolor)
                      : [UIColor blackColor];
    CGFloat  red;
    CGFloat  green;
    CGFloat  blue;
    CGFloat  alpha;
    
    lFrame.origin.x   = (cFrame.size.width - lFrame.size.width)  / 2;
    lFrame.origin.y   = (cFrame.size.height / 6);

    slFrame.origin.x  = (cFrame.size.width - lFrame.size.width)  / 2;
    slFrame.origin.y  = (cFrame.size.height / 2.5);

    
    self.phraseTitleLabel.frame       = lFrame;
    self.phraseSubtitleLabel.frame    = slFrame;
    
    self.container.layer.borderColor  = [[UIColor whiteColor]CGColor];
    self.container.layer.cornerRadius = 10.0f;
    self.container.layer.borderWidth  = 2.5f;
    
    
    [bckgrnd getRed:&red green:&green blue:&blue alpha:&alpha];
    
    self.container.backgroundColor    = [UIColor colorWithRed:red
                                                        green:green
                                                         blue:blue
                                                        alpha:0.35f];
    
    [self.phraseTitleLabel    removeFromSuperview];
    [self.phraseSubtitleLabel removeFromSuperview];
    [self.container           addSubview:self.phraseTitleLabel];
    [self.container           addSubview:self.phraseSubtitleLabel];
}


//------------------------------------------------------------------------------
// UICollectionView Datastore delegate protocol methods
//------------------------------------------------------------------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    NSInteger ret = (collectionView == self.keyboardCV) ? 12
                                                        : self.numberOfCodes;

    
    return ret;
}


//******************
//******************
//**
//**
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell * cell     = nil;
    UIImage              * btnImage = nil;
    
    if ( collectionView == self.keyboardCV ) {
        
        APKeyboardCell * kCell;
        
        kCell = [collectionView
                   dequeueReusableCellWithReuseIdentifier:@"APKeyboardCell"
                                             forIndexPath:indexPath];
        
        if ( nil == kCell )
                kCell = [[APKeyboardCell alloc]
                                        initWithFrame:self.keyboardFrame];
        
        if (self.keyboardKeycolor)
            kCell.btn.backgroundColor = self.keyboardKeycolor;
        
        [kCell.btn setTitle:_keys[indexPath.row]
                   forState:UIControlStateNormal];
        
        btnImage = ( [_keys[indexPath.row] isEqualToString:@"X"] )
                         ? _backKey
                         : nil;
        
        [kCell.btn setImage:btnImage forState:UIControlStateNormal];
        
        UIColor *titleColor = (nil == btnImage)
                            ? [UIColor whiteColor]
                            : [UIColor clearColor];
        
        [kCell.btn setTitleColor:titleColor forState:UIControlStateNormal];
        
        kCell.label.text = _keyLabels[indexPath.row];

        [kCell.btn addTarget:self
                      action:@selector(keyButtonPress:)
            forControlEvents:UIControlEventTouchUpInside];

        cell = kCell;
        
    } else {

        APSimplePassCell *pCell;
        
        pCell = [collectionView
                 dequeueReusableCellWithReuseIdentifier:@"APSimplePassportCell"
                                           forIndexPath:indexPath];
        
        if ( nil == pCell )
                pCell = [[APSimplePassCell alloc]
                                     initWithFrame:self.passportFrame];
        
        pCell.label.text =  ([_phraseCurrent[indexPath.row] isEqualToString:@" "]) ? @" " : @"*";
        
        cell = pCell;
    }
    
    return cell;
}


//------------------------------------------------------------------------------
// Main processing
//------------------------------------------------------------------------------
-(IBAction)barButtonPress:(id)sender {

    
}

//******************
//******************
//**
//**
-(IBAction)forgotPass:(id)sender {
    NSLog(@"here in forgot pass");
    
}


//******************
//******************
//**
//**
-(IBAction)keyButtonPress:(id)sender {
    
    UIButton * b  = sender;
    
    if ( [b.titleLabel.text isEqualToString:@"X"] ) {
        
        if ( _code > 0 ) _code--;

        _phraseCurrent[_code] = @" ";
        
    } else {
        
        if ( _code < _numberOfCodes  &&  ![b.titleLabel.text isEqualToString:@" "] ) {
         
            _phraseCurrent[_code] = b.titleLabel.text;

            _code++;
        }
    }
    
    
    if (_code == _numberOfCodes) {
     
        if ( _phraseCurrent == _phrase) {

            if ( [self.phraseVerify[0] isEqualToString:@" "] ) {
                
                _phraseCurrent = _phraseVerify;
                _code          = 0;
                
                [self setLabel];
            
                [_passportCV reloadData];
                
                if ( self.keyboardRotating ) [self rotateKeyboard];
                
            } else {
                
                [self verifyPhrase];
            }
            
        } else {
            
            [self verifyPhrase];

        }
        
    } else {
        
        [_passportCV reloadData];
    }
}


//******************
//******************
//**
//**
-(void)    verifyPhrase              {

        
    NSString* s1 = [self.phrase       componentsJoinedByString:@""];
    NSString* s2 = [self.phraseVerify componentsJoinedByString:@""];
    
    switch (self.processControl) {
            
        case PASS_CREATE:
            
            if ( [s1 isEqualToString:s2] ) [self finished];
            else                           [self verifyAlert];
            
        case PASS_VERIFY_EXISTING:
            
            if ( [self verifyExisting]  )  [self finished];
            else                           [self verifyAlert];
            
            break;
            
        default:
            break;
    }
    
}


//******************
//******************
//**
//**
-(BOOL)    verifyExisting   {
    
    BOOL      ret = NO;
    
    NSString* s1 = [self.phrase       componentsJoinedByString:@""];
    NSString* s2 = [self.phraseVerify componentsJoinedByString:@""];
    
    if ( [self.delegate respondsToSelector:
          @selector(verifyPhraseWithSecureFoundation:)] ) {
        
        ret = [self.delegate verifyPhraseWithSecureFoundation:s2];
        
    } else {
        
        ret = [s1 isEqualToString:s2];
    }
    
    return ret;
}


//******************
//******************
//**
//**
-(void)    verifyAlert               {
    
    _code = 0;
    
    for (int i = 0;i < _numberOfCodes; i++) _phraseCurrent[i] = @" ";

    [_passportCV reloadData];

    //--------------------
    // Shake
    //--------------------

    [self shakeEntry];
    
    if ( self.keyboardRotating ) [self rotateKeyboard];
}


//******************
//******************
//**
//**
-(void)    shakeEntry                {
    
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
    
    [ _passportCV.layer addAnimation:anim forKey:nil ] ;
}


//******************
//******************
//**
//**
-(void)    rotateKeyboard            {    
    NSArray   *k   = [NSArray arrayWithArray:_keys];
    NSArray   *kl  = [NSArray arrayWithArray:_keyLabels];
    NSInteger rand = 0;
    
    while ( !rand )
        rand = arc4random_uniform(10);
    
    //NSLog(@"rand is: %d", rand);
    if ( [k count] ) {
        
        for (int i = 0; i < 10; i++) {
            
            _keys[i]      =  k[rand];
            _keyLabels[i] = kl[rand];
            
            rand = ( rand == 9 ) ? 0 : ++rand;
         }
        
        [_keyboardCV reloadData];
    }
}



//******************
//******************
//**
//**
-(void)    finished                  {
    
    NSString* phrase = [self.phrase componentsJoinedByString:@""];
    
    [self.view removeFromSuperview];
    
    if ( [self.delegate respondsToSelector:
          @selector(APPassComplete:withPhrase:)] ) {
        
        [self.delegate APPassComplete:self withPhrase:phrase];
    }
    
}

@end
