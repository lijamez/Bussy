//
//  WatchedStopsCollection.h
//  Bussy
//
//  Created by James Li on 11-07-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StopRoute.h"

@interface WatchedStopRoutesCollection : NSObject
{
    NSMutableDictionary * routesByStopNumber;
}

- (NSUInteger) countOfStops;
- (NSUInteger) countOfRoutesAtStopNumber: (NSString*) stopNumber;
- (NSUInteger) countOfRoutesAtStopIndex: (NSUInteger) stopIndex;
- (NSUInteger) countOfItems;
- (NSArray*) stopNumbers;
- (StopRoute*) stopRouteAtIndex: (NSUInteger) routeIndex withStopNumber: (NSString*) stopNumber;
- (NSArray*) stopRoutesWithStopNumber: (NSString*) stopNumber;
- (id) stopRouteAtIndex: (NSUInteger) routeIndex withStopIndex: (NSUInteger) stopIndex;
- (void) insertStopRoute:(StopRoute*)stopRoute;
- (void) removeStopRouteAtIndex: (NSUInteger) routeIndex withStopNumber: (NSString*) stopNumber;
- (void) removeStopRouteAtIndex: (NSUInteger) routeIndex withStopIndex: (NSUInteger) stopIndex;
- (NSArray*) stopRoutesWithStopIndex: (NSUInteger) stopIndex;
-(BOOL) containsStopRoute:(StopRoute*)stopRoute;

@end
