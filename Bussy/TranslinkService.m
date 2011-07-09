//
//  Adapter.m
//  Bussy
//
//  Created by James Li on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TranslinkService.h"

@implementation TranslinkService

-(Stop*) getStop: (NSString*) stopID
{
    NSString * json = [TranslinkAdapter requestStop:stopID];
     
    SBJsonParser * parser = [[SBJsonParser alloc] init];
    
    NSArray * entries = [parser objectWithString:json error:nil];
    
    Stop * stop = [Stop alloc];
    
    if ([entries count] > 0)
    {
        NSArray * result = [entries objectAtIndex:0];
        
        if ([result count] >= 2)
        {
            NSString * resultStopID = [[result objectAtIndex:0] stringValue];
            NSString * resultStopName = [result objectAtIndex:1];
            stop = [stop stopId:resultStopID name:resultStopName];
        }
        
        
    }
    
    return stop;
}

-(NSArray*) getStopRoutesForStop: (Stop*) stop
{
    NSString * json = [TranslinkAdapter requestArrivalTimesAtStop:[stop stopID]];
                       
    SBJsonParser * parser = [[SBJsonParser alloc] init];
    
    NSArray * entries = [parser objectWithString:json error:nil];
    
    NSMutableArray * stopRoutes = [[NSMutableArray alloc] init];
    
    for (NSDictionary *entry in entries)
    {
        
        NSString * direction = [entry objectForKey:@"direction"];
        NSString * routeID = [entry objectForKey:@"routeID"];
        NSString * routeName = [entry objectForKey:@"routeName"];
        NSArray * times = [entry objectForKey:@"times"];
        
        
        StopRoute * stopRoute = [[StopRoute alloc] stop:stop direction:direction routeID:routeID routeName:routeName times:times];
        
        [stopRoutes addObject:stopRoute];
    }
    
    return [NSArray arrayWithArray:stopRoutes];
}
                                 


@end
