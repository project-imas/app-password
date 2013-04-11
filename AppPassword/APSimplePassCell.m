//
//  APSimplePassportCell.m
//  AppPassword
//
//  Created by ct on 4/2/13.
//  Copyright (c) 2013 Mitre. All rights reserved.
//

#import "APSimplePassCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation APSimplePassCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {

        self.label               = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.font          = [UIFont boldSystemFontOfSize:24];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.text          = @"";
        self.label.textColor     = [UIColor blackColor];
        
        self.label.adjustsFontSizeToFitWidth = YES;
        self.label.layer.cornerRadius = 8;
        
        [self addSubview:self.label];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
