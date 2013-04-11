//
//  APSimplePassport.h
//  AppPassword
//
//  Created by ct on 4/2/13.
//  Copyright (c) 2013 Mitre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPass.h"

@interface APSimplePass : APPass 

<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak)      id  <APPassProtocol>  delegate;
@property (nonatomic, readwrite) BOOL                  iPad;
@property (nonatomic, readwrite) BOOL                  keyboardRotating;

-(void) setNumberOfCodes:(NSInteger) numberOfCodes;

@end
