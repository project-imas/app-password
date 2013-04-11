//
//  APKeyboardCell.m
//  AppPassword
//
//  Created by ct on 4/2/13.
//  Copyright (c) 2013 Mitre. All rights reserved.
//

#import "APKeyboardCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation APKeyboardCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.btn                      = [[UIButton alloc]
                                        initWithFrame:self.bounds];
        self.btn.backgroundColor      = [UIColor blackColor];
        self.btn.layer.cornerRadius   = 10;
        [self addGradient];
        
        [self addSubview:self.btn];
        
        CGRect lRect =  CGRectMake(0.0, 40.0, frame.size.width, 10.0f);
        
        self.label                    = [[UILabel alloc] initWithFrame:lRect];
        self.label.font               = [UIFont boldSystemFontOfSize:10];
        self.label.textAlignment      = NSTextAlignmentCenter;
        self.label.text               = @"ABC";
        self.label.textColor          = [UIColor whiteColor];
        self.label.backgroundColor    = [UIColor clearColor];
        self.label.layer.cornerRadius = 10;
        
        [self addSubview:self.label];
    }
    
    return self;
}

-(void) addGradient {
    
    // Add Border
    CALayer *layer      = _btn.layer;
    layer.cornerRadius  = 10.0f;
    layer.masksToBounds = YES;
    layer.borderWidth   = 1.0f;
    layer.borderColor   = [UIColor colorWithWhite:0.1f alpha:0.8f].CGColor;
    
    // Add Shine
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame    = layer.bounds;
    shineLayer.colors   = [NSArray arrayWithObjects:
                          (id)[UIColor colorWithWhite:1.0f  alpha:0.4f].CGColor,
                          (id)[UIColor colorWithWhite:1.0f  alpha:0.2f].CGColor,
                          (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                          (id)[UIColor colorWithWhite:0.4f  alpha:0.2f].CGColor,
                          (id)[UIColor colorWithWhite:0.2f  alpha:0.2f].CGColor,
                          nil];
    
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.25f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    
    [layer addSublayer:shineLayer];
}

@end

