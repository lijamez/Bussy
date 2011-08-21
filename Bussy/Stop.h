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
}

-(Stop*) initWithAdapter: (TranslinkAdapter*) inputAdapter stopId: (NSString*) inputId;

@property (readonly) NSString * stopID;
@property (readonly) NSString * stopName;
@property (readonly) StopRouteCollection * routes;

- (BOOL) isEqual:(id)object;

@end
