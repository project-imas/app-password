//
//  APPassport.h
//  AppPassword
//
//  Created by ct on 4/2/13.
//  Copyright (c) 2013 Mitre. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APPassProtocol <NSObject>

-(void) APPassComplete:(UIViewController*) viewController
            withPhrase:(NSString*)         phrase;

// -----------------------------------------------------------------------------
// Implement if using secure foundation
// -----------------------------------------------------------------------------
@optional

-(BOOL) verifyPhraseWithSecureFoundation:(NSString*) phrase;

-(void) resetPassAP;

@end
