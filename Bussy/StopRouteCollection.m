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

- (StopRouteCollection*) initWithAdapter: (TranslinkAdapter*) inputAdapter stop: (Stop*) inputStop error: (NSError**) error
{
    self = [super init];
    if (self) {
        
        array = [[NSMutableArray alloc] init];
        [array retain];
        
        stop = inputStop;
        [stop retain];
        
        adapter = inputAdapter;
        [adapter retain];
        
        [self refreshAndCatchError: error];
        
    }
    
    return self;
}

- (void) refreshAndCatchError: (NSError**) error
{
    [array removeAllObjects];
    
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
            
            StopRoute * stopRoute = [[StopRoute alloc] stop:stop direction:entryDirection routeID:entryRouteID routeName:entryRouteName times:entryTimes];
            
            [array addObject:stopRoute];
            
        }
    }
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
