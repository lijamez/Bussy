//
//  Adapter.h
//  Bussy
//
//  Created by James Li on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stop.h"
#import "TranslinkAdapter.h"
#import "StopRoute.h"
#import "SBJson.h"

@interface TranslinkService : NSObject {
    
}

-(Stop*) getStop: (NSString*) stopID;
-(NSArray*) getStopRoutesForStop: (Stop*) stop;

@end
