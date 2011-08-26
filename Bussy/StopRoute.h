//
//  ArrivalTime.h
//  Bussy
//
//  Created by James Li on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Stop;

@interface StopRoute : NSObject 
{
    Stop * stop;
    NSString * direction;
    NSString * routeID;
    NSString * routeName;
    NSArray * times;
    BOOL exists;
}

-(StopRoute*) initWithStop: (Stop*) inputStop direction: (NSString*) inputDirection routeID: (NSString*) inputRouteID routeName: (NSString*) inputRouteName times: (NSArray*) inputTimes exists: (BOOL) inputExists;

@property (retain) NSString * routeName;
@property (retain) NSArray * times;
@property (retain) NSString * routeID;
@property (retain) NSString * direction;
@property (readonly) Stop * stop;
@property (readwrite) BOOL exists;

- (NSString*) generateTimesString;
- (NSString*) displayRouteName;
- (NSComparisonResult) compareStopRouteIDAscending: (StopRoute*) otherStopRoute;
- (NSComparisonResult) compareStopRouteIDDescending: (StopRoute*) otherStopRoute;


@end
