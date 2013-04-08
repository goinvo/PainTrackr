//
//  InvoTextForEmail.h
//  PainTrackr
//
//  Created by Dhaval Karwa on 11/21/12.
//  Copyright (c) 2012 InvolutionStudios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvoTextForEmail : NSObject

//+(NSString *)bodyTextForEmail;
+(NSString *)bodyTextForEmailWithImage:(NSData *)data;
@end
