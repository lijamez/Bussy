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

@synthesize stopsSortMethod, stopRoutesSortMethod;

- (id)init
{
    self = [super init];
    if (self) {
        routesByStopNumber = [[NSMutableDictionary alloc] init];
        [routesByStopNumber retain];
        
        stopsSortMethod = ASCENDING; //TODO Adjustable in the future once a settings view is implemented
        stopRoutesSortMethod = ASCENDING; //TODO Adjustable in the future once a settings view is implemented
    }

    return self;
}

- (NSArray*) sortedKeys
{
    
    if (stopsSortMethod == ASCENDING)
    {
        NSSortDescriptor * descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
        return [[routesByStopNumber allKeys] sortedArrayUsingDescriptors: [NSArray arrayWithObject: descriptor]];
    }
    else if (stopsSortMethod == DESCENDING)
    {
        NSSortDescriptor * descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO selector:@selector(localizedCompare:)];
        return [[routesByStopNumber allKeys] sortedArrayUsingDescriptors: [NSArray arrayWithObject: descriptor]];
    }
    
    return [routesByStopNumber allKeys];
}

- (NSArray*) sortedStopRoutesWithStopNumber: (NSString*) stopNumber
{
    NSArray * stopRoutes = [routesByStopNumber objectForKey:stopNumber];
    
    if (stopRoutes == nil) return nil;
    
    if (stopRoutesSortMethod == ASCENDING)
    {
        NSSortDescriptor * descriptor = [NSSortDescriptor sortDescriptorWithKey:@"routeID" ascending:YES selector:@selector(localizedCompare:)];
        return [stopRoutes sortedArrayUsingDescriptors: [NSArray arrayWithObject: descriptor]];

    }
    else if (stopRoutesSortMethod == DESCENDING)
    {
        NSSortDescriptor * descriptor = [NSSortDescriptor sortDescriptorWithKey:@"routeID" ascending:NO selector:@selector(localizedCompare:)];
        return [stopRoutes sortedArrayUsingDescriptors: [NSArray arrayWithObject: descriptor]];
    }
    
    return stopRoutes;
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
    if (stopIndex >= [[self sortedKeys] count]) return 0;
    
    NSString * stopNumber = [[self sortedKeys] objectAtIndex: stopIndex];
    
    return [self countOfRoutesAtStopNumber:stopNumber];
}

- (NSUInteger) countOfItems
{
    NSUInteger count = 0;
    
    for (NSString * stopNumber in [self sortedKeys])
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
    return [self sortedKeys];
}

- (StopRoute*) stopRouteAtIndex: (NSUInteger) routeIndex withStopNumber: (NSString*) stopNumber
{
    if (![[self sortedKeys] containsObject:stopNumber]) return nil;
    
    NSArray * stopRoutesArray = [self sortedStopRoutesWithStopNumber:stopNumber];
    
    if (routeIndex >= [stopRoutesArray count]) return nil;
    
    return [stopRoutesArray objectAtIndex:routeIndex];
}

- (StopRoute*) stopRouteAtIndex: (NSUInteger) routeIndex withStopIndex: (NSUInteger) stopIndex
{
    if (stopIndex >= [[self sortedKeys] count]) return nil;

    NSString * stopNumber = [[self sortedKeys] objectAtIndex: stopIndex];

    return [self stopRouteAtIndex:routeIndex withStopNumber:stopNumber];
}

- (NSArray*) stopRoutesWithStopNumber: (NSString*) stopNumber
{
    if (stopNumber == nil) return nil;
    if (![[self sortedKeys] containsObject:stopNumber]) return nil;
    
    return [[NSArray alloc] initWithArray:[self sortedStopRoutesWithStopNumber:stopNumber]];
}

- (NSArray*) stopRoutesWithStopIndex: (NSUInteger) stopIndex
{
    if (stopIndex >= [[self sortedKeys] count]) return nil;
    
    NSString * stopNumber = [[self sortedKeys] objectAtIndex: stopIndex];
    
    return [self stopRoutesWithStopNumber:stopNumber];
}

- (void) insertStopRoute:(StopRoute*)stopRoute
{
    if (stopRoute == nil) return;
    
    NSMutableArray * stopRouteArray = nil;
        
    if ([[self sortedKeys] containsObject:stopRoute.stop.stopID])
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
    if (![[self sortedKeys] containsObject:stopNumber]) return;
    
    NSMutableArray * stopRouteArray = [routesByStopNumber objectForKey:stopNumber];
    
    if (routeIndex >= [stopRouteArray count]) return;
    
    id objectToRemove = [[self sortedStopRoutesWithStopNumber:stopNumber] objectAtIndex:routeIndex];
    
    [stopRouteArray removeObject:objectToRemove];
    
    if ([stopRouteArray count] <= 0)
    {
        [routesByStopNumber removeObjectForKey:stopNumber];
    }
}

- (void) removeStopRouteAtIndex: (NSUInteger) routeIndex withStopIndex: (NSUInteger) stopIndex
{
    if (stopIndex >= [routesByStopNumber count]) return;
    
    NSString * stopNumber = [[self sortedKeys] objectAtIndex: stopIndex];
    
    [self removeStopRouteAtIndex:routeIndex withStopNumber:stopNumber];

}

- (BOOL) containsStopRoute:(StopRoute*)stopRoute
{
    for (NSMutableArray * array in [routesByStopNumber allValues])
    {
        for (StopRoute * route in array)
        {
            if (stopRoute == route)
                return YES;
        }
    }

    return NO;
}

- (void) dealloc
{
    [routesByStopNumber release];
    [super dealloc];
}

@end
