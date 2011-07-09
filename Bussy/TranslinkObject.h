//
//  TranslinkObject.h
//  Bussy
//
//  Created by James Li on 11-07-08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TranslinkAdapter.h"
#import "SBJson.h"

typedef enum
{
    VALID, INVALID, REFRESHING, NOT_LOADED
} Status;



@interface TranslinkObject : NSObject
{
    TranslinkAdapter * adapter;
    Status status;
    
}

- (TranslinkObject*) initWithAdapter: (TranslinkAdapter*) adapter;
- (void) refresh;

@property (readonly) TranslinkAdapter * adapter;
@property (readonly) Status status;

@end


@protocol TranslinkObject

- (void) refresh;

@end