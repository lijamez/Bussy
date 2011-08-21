//
//  AbstractTranslinkObject.m
//  Bussy
//
//  Created by James Li on 11-08-21.
//  Copyright (c) 2011 University of British Columbia. All rights reserved.
//

#import "AbstractTranslinkObject.h"

@implementation AbstractTranslinkObject

@synthesize adapter, status;



- (AbstractTranslinkObject*) initWithAdapter: (TranslinkAdapter*) adapter
{
    return nil;
}

- (void) refreshAndCatchError: (NSError**) error { }

@end
