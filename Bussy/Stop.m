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
        stopId = inputId;
        name = inputName;
        routes = [routes init];
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


@end
