//
//  TranslinkStopManager.m
//  Bussy
//
//  Created by James Li on 11-08-23.
//  Copyright (c) 2011 University of British Columbia. All rights reserved.
//

#import "TranslinkStopManager.h"
#import "TranslinkAdapter.h"
#import "Stop.h"

@implementation TranslinkStopManager

static NSMutableDictionary * retrievedStops;
static TranslinkAdapter * adapter;

+ (void) setAdapter: (TranslinkAdapter*) inputAdapter
{
    [inputAdapter retain];
    [adapter release];
    adapter = inputAdapter;
}

+ (Stop*) getStopWithNumber: (NSString*) stopNumber
{
    if (retrievedStops == nil)
    {
        retrievedStops = [[NSMutableDictionary alloc] init];
    }
    
    if (![[retrievedStops allKeys] containsObject:stopNumber])
    {
        Stop * stop = [[Stop alloc] initWithAdapter:adapter stopId:stopNumber lastRefreshedDate:nil exists: YES];
        [retrievedStops setValue:stop forKey:stopNumber];
    }
    
    return [retrievedStops objectForKey:stopNumber];
}

+ (Stop*) getStopWithNumber: (NSString*) stopNumber lastRefreshDate: (NSDate*) inputLastRefreshedDate exists: (BOOL) inputExists
{
    if (retrievedStops == nil)
    {
        retrievedStops = [[NSMutableDictionary alloc] init];
    }
    
    if (![[retrievedStops allKeys] containsObject:stopNumber])
    {
        Stop * stop = [[Stop alloc] initWithAdapter:adapter stopId:stopNumber lastRefreshedDate:inputLastRefreshedDate exists: inputExists];
        [retrievedStops setValue:stop forKey:stopNumber];
    }
    
    return [retrievedStops objectForKey:stopNumber];
}

@end
