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
}

-(Stop*) initWithAdapter: (TranslinkAdapter*) inputAdapter stopId: (NSString*) inputId;

@property (readonly) NSString * stopID;
@property (readonly) NSString * stopName;
@property (readonly) StopRouteCollection * routes;


@end
