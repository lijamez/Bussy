//
//  Adapter.m
//  Bussy
//
//  Created by James Li on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Adapter.h"

@implementation Adapter

-(Direction) convertToDirection: (NSString*) directionString
{
    
    if (directionString == (id) [NSNull null])
    {
        return Unknown; 
    }
    
    if ([directionString compare:@"North" options:NSCaseInsensitiveSearch])
    {
        return North;
    }
    else if ([directionString compare:@"East" options:NSCaseInsensitiveSearch])
    {
        return East;
    }
    else if ([directionString compare:@"South" options:NSCaseInsensitiveSearch])
    {
        return South;
    }
    else if ([directionString compare:@"West" options:NSCaseInsensitiveSearch])
    {
        return West;
    }
    
    return Unknown;
}

-(Stop*) getStop: (NSString*) stopID
{
    NSString * json = [Translink requestStop:stopID];
     
    SBJsonParser * parser = [[SBJsonParser alloc] init];
    
    NSArray * entries = [parser objectWithString:json error:nil];
    
    Stop * stop = [Stop alloc];
    
    if ([entries count] > 0)
    {
        NSArray * result = [entries objectAtIndex:0];
        
        if ([result count] >= 2)
        {
            NSString * resultStopID = [result objectAtIndex:0];
            NSString * resultStopName = [result objectAtIndex:1];
            stop = [stop stopId:resultStopID name:resultStopName];
        }
        
        
    }
    
    return stop;
}

-(NSArray*) getStopRoutesForStop: (Stop*) stop
{
    NSString * json = [Translink requestArrivalTimesAtStop:[stop stopID]];
                       
    SBJsonParser * parser = [[SBJsonParser alloc] init];
    
    NSArray * entries = [parser objectWithString:json error:nil];
    
    NSMutableArray * stopRoutes = [[NSMutableArray alloc] init];
    
    for (NSDictionary *entry in entries)
    {
        
        NSString * directionString = [entry objectForKey:@"direction"];
        Direction direction = [self convertToDirection:directionString];
        NSString * routeID = [entry objectForKey:@"routeID"];
        NSString * routeName = [entry objectForKey:@"routeName"];
        NSArray * times = [entry objectForKey:@"times"];
        
        
        StopRoute * stopRoute = [[StopRoute alloc] stop:stop direction:direction routeID:routeID routeName:routeName times:times];
        
        [stopRoutes addObject:stopRoute];
    }
    
    return [NSArray arrayWithArray:stopRoutes];
}
                                 


@end
