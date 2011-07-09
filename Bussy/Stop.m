//
//  Stop.m
//  Bussy
//
//  Created by James Li on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Stop.h"

@implementation Stop
@synthesize stopID, stopName, routes;

-(Stop*) initWithAdapter: (TranslinkAdapter*) inputAdapter stopId: (NSString*) inputId
{
    self = [super init];
    if (self)
    {
        adapter = inputAdapter;
        [adapter retain];
        
        stopID = inputId;
        [stopID retain];
        
        [self refresh];

    }
    
    return self;
}

- (void) refresh
{
    NSString * json = [adapter requestStop:stopID];
    
    SBJsonParser * parser = [[SBJsonParser alloc] init];
    
    NSArray * entries = [parser objectWithString:json error:nil];
    
    for (NSArray * result in entries)
    {
        NSString * resultStopID = [[result objectAtIndex:0] stringValue];
        if ([resultStopID isEqualToString:self.stopID])
        {
            
            stopName = [result objectAtIndex:1];
            [stopName retain];
            
            routes = [[StopRouteCollection alloc] initWithAdapter: adapter stop: self];
            
            break;
        }
    }

}

-(void) dealloc
{
    [stopID release];
    [stopName release];
    [routes release];
    [super dealloc];
}

@end
