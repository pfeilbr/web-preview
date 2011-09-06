//
//  MyApplication.m
//  WebPreview
//
//  Created by Brian Pfeil on 9/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyApplication.h"

@implementation MyApplication

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)sendEvent:(NSEvent *)anEvent {
    [super sendEvent:anEvent];
    NSLog(@"anEvent = %@", [anEvent description]);
}

@end
