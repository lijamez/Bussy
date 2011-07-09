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
@synthesize times, routeName, routeID, stop, direction;

-(StopRoute*) stop: (Stop*) inputStop direction: (NSString*) inputDirection routeID: (NSString*) inputRouteID routeName: (NSString*) inputRouteName times: (NSArray*) inputTimes
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
        
    }
    
    return self;
    
}

- (NSString*) generateTitle
{
    NSString * title = [NSString stringWithFormat:@"%@: %@", stop.stopID, routeName];
    return title;
}

- (NSString*) generateTimesString
{
    NSMutableString * timesString = [NSMutableString string];
    for (int i = 0 ; i < [times count] ; i++)
    {
        [timesString appendFormat:@"%@  ", [times objectAtIndex:i]];
    }
    
    return timesString;
}

@end
