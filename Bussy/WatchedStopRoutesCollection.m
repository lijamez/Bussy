//
//  WatchedStopsCollection.m
//  Bussy
//
//  Created by James Li on 11-07-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WatchedStopRoutesCollection.h"

@implementation WatchedStopRoutesCollection
@synthesize items;

- (id)init
{
    self = [super init];
    if (self) {
        items = [[NSMutableArray alloc] init];
        [items retain];
    }

    return self;
}

- (NSUInteger) countOfItems
{
    return [items count];
}

- (id) objectInItemsAtIndex:(NSUInteger)index
{
    return [items objectAtIndex:index];
}

- (void) insertObject:(id)object inItemsAtIndex:(NSUInteger)index;
{
    [items insertObject:object atIndex:index];
}

- (void) removeObjectFromItemsAtIndex:(NSUInteger)index
{
    [items removeObjectAtIndex:index];
}

- (void) replaceObjectInItemsAtIndex:(NSUInteger)index withObject:(id)object;
{
    [items replaceObjectAtIndex:index withObject:object];
}

- (void) addObject:(id)object
{
    [items addObject:object];
}

-(BOOL) containsObject:(id)object
{
    return [items containsObject:object];
}

@end
