//
//  WatchedStopsCollection.m
//  Bussy
//
//  Created by James Li on 11-07-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WatchedStopRoutesCollection.h"
#import "StopRoute.h"
#import "Stop.h"

@implementation WatchedStopRoutesCollection

- (id)init
{
    self = [super init];
    if (self) {
        routesByStopNumber = [[NSMutableDictionary alloc] init];
        [routesByStopNumber retain];
    }

    return self;
}

- (NSUInteger) countOfStops
{
    return [routesByStopNumber count];
}

- (NSUInteger) countOfRoutesAtStopNumber: (NSString*) stopNumber
{
    NSArray * routesArray = [routesByStopNumber objectForKey:stopNumber];
    
    if (routesArray == nil) return 0;
    
    return [routesArray count];
}

- (NSUInteger) countOfRoutesAtStopIndex: (NSUInteger) stopIndex
{    
    if (stopIndex >= [[routesByStopNumber allKeys] count]) return 0;
    
    NSString * stopNumber = [[routesByStopNumber allKeys] objectAtIndex: stopIndex];
    
    return [self countOfRoutesAtStopNumber:stopNumber];
}

- (NSUInteger) countOfItems
{
    NSUInteger count = 0;
    
    for (NSString * stopNumber in [routesByStopNumber allKeys])
    {
        if (stopNumber != nil)
        {
            NSArray * stopRoutes = [routesByStopNumber objectForKey:stopNumber];
            
            if (stopRoutes != nil)
            {
                count += stopRoutes.count;
            }
        }
    }
    
    return count;
}

- (NSArray*) stopNumbers
{
    return [routesByStopNumber allKeys];
}

- (StopRoute*) stopRouteAtIndex: (NSUInteger) routeIndex withStopNumber: (NSString*) stopNumber
{
    if (![[routesByStopNumber allKeys] containsObject:stopNumber]) return nil;
    
    NSMutableArray * stopRoutesArray = [routesByStopNumber objectForKey: stopNumber];
    
    if (routeIndex >= [stopRoutesArray count]) return nil;
    
    return [stopRoutesArray objectAtIndex:routeIndex];
}

- (StopRoute*) stopRouteAtIndex: (NSUInteger) routeIndex withStopIndex: (NSUInteger) stopIndex
{
    if (stopIndex >= [[routesByStopNumber allKeys] count]) return nil;

    NSString * stopNumber = [[routesByStopNumber allKeys] objectAtIndex: stopIndex];

    return [self stopRouteAtIndex:routeIndex withStopNumber:stopNumber];
}

- (NSArray*) stopRoutesWithStopNumber: (NSString*) stopNumber
{
    if (stopNumber == nil) return nil;
    if (![[routesByStopNumber allKeys] containsObject:stopNumber]) return nil;
    
    return [[NSArray alloc] initWithArray:[routesByStopNumber objectForKey:stopNumber]];
}

- (NSArray*) stopRoutesWithStopIndex: (NSUInteger) stopIndex
{
    if (stopIndex >= [[routesByStopNumber allKeys] count]) return nil;
    
    NSString * stopNumber = [[routesByStopNumber allKeys] objectAtIndex: stopIndex];
    
    return [self stopRoutesWithStopNumber:stopNumber];
}

- (void) insertStopRoute:(StopRoute*)stopRoute
{
    if (stopRoute == nil) return;
    
    NSMutableArray * stopRouteArray = nil;
        
    if ([[routesByStopNumber allKeys] containsObject:stopRoute.stop.stopID])
    {
        stopRouteArray = [routesByStopNumber objectForKey:stopRoute.stop.stopID];
        
        if ([stopRouteArray containsObject:stopRoute])
        {
            return;
        }
    }
    
    if (stopRouteArray == nil)
    {
        stopRouteArray = [[NSMutableArray alloc] init];
        [routesByStopNumber setValue:stopRouteArray forKey:stopRoute.stop.stopID];
    }
    
    [stopRouteArray addObject:stopRoute];
}

- (void) removeStopRouteAtIndex: (NSUInteger) routeIndex withStopNumber: (NSString*) stopNumber
{
    if (![[routesByStopNumber allKeys] containsObject:stopNumber]) return;
    
    NSMutableArray * stopRouteArray = [routesByStopNumber objectForKey:stopNumber];
    
    if (routeIndex >= [stopRouteArray count]) return;
    
    [stopRouteArray removeObjectAtIndex:routeIndex];
}

- (void) removeStopRouteAtIndex: (NSUInteger) routeIndex withStopIndex: (NSUInteger) stopIndex
{
    if (stopIndex >= [routesByStopNumber count]) return;
    
    NSString * stopNumber = [[routesByStopNumber allKeys] objectAtIndex: stopIndex];
    
    [self removeStopRouteAtIndex:routeIndex withStopNumber:stopNumber];

}

-(BOOL) containsStopRoute:(StopRoute*)stopRoute
{
    for (NSMutableArray * array in [routesByStopNumber allValues])
    {
        for (StopRoute * route in array)
        {
            if (stopRoute == route)
                return true;
        }
    }

    return false;
}

- (void) dealloc
{
    [routesByStopNumber release];
    [super dealloc];
}

@end
