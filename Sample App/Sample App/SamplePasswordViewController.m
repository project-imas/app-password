//
//  SamplePasswordViewController.m
//  Passcode
//
//  Created by Caleb Davenport on 11/29/12.
//  Copyright (c) 2012 The MITRE Corporation. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SamplePasswordViewController.h"

@interface SamplePasswordViewController ()

@property (nonatomic, weak) IBOutlet UIView *passwordFieldContainerView;

@end

@implementation SamplePasswordViewController

+ (NSString *)storyboardBaseName {
    return @"SamplePasswordStoryboard";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CALayer *layer = self.passwordFieldContainerView.layer;
    layer.cornerRadius = 5.0;
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowRadius = 4.0;
    layer.shadowOffset = CGSizeMake(0.0, 2.0);
    layer.shadowOpacity = 0.3;
    
}

- (IBAction)cancelButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
