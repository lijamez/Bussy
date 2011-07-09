//
//  ArrivalTime.h
//  Bussy
//
//  Created by James Li on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TranslinkObject.h"

@class Stop;

@interface StopRoute : NSObject {
    
    Stop * stop;
    NSString * direction;
    NSString * routeID;
    NSString * routeName;
    NSArray * times;
}

-(StopRoute*) stop: (Stop*) inputStop direction: (NSString*) inputDirection routeID: (NSString*) inputRouteID routeName: (NSString*) inputRouteName times: (NSArray*) inputTimes;

@property (readonly) NSString * routeName;
@property (readonly) NSArray * times;
@property (readonly) NSString * routeID;
@property (readonly) NSString * direction;
@property (readonly) Stop * stop;

- (NSString*) generateTimesString;
- (NSString*) generateTitle;

@end
