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
#import "BussyConstants.h"

@implementation WatchedStopRoutesCollection

@synthesize stopsSortMethod, stopRoutesSortMethod, isRefreshing;

- (id)init
{
    self = [super init];
    if (self) {
        
        watchedRoutesByStopNumber = [[NSMutableDictionary alloc] init];
        [watchedRoutesByStopNumber retain];
        
        watchedStops = [[NSMutableSet alloc] init];
        [watchedStops retain];
        
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
        return [[watchedRoutesByStopNumber allKeys] sortedArrayUsingDescriptors: [NSArray arrayWithObject: descriptor]];
    }
    else if (stopsSortMethod == DESCENDING)
    {
        NSSortDescriptor * descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO selector:@selector(localizedCompare:)];
        return [[watchedRoutesByStopNumber allKeys] sortedArrayUsingDescriptors: [NSArray arrayWithObject: descriptor]];
    }
    
    return [watchedRoutesByStopNumber allKeys];
}


- (NSIndexPath*) getIndexPathForStopRoute: (StopRoute*) theStopRoute
{
    for (int stopIndex = 0; stopIndex < [[self sortedKeys] count]; stopIndex++)
    {        
        NSString * stopNumber = [[self sortedKeys] objectAtIndex:stopIndex];
        NSArray * stopRoutes = [watchedRoutesByStopNumber objectForKey:stopNumber];
        
        for (int stopRouteIndex = 0; stopRouteIndex < [stopRoutes count]; stopRouteIndex++)
        {
            StopRoute * stopRoute = [stopRoutes objectAtIndex:stopRouteIndex];
            
            if ([stopRoute isEqual: theStopRoute])
            {
                return [NSIndexPath indexPathForRow:stopRouteIndex inSection:stopIndex];
            }
        }
    }
    
    return nil;
}

- (Stop*) getStopByNumber: (NSString*) stopNumber
{
    if (stopNumber == nil) return nil;
    
    for (Stop * stop in watchedStops)
    {
        if ([stopNumber isEqualToString:stop.stopID])
        {
            return stop;
        }
    }
    
    return nil;
}

- (NSArray*) sortedStopRoutesWithStopNumber: (NSString*) stopNumber
{
    if (stopNumber == nil) return nil;
    
    NSArray * stopRoutes = [watchedRoutesByStopNumber objectForKey:stopNumber];
    
    if (stopRoutes == nil) return nil;
    
    if (stopRoutesSortMethod == ASCENDING)
    {
        NSSortDescriptor * descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(compareStopRouteIDAscending:)];
        return [stopRoutes sortedArrayUsingDescriptors: [NSArray arrayWithObject: descriptor]];

    }
    else if (stopRoutesSortMethod == DESCENDING)
    {
        NSSortDescriptor * descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO selector:@selector(compareStopRouteIDDescending:)];
        return [stopRoutes sortedArrayUsingDescriptors: [NSArray arrayWithObject: descriptor]];
    }
    
    return stopRoutes;
}


- (NSUInteger) countOfStops
{
    return [[watchedRoutesByStopNumber allKeys] count];
}

- (NSUInteger) countOfRoutesAtStopNumber: (NSString*) stopNumber
{
    NSArray * routesArray = [watchedRoutesByStopNumber objectForKey:stopNumber];
    
    if (routesArray == nil) return 0;
    
    return [routesArray count];
}

- (NSUInteger) countOfRoutesAtStopIndex: (NSUInteger) stopIndex
{    
    if (stopIndex >= [[watchedRoutesByStopNumber allKeys] count]) return 0;
    
    NSString * stopNumber = [[self sortedKeys] objectAtIndex: stopIndex];
    
    return [self countOfRoutesAtStopNumber:stopNumber];
}

