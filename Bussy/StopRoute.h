//
//  ArrivalTime.h
//  Bussy
//
//  Created by James Li on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stop.h"

typedef enum 
{
    North, 
    East, 
    South, 
    West,
    Unknown
} Direction;

@interface StopRoute : NSObject {
    
    Stop * stop;
    Direction direction;
    NSString * routeID;
    NSString * routeName;
    NSArray * times;

    bool favourite;
}

-(StopRoute*) stop: (Stop*) inputStop direction: (Direction) inputDirection routeID: (NSString*) inputRouteID routeName: (NSString*) inputRouteName times: (NSArray*) inputTimes;
-(NSString*) getRouteID;
-(NSArray*) getArrivalTimes;

@end
