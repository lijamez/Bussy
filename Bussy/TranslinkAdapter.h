//
//  Translink.h
//  Bussy
//
//  Created by James Li on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TranslinkAdapter : NSObject {
    
    
}

-(NSString*) requestArrivalTimesAtStop: (NSString*) stopID error: (NSError**) error;
-(NSString*) requestRouteSearch: (NSString*) searchString error: (NSError**) error;
-(NSString*) requestRouteDirection: (NSString*) routeID error: (NSError**) error;
-(NSString*) requestRouteStops: (NSString*) routeID direction: (NSString*) direction error: (NSError**) error;
-(NSString*) requestStop: (NSString*) stopID error: (NSError**) error;
-(NSString*) requestStopLocation: (NSString*) stopID error: (NSError**) error;
-(NSString*) requestStopsByLat: (NSString*) latitude longitude: (NSString*) longitude error: (NSError**) error;

@end