- (NSUInteger) countOfAllWatchedStopRoutes
{
    NSUInteger count = 0;
    
    for (NSString * stopNumber in [watchedRoutesByStopNumber allKeys])
    {
        if (stopNumber != nil)
        {
            NSArray * stopRoutes = [watchedRoutesByStopNumber objectForKey:stopNumber];
            
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
        
    if ([[watchedRoutesByStopNumber allKeys] containsObject:stopRoute.stop.stopID])
    {
        stopRouteArray = [watchedRoutesByStopNumber objectForKey:stopRoute.stop.stopID];
        
        if ([stopRouteArray containsObject:stopRoute])
        {
            return;
        }
    }
    
    if (stopRouteArray == nil)
    {
        stopRouteArray = [[NSMutableArray alloc] init];
        [watchedRoutesByStopNumber setValue:stopRouteArray forKey:stopRoute.stop.stopID];
    }
    
    [stopRouteArray addObject:stopRoute];
    [watchedStops addObject:stopRoute.stop];
}

- (void) removeStopRouteAtIndex: (NSUInteger) routeIndex withStopNumber: (NSString*) stopNumber
{
    if (![[self sortedKeys] containsObject:stopNumber]) return;
    
    NSMutableArray * stopRouteArray = [watchedRoutesByStopNumber objectForKey:stopNumber];
    
    if (routeIndex >= [stopRouteArray count]) return;
    
    StopRoute * stopRouteToRemove = [[self sortedStopRoutesWithStopNumber: stopNumber] objectAtIndex:routeIndex];
    
    [stopRouteArray removeObject:stopRouteToRemove];
    
    if ([stopRouteArray count] <= 0)
    {
        [watchedStops removeObject:stopRouteToRemove.stop];
        [watchedRoutesByStopNumber removeObjectForKey:stopNumber];
    }
}

- (void) removeStopRouteAtIndex: (NSUInteger) routeIndex withStopIndex: (NSUInteger) stopIndex
{
    if (stopIndex >= [watchedRoutesByStopNumber count]) return;
    
    NSString * stopNumber = [[self sortedKeys] objectAtIndex: stopIndex];
    
    [self removeStopRouteAtIndex:routeIndex withStopNumber:stopNumber];

}

- (BOOL) containsStopRoute:(StopRoute*)stopRoute
{
    for (NSMutableArray * array in [watchedRoutesByStopNumber allValues])
    {
        for (StopRoute * route in array)
        {
            if ([stopRoute isEqual: route])
                return YES;
        }
    }

    return NO;
}

- (NSDictionary*) makeUpdateNotificationUserInfoWithCurrentStopCount: (NSString*) currentStopCount andTotal: (NSString*) totalStopCount
{
    NSMutableDictionary * userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:currentStopCount forKey:REFRESH_NOTIFICATION_USERINFO_CURRENT_COUNT];
    [userInfo setObject:totalStopCount forKey:REFRESH_NOTIFICATION_USERINFO_TOTAL_COUNT];
    
    return userInfo;
}

- (NSDictionary*) makeUpdateEndedUserInfoWithReason: (NSString*) reason
{
    NSMutableDictionary * userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:reason forKey:REFRESH_NOTIFICATION_USERINFO_UPDATE_ENDED_REASON];
    
    return userInfo;
}

- (void) refreshStopsWithNumbers: (NSArray*) numbersOfStopsToRefresh andCatchError: (NSError**) error
{
    if (self.isRefreshing) return;
    
    isRefreshing = YES;
    
    if (numbersOfStopsToRefresh == nil) return;
        
    NSUInteger currentCount = 0;
    
    for (NSString * stopNumber in numbersOfStopsToRefresh)
    {
        if (shouldCancel)
        {
            NSDictionary * userInfo = [self makeUpdateEndedUserInfoWithReason:@"Cancelled"];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_NOTIFICATION_UPDATE_ENDED_NAME object:self userInfo: userInfo];
            
            break;
        }
            
        
        currentCount++;
        
        NSDictionary * userInfo = [self makeUpdateNotificationUserInfoWithCurrentStopCount:[NSString stringWithFormat:@"%d",currentCount] andTotal:[NSString stringWithFormat:@"%d", numbersOfStopsToRefresh.count]];
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_NOTIFICATION_UPDATE_NAME object:self userInfo: userInfo];
        
        Stop * stop = [self getStopByNumber:stopNumber];

        [stop refreshAndCatchError:error];
    }
    
    if (currentCount == [numbersOfStopsToRefresh count])
    {
        NSDictionary * userInfo = [self makeUpdateEndedUserInfoWithReason:@"Completed"];
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_NOTIFICATION_UPDATE_ENDED_NAME object:self userInfo: userInfo];
    }
    
    isRefreshing = NO;
    shouldCancel = NO;
}

- (void) refreshAndCatchError: (NSError**) error
{
    [self refreshStopsWithNumbers:[self sortedKeys] andCatchError:error];
}

- (void) requestCancel
{
    shouldCancel = YES;
}

- (void) dealloc
{
    [watchedRoutesByStopNumber release];
    [watchedStops release];
    
    [super dealloc];
}

@end
