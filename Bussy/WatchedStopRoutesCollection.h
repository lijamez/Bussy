//
//  WatchedStopsCollection.h
//  Bussy
//
//  Created by James Li on 11-07-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WatchedStopRoutesCollection : NSObject
{
    NSMutableArray * items;
    
}

@property (readonly, retain) NSMutableArray * items;

- (NSUInteger) countOfItems;
- (id) objectInItemsAtIndex:(NSUInteger)index;
- (void) insertObject:(id)object inItemsAtIndex:(NSUInteger)index;
- (void) removeObjectFromItemsAtIndex:(NSUInteger)index;
- (void) replaceObjectInItemsAtIndex:(NSUInteger)index withObject:(id)object;

- (void) addObject: (id) object;
- (BOOL) containsObject: (id) object;
@end
