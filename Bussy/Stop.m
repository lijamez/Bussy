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

-(Stop*) stopId: (NSString*) inputId name: (NSString*) inputName
{
    self = [super init];
    if (self)
    {
        [inputId retain];
        [inputName retain];
        stopId = inputId;
        name = inputName;
        routes = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(NSString*) stopID
{
    return stopId;
}

-(NSString*) stopName
{
    return name;
}

-(void) addRoute: (StopRoute*) sr
{
    [routes addObject:sr];
}

-(void) clearRoutes
{
    [routes removeAllObjects];
}

-(NSArray*) routes
{
    return [NSArray arrayWithArray:routes];
}

-(void) dealloc
{
    [stopId release];
    [name release];
    [routes release];
    [super dealloc];
}

@end
