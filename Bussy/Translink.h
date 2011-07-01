//
//  Translink.h
//  Bussy
//
//  Created by James Li on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Translink : NSObject {
    
    
}

+(NSString*) requestArrivalTimesAtStop: (NSString*) stopID;
+(NSString*) requestRouteSearch: (NSString*) searchString;
+(NSString*) requestRouteDirection: (NSString*) routeID;
+(NSString*) requestRouteStops: (NSString*) routeID direction: (NSString*) direction;
+(NSString*) requestStop: (NSString*) stopID;
+(NSString*) requestStopLocation: (NSString*) stopID;
+(NSString*) requestStopsByLat: (NSString*) latitude longitude: (NSString*) longitude;

@end
