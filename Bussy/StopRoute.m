//
//  ArrivalTime.m
//  Bussy
//
//  Created by James Li on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StopRoute.h"
#import "Stop.h"

@implementation StopRoute
@synthesize times, routeName, routeID, stop, direction, exists;

-(StopRoute*) initWithStop: (Stop*) inputStop direction: (NSString*) inputDirection routeID: (NSString*) inputRouteID routeName: (NSString*) inputRouteName times: (NSArray*) inputTimes exists: (BOOL) inputExists
{
    self = [super init];
    if (self)
    {
        stop = inputStop;
        [stop retain];
        
        direction = inputDirection;
        [direction retain];
        
        routeID = inputRouteID;
        [routeID retain];
        
        routeName = inputRouteName;
        [routeName retain];
        
        times = inputTimes;
        [times retain];
        
        exists = inputExists;
        
    }
    
    return self;
    
}

- (NSString*) generateTimesString
{
    if ([times count] <= 0)
    {
        return nil;
    }
    
    NSMutableString * timesString = [NSMutableString string];
    for (int i = 0 ; i < [times count] ; i++)
    {
        [timesString appendFormat:@"%@  ", [times objectAtIndex:i]];
    }
    
    return timesString;
}

- (NSComparisonResult) compareStopRouteIDAscending: (StopRoute*) otherStopRoute
{
    return [self.routeID compare: otherStopRoute.routeID];
}

- (NSComparisonResult) compareStopRouteIDDescending: (StopRoute*) otherStopRoute
{
    NSComparisonResult result = [self.routeID compare: otherStopRoute.routeID];
    
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
    
    StopRoute * otherStopRoute = (StopRoute*) object;
    return [self hash] == [otherStopRoute hash];
    
}

- (NSUInteger) hash
{
    int prime = 31;
    int result = 1;
    
    result = prime * result + [stop hash];
    result = prime * result + [routeID hash];
    result = prime * result + [direction hash];
    
    return result;
}

- (void) dealloc
{
    [stop release];
    [direction release];
    [routeID release];
    [routeName release];
    [times release];
    
    [super dealloc];
}

@end
