//
//  StopRouteCollection.h
//  Bussy
//
//  Created by James Li on 11-07-08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractTranslinkObject.h"
#import "StopRoute.h"

@class Stop;

@interface StopRouteCollection : AbstractTranslinkObject
{
    NSMutableArray * array;
    
    Stop * stop;    
}

- (StopRouteCollection*) initWithAdapter: (TranslinkAdapter*) inputAdapter stop: (Stop*) inputStop;
- (NSArray*) array;
- (void) addStopRoute: (StopRoute*) stopRoute;

@property (readonly) Stop * stop;

@end
