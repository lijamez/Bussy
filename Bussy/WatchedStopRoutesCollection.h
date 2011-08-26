//
//  WatchedStopsCollection.h
//  Bussy
//
//  Created by James Li on 11-07-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StopRoute.h"

typedef enum
{
    ASCENDING,
    DESCENDING
} SortMethod;

@interface WatchedStopRoutesCollection : NSObject
{
    NSMutableDictionary * watchedRoutesByStopNumber;
    NSMutableSet * watchedStops;
    
    SortMethod stopsSortMethod;
    SortMethod stopRoutesSortMethod;
}

- (NSUInteger) countOfStops;
- (NSUInteger) countOfRoutesAtStopNumber: (NSString*) stopNumber;
- (NSUInteger) countOfRoutesAtStopIndex: (NSUInteger) stopIndex;
- (NSUInteger) countOfAllWatchedStopRoutes;
- (NSArray*) stopNumbers;
- (StopRoute*) stopRouteAtIndex: (NSUInteger) routeIndex withStopNumber: (NSString*) stopNumber;
- (NSArray*) stopRoutesWithStopNumber: (NSString*) stopNumber;
- (id) stopRouteAtIndex: (NSUInteger) routeIndex withStopIndex: (NSUInteger) stopIndex;
- (void) insertStopRoute:(StopRoute*)stopRoute;
- (void) removeStopRouteAtIndex: (NSUInteger) routeIndex withStopNumber: (NSString*) stopNumber;
- (void) removeStopRouteAtIndex: (NSUInteger) routeIndex withStopIndex: (NSUInteger) stopIndex;
- (NSArray*) stopRoutesWithStopIndex: (NSUInteger) stopIndex;
-(BOOL) containsStopRoute:(StopRoute*)stopRoute;
- (void) refreshAndCatchError: (NSError**) error;
- (void) refreshStopsWithNumbers: (NSArray*) numbersOfStopsToRefresh andCatchError: (NSError**) error;

@property (readwrite) SortMethod stopsSortMethod;
@property (readwrite) SortMethod stopRoutesSortMethod;


@end
