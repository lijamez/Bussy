//
//  StopRouteCollection.m
//  Bussy
//
//  Created by James Li on 11-07-08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StopRouteCollection.h"
#import "Stop.h"

@implementation StopRouteCollection

@synthesize stop;

- (StopRouteCollection*) initWithAdapter: (TranslinkAdapter*) inputAdapter stop: (Stop*) inputStop
{
    self = [super init];
    if (self) {
        
        array = [[NSMutableArray alloc] init];
        [array retain];
        
        stop = inputStop;
        [stop retain];
        
        adapter = inputAdapter;
        [adapter retain];
        
        //[self refreshAndCatchError: error];
        status = NOT_LOADED;
        
    }
    
    return self;
}

- (void) addStopRoute: (StopRoute*) stopRoute
{
    if (stopRoute == nil) return;
    if ([array containsObject:stopRoute]) return;
    
    [array addObject:stopRoute];
}

- (void) refreshAndCatchError: (NSError**) error
{
    status = REFRESHING;
    
    NSMutableArray * remainingRoutesToRefresh = [[NSMutableArray alloc] initWithArray:array];
    
    NSString * json = [adapter requestArrivalTimesAtStop:[stop stopID] error: error];
    
    SBJsonParser * parser = [[SBJsonParser alloc] init];
    
    NSArray * entries = [parser objectWithString:json error:nil];
    
    for (NSDictionary *entry in entries)
    {
        NSString * entryStopID = [entry objectForKey:@"stopID"];
        
        if ([self.stop.stopID isEqualToString: entryStopID])
        {
            NSString * entryDirection = [entry objectForKey:@"direction"];
            NSString * entryRouteID = [entry objectForKey:@"routeID"];
            NSString * entryRouteName = [entry objectForKey:@"routeName"];
            NSArray * entryTimes = [entry objectForKey:@"times"];
            
            //StopRoute * stopRoute = [[StopRoute alloc] initWithStop:stop direction:entryDirection routeID:entryRouteID routeName:entryRouteName times:entryTimes exists: YES];
            
            for (StopRoute * stopRoute in array)
            {
                if ([stopRoute.routeID caseInsensitiveCompare: entryRouteID] == NSOrderedSame &&
                    [stopRoute.direction caseInsensitiveCompare: entryDirection] == NSOrderedSame)
                {
                    stopRoute.routeName = entryRouteName;
                    stopRoute.times = entryTimes;
                    
                    [remainingRoutesToRefresh removeObject:stopRoute];
                    break;
                }
            }
            
        }
    }
    
    //Flag the routes that did not manage to refresh
    for (StopRoute * invalidStopRoute in remainingRoutesToRefresh)
    {
        invalidStopRoute.exists = NO;
    }
    
    status = VALID;
}

- (NSArray*) array
{
    return [[NSArray alloc] initWithArray:array];
}

- (void) dealloc
{
    [array release];
    [stop release];
    [adapter release];
    [super dealloc];
    
}

@end
