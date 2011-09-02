//
//  ActionSheetAction.m
//  Bussy
//
//  Created by James Li on 11-09-02.
//  Copyright (c) 2011 University of British Columbia. All rights reserved.
//

#import "ActionSheetAction.h"


@implementation ActionSheetAction

@synthesize actionName, actionMethod;

- (id) initWithActionName: (NSString*) name selector: (SEL) selector
{
    self = [super init];
    if (self) 
    {
        self.actionName = name;
        self.actionMethod = selector;
    }
    return self;
}


@end
