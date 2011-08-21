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



@interface AbstractTranslinkObject : NSObject
{
    TranslinkAdapter * adapter;
    Status status;
    
}

- (AbstractTranslinkObject*) initWithAdapter: (TranslinkAdapter*) adapter;
- (void) refreshAndCatchError: (NSError**) error;

@property (readonly) TranslinkAdapter * adapter;
@property (readonly) Status status;

@end


