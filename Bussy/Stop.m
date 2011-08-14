//
//  Stop.m
//  Bussy
//
//  Created by James Li on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Stop.h"

@implementation Stop
@synthesize stopID, stopName, routes, lastRefreshedDate;

-(Stop*) initWithAdapter: (TranslinkAdapter*) inputAdapter stopId: (NSString*) inputId error: (NSError**) error
{
    self = [super init];
    if (self)
    {
        adapter = inputAdapter;
        [adapter retain];
        
        stopID = inputId;
        [stopID retain];
        
        [self refreshAndCatchError: error];

    }
    
    return self;
}

- (void) refreshAndCatchError: (NSError**) error
{
    NSString * json = [adapter requestStop:stopID error:error];
    
    SBJsonParser * parser = [[SBJsonParser alloc] init];
    
    NSArray * entries = [parser objectWithString:json error:nil];
    
    for (NSArray * result in entries)
    {
        NSString * resultStopID = [[result objectAtIndex:0] stringValue];
        if ([resultStopID isEqualToString:self.stopID])
        {
            
            stopName = [result objectAtIndex:1];
            [stopName retain];
            
            routes = [[StopRouteCollection alloc] initWithAdapter: adapter stop: self error:error];
            
            [lastRefreshedDate release];
            lastRefreshedDate = [NSDate date];
            [lastRefreshedDate retain];
            
            break;
        }
    }

}

- (BOOL) isEqual:(id)object
{
    
    if (object == self) //identity rule
        return YES;
    if (object == nil) //nil rule
        return NO;
    if (![object isKindOfClass:[self class]])
        return NO;  //unrecognized class
    
    Stop * otherStop = (Stop*) object;
    return [self hash] == [otherStop hash];
    
}

- (NSUInteger) hash
{
    int prime = 31;
    int result = 1;
    
    result = prime * result + [stopID hash];
    
    return result;
}

-(void) dealloc
{
    [stopID release];
    [stopName release];
    [routes release];
    [adapter release];
    [lastRefreshedDate release];
    [super dealloc];
}



@end
