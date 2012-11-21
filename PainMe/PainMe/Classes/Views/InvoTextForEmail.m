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

//+(NSString *)bodyTextForEmail{
//
//    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"Chalkduster", 36.0f, NULL); // 9-1
//    NSDictionary *attrDictionary = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef, (NSString *)kCTFontAttributeName, (id)[[UIColor blueColor] CGColor], (NSString *)(kCTForegroundColorAttributeName), (id)[[UIColor redColor] CGColor], (NSString *) kCTStrokeColorAttributeName, (id)[NSNumber numberWithFloat:-3.0], (NSString *)kCTStrokeWidthAttributeName, nil]; // 10-1
//    CFRelease(fontRef); // 11-1
//    
//    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Everybody loves iNVASIVECODE!" attributes:attrDictionary]; // 12-1
//
//    CGSize size = CGSizeMake([[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
//    
//    UIGraphicsBeginImageContext(size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetTextMatrix(context, CGAffineTransformIdentity); // 2-1
//    CGContextTranslateCTM(context, 0, [[UIScreen mainScreen]bounds].size.height); // 3-1
//    CGContextScaleCTM(context, 1.0, -1.0); // 4-1
//    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attString); // 5-1
//    
//    // Set text position and draw the line into the graphic context
//    CGContextSetTextPosition(context, 30.0, 500.0); // 6-1
//    CTLineDraw(line, context); // 7-1
//    CFRelease(line); // 8-1
//    UIGraphicsEndImageContext();
//    
//    return [attString string];
//}


+(NSString *)bodyTextForEmail{

    NSArray *entries = [PainEntry last50PainEntriesIfError:^(NSError *error){
        
        NSLog(@"error was %@",[error localizedDescription]);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:NSLocalizedString(@"Error occured while Populating Pain Entries.", @"") delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    }];

    NSString  *str = @"";
//    int num=1;
    
    NSDate *prevDate = [[entries objectAtIndex:0] valueForKey:@"timestamp"];
    
    NSDateFormatter *frmtr = [[NSDateFormatter alloc]init];
    [frmtr setDateStyle:NSDateFormatterShortStyle];
    
//    NSString *prevDateString = [frmtr stringFromDate:prevDate];
    
    if(entries){
        NSString *currDate;
        [frmtr setDateFormat:@"MMMM YYY"];
        str = [frmtr stringFromDate:prevDate];
        [frmtr setDateFormat:@"E d"];
        str = [str stringByAppendingString:[NSString stringWithFormat:@"\n %@\n",[frmtr stringFromDate:prevDate]]];
        
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
                    
                    str = [str stringByAppendingString: [NSString stringWithFormat:@" \n %@ \n",[frmtr stringFromDate:dte]]];
                    [frmtr setDateFormat:@"E d"];
                    
                    str = [str stringByAppendingString: [NSString stringWithFormat:@" \n %@ \n",[frmtr stringFromDate:dte]]];
                }
                else{
                    [frmtr setDateFormat:@"E d"];
                    str = [str stringByAppendingString: [NSString stringWithFormat:@" \n %@ \n",[frmtr stringFromDate:dte]]];
                }
            }
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateStyle:NSDateFormatterShortStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            
            NSString *newStr = [NSString stringWithFormat:@"  %@\n  Pain Level: %d \n  %@\n \n",[loc valueForKey:@"name"],[[dict valueForKey:@"painLevel"] integerValue],[formatter stringFromDate:dte]];
            
            str = [str stringByAppendingString:[NSString stringWithFormat:@" %@",newStr]];
            prevDate = dte;
//            num++;

            
//            PainLocation *loc = [dict valueForKey:@"location"];
//            NSDate *dte= [dict valueForKey:@"timestamp"];
//            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//            //        [formatter setDateStyle:NSDateFormatterShortStyle];
//            [formatter setTimeStyle:NSDateFormatterShortStyle];
//            
//            NSString *newStr = [NSString stringWithFormat:@"  %@\n  Pain Level: %d \n  %@\n \n",[loc valueForKey:@"name"],[[dict valueForKey:@"painLevel"] integerValue],[formatter stringFromDate:dte]];
//            
//            str = [str stringByAppendingString:[NSString stringWithFormat:@" %@",newStr]];
//            num++;
        }
    }
    //num=0;

    return [str copy];
}
@end
