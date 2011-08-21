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
    NSDate * lastRefreshedDate;
}

-(StopRoute*) initWithStop: (Stop*) inputStop direction: (NSString*) inputDirection routeID: (NSString*) inputRouteID routeName: (NSString*) inputRouteName times: (NSArray*) inputTimes lastRefreshedDate: (NSDate*) inputLastRefreshedDate;

@property (readonly) NSString * routeName;
@property (readonly) NSArray * times;
@property (readonly) NSString * routeID;
@property (readonly) NSString * direction;
@property (readonly) Stop * stop;
@property (readonly) NSDate * lastRefreshedDate;

- (NSString*) generateTimesString;


@end
