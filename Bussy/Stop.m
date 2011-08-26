//
//  Stop.m
//  Bussy
//
//  Created by James Li on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Stop.h"
#import "AbstractTranslinkObject.h"

@implementation Stop
@synthesize stopID, stopName, routes, lastRefreshedDate, exists;

-(Stop*) initWithAdapter: (TranslinkAdapter*) inputAdapter stopId: (NSString*) inputId lastRefreshedDate: (NSDate*) inputLastRefreshedDate exists: (BOOL) inputExists
{
    self = [super init];
    if (self)
    {
        adapter = inputAdapter;
        [adapter retain];
        
        stopID = inputId;
        [stopID retain];
        
        routes = [[StopRouteCollection alloc] initWithAdapter:inputAdapter stop:self];
        [routes retain];
        
        lastRefreshedDate = inputLastRefreshedDate;
        [lastRefreshedDate retain];
        
        exists = inputExists;
                 
        status = NOT_LOADED;
    }
    
    return self;
}

- (void) refreshAndCatchError: (NSError**) error
{
    status = REFRESHING;
    
    NSString * json = [adapter requestStop:stopID error:error];
    
    SBJsonParser * parser = [[SBJsonParser alloc] init];
    
    NSArray * entries = [parser objectWithString:json error:nil];
    
    BOOL stopFound = NO;
    
    for (NSArray * result in entries)
    {
        NSString * resultStopID = [[result objectAtIndex:0] stringValue];
        if ([resultStopID isEqualToString:self.stopID])
        {
            
            stopName = [result objectAtIndex:1];
            [stopName retain];
            
            if (routes == nil)
            {
                routes = [[StopRouteCollection alloc] initWithAdapter: adapter stop: self];
            }
            
            [routes refreshAndCatchError:error];
            
            stopFound = YES;
            break;
        }
    }
    
    exists = stopFound;
    
    [lastRefreshedDate release];
    lastRefreshedDate = [NSDate date];
    [lastRefreshedDate retain];

    status = VALID;

}

- (NSComparisonResult) compareStopNumberAscending: (Stop*) otherStop
{
    return [self.stopID compare: otherStop.stopID];
}

- (NSComparisonResult) compareStopNumberDescending: (Stop*) otherStop
{
    NSComparisonResult result = [self.stopID compare: otherStop.stopID];
    
    if (result == NSOrderedAscending)
    {
        return NSOrderedDescending;
    }
    else if (result == NSOrderedDescending)
    {
        return NSOrderedAscending;
    }
    
    return NSOrderedSame;
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

- (id)copyWithZone:(NSZone *)zone
{
    [self retain];
    return self;
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
