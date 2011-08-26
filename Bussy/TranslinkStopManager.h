//
//  TranslinkStopManager.h
//  Bussy
//
//  Created by James Li on 11-08-23.
//  Copyright (c) 2011 University of British Columbia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stop.h"
#import "TranslinkAdapter.h"

@interface TranslinkStopManager : NSObject
{
}

+ (void) setAdapter: (TranslinkAdapter*) inputAdapter;
+ (Stop*) getStopWithNumber: (NSString*) stopNumber;
+ (Stop*) getStopWithNumber: (NSString*) stopNumber lastRefreshDate: (NSDate*) inputLastRefreshedDate exists: (BOOL) inputExists;

@end
