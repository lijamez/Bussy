//
//  Stop.m
//  Bussy
//
//  Created by James Li on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Stop.h"
#import "StopRoute.h"

@implementation Stop
@synthesize stopID, stopName, routes;

-(Stop*) stopId: (NSString*) inputId name: (NSString*) inputName
{
    self = [super init];
    if (self)
    {
        stopID = inputId;
        [stopID retain];
        
        stopName = inputName;
        [stopName retain];
        
        routes = [[NSMutableArray alloc] init];
        [routes retain];
    }
    
    return self;
}

-(void) addRoute: (StopRoute*) sr
{
    [routes addObject:sr];
}

-(void) clearRoutes
{
    [routes removeAllObjects];
}

-(void) dealloc
{
    [stopID release];
    [stopName release];
    [routes release];
    [super dealloc];
}

@end
