//
//  InvoTextForEmail.m
//  PainTrackr
//
//  Created by Dhaval Karwa on 11/21/12.
//  Copyright (c) 2012 InvolutionStudios. All rights reserved.
//

#import "InvoTextForEmail.h"
#import "InvoDataManager.h"

@implementation InvoTextForEmail


+ (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] copy];
}

+(NSString *)bodyTextForEmailWithImage:(NSData *)data{

    NSArray *entries = [PainEntry last50PainEntriesIfError:^(NSError *error){
        
        NSLog(@"error was %@",[error localizedDescription]);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:NSLocalizedString(@"Error occured while Populating Pain Entries.", @"") delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    }];

    NSString  *emailBodyStr = @"";    
    
    NSDate *prevDate = [[entries objectAtIndex:0] valueForKey:@"timestamp"];
    
    NSDateFormatter *frmtr = [[NSDateFormatter alloc]init];
    [frmtr setDateStyle:NSDateFormatterShortStyle];
    
//    NSString *prevDateString = [frmtr stringFromDate:prevDate];
    
    if(entries){
        NSString *currDate;
        [frmtr setDateFormat:@"MMMM YYY"];
        emailBodyStr = [frmtr stringFromDate:prevDate];
        [frmtr setDateFormat:@"E d"];
        emailBodyStr = [emailBodyStr stringByAppendingString:[NSString stringWithFormat:@"\n %@\n",[frmtr stringFromDate:prevDate]]];
        
       // for(NSDictionary *dict in entries){
        for (int i=0; i<[entries count]; i++) {
            
            NSDictionary *dict = [entries objectAtIndex:i];

            PainLocation *loc = [dict valueForKey:@"location"];
            NSDate *dte= [dict valueForKey:@"timestamp"];
            currDate = [frmtr stringFromDate:dte];
            
            if (![currDate isEqualToString:[frmtr stringFromDate:prevDate]]) {
//                NSLog(@"the new date is %@",currDate);
                [frmtr setDateFormat:@"MMMM YYY"];
                
                if (![[frmtr stringFromDate:dte ] isEqualToString:[frmtr stringFromDate:prevDate]]) {
                    
                    emailBodyStr = [emailBodyStr stringByAppendingString: [NSString stringWithFormat:@" \n %@ \n",[frmtr stringFromDate:dte]]];
                    [frmtr setDateFormat:@"E d"];
                    
                    emailBodyStr = [emailBodyStr stringByAppendingString: [NSString stringWithFormat:@" \n %@ \n",[frmtr stringFromDate:dte]]];
                }
                else{
                    [frmtr setDateFormat:@"E d"];
                    emailBodyStr = [emailBodyStr stringByAppendingString: [NSString stringWithFormat:@" \n %@ \n",[frmtr stringFromDate:dte]]];
                }
            }
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateStyle:NSDateFormatterShortStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            
            NSString *newStr = [NSString stringWithFormat:@"  %@\n  Pain Level: %d \n  %@\n \n",[loc valueForKey:@"name"],[[dict valueForKey:@"painLevel"] integerValue],[formatter stringFromDate:dte]];
            
            emailBodyStr = [emailBodyStr stringByAppendingString:[NSString stringWithFormat:@" %@",newStr]];
            prevDate = dte;
        }
    }

    return [emailBodyStr copy];
}
@end
