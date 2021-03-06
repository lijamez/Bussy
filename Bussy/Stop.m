//
//  Stop.m
//  Bussy
//
//  Created by James Li on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Stop.h"
#import "AbstractTranslinkObject.h"

@implementation Stop
@synthesize stopID, stopName, routes, lastRefreshedDate, exists;

-(Stop*) initWithAdapter: (TranslinkAdapter*) inputAdapter stopId: (NSString*) inputId lastRefreshedDate: (NSDate*) inputLastRefreshedDate exists: (BOOL) inputExists
{
    self = [super init];
    if (self)
    {
        adapter = inputAdapter;
        [adapter retain];
        
        stopID = inputId;
        [stopID retain];
        
        routes = [[StopRouteCollection alloc] initWithAdapter:inputAdapter stop:self];
        [routes retain];
        
        lastRefreshedDate = inputLastRefreshedDate;
        [lastRefreshedDate retain];
        
        exists = inputExists;
                 
        status = NOT_LOADED;
    }
    
    return self;
}

- (void) refreshAndCatchError: (NSError**) error
{
    status = REFRESHING;
    
    NSString * json = [adapter requestStop:stopID error:error];
    
    if (*error)
        return;
    
    SBJsonParser * parser = [[SBJsonParser alloc] init];
    
    NSError * parsingError = nil;
    
    NSArray * entries = [parser objectWithString:json error:&parsingError];
    
    if (parsingError)
    {
        *error = parsingError;
        return;
    }
    
    BOOL stopFound = NO;
    
    for (NSArray * result in entries)
    {
        NSString * resultStopID = [[result objectAtIndex:0] stringValue];
        if ([resultStopID isEqualToString:self.stopID])
        {
            
            stopName = [result objectAtIndex:1];
            [stopName retain];
            
            if (routes == nil)
            {
                routes = [[StopRouteCollection alloc] initWithAdapter: adapter stop: self];
            }
            
            [routes refreshAndCatchError:error];
            
            stopFound = YES;
            break;
        }
    }
    
    exists = stopFound;
    
    [lastRefreshedDate release];
    lastRefreshedDate = [NSDate date];
    [lastRefreshedDate retain];

    status = VALID;

}

- (NSString*) getCoordinates
{
    NSString * kml = [adapter requestStopLocation:self.stopID error:nil];
    
    NSString * coordinates = nil;

    if (kml != nil)
    {
        NSRange beginTag = [kml rangeOfString:@"<coordinates>"];
        NSRange endTag = [kml rangeOfString:@"</coordinates>"];
        
        if (beginTag.location == NSNotFound || endTag.location == NSNotFound)
        {
            return nil;
        }
        
        NSRange coordinatesRange;
        coordinatesRange.location = beginTag.location + beginTag.length;
        coordinatesRange.length = endTag.location - coordinatesRange.location ;
        
        coordinates = [kml substringWithRange:coordinatesRange];
        
        //Coordinates are origignally given in longitude and latitude, so need to flip them.
        NSRange commaRange = [coordinates rangeOfString:@","];
        
        NSString * longitude = [coordinates substringToIndex:commaRange.location];
        NSString * latitude = [coordinates substringFromIndex:commaRange.location+1];
        
        coordinates = [NSString stringWithFormat:@"%@,%@", latitude, longitude];
    }
    
    return coordinates;
}

- (NSComparisonResult) compareStopNumberAscending: (Stop*) otherStop
{
    return [self.stopID compare: otherStop.stopID];
}

- (NSComparisonResult) compareStopNumberDescending: (Stop*) otherStop
{
    NSComparisonResult result = [self.stopID compare: otherStop.stopID];
    
    if (result == NSOrderedAscending)
    {
        return NSOrderedDescending;
    }
    else if (result == NSOrderedDescending)
    {
        return NSOrderedAscending;
    }
    
    return NSOrderedSame;
}

- (BOOL) isEqual:(id)object
{
    
    if (object == self) //identity rule
        return YES;
    if (object == nil) //nil rule
        return NO;
    if (![object isKindOfClass:[self class]])
        return NO;  //unrecognized class
    
    Stop * otherStop = (Stop*) object;
    return [self hash] == [otherStop hash];
    
}

- (NSUInteger) hash
{
    int prime = 31;
    int result = 1;
    
    result = prime * result + [stopID hash];
    
    return result;
}

- (id)copyWithZone:(NSZone *)zone
{
    [self retain];
    return self;
}

-(void) dealloc
{
    [stopID release];
    [stopName release];
    [routes release];
    [adapter release];
    [lastRefreshedDate release];
    
    [super dealloc];
}



@end
