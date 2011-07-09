//
//  StopRouteCollection.h
//  Bussy
//
//  Created by James Li on 11-07-08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TranslinkObject.h"
#import "StopRoute.h"

@class Stop;

@interface StopRouteCollection : NSObject<TranslinkObject>
{
    NSMutableArray * array;
    
    Stop * stop;
    TranslinkAdapter * adapter;
    
}

- (StopRouteCollection*) initWithAdapter: (TranslinkAdapter*) inputAdapter stop: (Stop*) inputStop;
- (NSArray*) array;

@property (readonly) Stop * stop;

@end
