//
//  UIDevice+deviceInfo.m
//  PainTrackr
//
//  Created by Dhaval Karwa on 4/3/13.
//  Copyright (c) 2013 InvolutionStudios. All rights reserved.
//

#import "UIDevice+deviceInfo.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIDevice (deviceInfo)

- (NSString *)deviceInfo
{
    size_t size;
    
    // Set 'oldp' parameter to NULL to get the size of the data
    // returned so we can allocate appropriate amount of space
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    
    // Allocate the space to store name
    char *name = malloc(size);
    
    // Get the platform name
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    
    // Place name into a string
    NSString *machine = [NSString stringWithCString:name encoding:NSStringEncodingConversionAllowLossy];
    
    // Done with this
    free(name);
    
    return machine;
}
@end
