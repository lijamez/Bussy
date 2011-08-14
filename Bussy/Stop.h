//
//  Stop.h
//  Bussy
//
//  Created by James Li on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TranslinkObject.h"
#import "TranslinkAdapter.h"
#import "StopRouteCollection.h"

@interface Stop : NSObject<TranslinkObject> {
    @private
    NSString * stopID;
    NSString * stopName;
    StopRouteCollection * routes;
    TranslinkAdapter * adapter;
    NSDate * lastRefreshedDate;
}

-(Stop*) initWithAdapter: (TranslinkAdapter*) inputAdapter stopId: (NSString*) inputId error: (NSError**) error;

@property (readonly) NSString * stopID;
@property (readonly) NSString * stopName;
@property (readonly) StopRouteCollection * routes;
@property (readonly) NSDate * lastRefreshedDate;


- (BOOL) isEqual:(id)object;

@end
