//
//  ArrivalTime.m
//  Bussy
//
//  Created by James Li on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StopRoute.h"


@implementation StopRoute

-(StopRoute*) stop: (Stop*) inputStop direction: (Direction) inputDirection routeID: (NSString*) inputRouteID routeName: (NSString*) inputRouteName times: (NSArray*) inputTimes
{
    self = [super init];
    if (self)
    {
        stop = inputStop;
        direction = inputDirection;
        routeID = inputRouteID;
        routeName = inputRouteName;
        times = inputTimes;
        
        favourite = false;
        
    }
    
    return self;
    
}

-(void) setFavourite: (bool) isFav
{
    favourite = isFav;
}

-(bool) isFavourite
{
    return favourite;
}

-(void) setArrivalTimes: (NSArray*) newTimes
{
    [times retain];
    [times release];
    times = newTimes;
}

-(NSArray*) getArrivalTimes
{
    return times;
}

-(NSString*) getRouteID
{
    return routeID;
}

-(Stop*) getStop
{
    return stop;
}

@end
