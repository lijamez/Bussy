//
//  Stop.h
//  Bussy
//
//  Created by James Li on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractTranslinkObject.h"
#import "TranslinkAdapter.h"
#import "StopRouteCollection.h"

@interface Stop : AbstractTranslinkObject {
    @private
    NSString * stopID;
    NSString * stopName;
    StopRouteCollection * routes;
    NSDate * lastRefreshedDate;
    BOOL exists;
}

-(Stop*) initWithAdapter: (TranslinkAdapter*) inputAdapter stopId: (NSString*) inputId lastRefreshedDate: (NSDate*) inputLastRefreshedDate exists: (BOOL) inputExists;

@property (readonly) NSString * stopID;
@property (readonly) NSString * stopName;
@property (readonly) StopRouteCollection * routes;
@property (readonly) NSDate * lastRefreshedDate;
@property (readwrite) BOOL exists;

- (NSString*) getCoordinates;
- (NSComparisonResult) compareStopNumberAscending: (Stop*) otherStop;
- (NSComparisonResult) compareStopNumberDescending: (Stop*) otherStop;

- (BOOL) isEqual:(id)object;

@end
