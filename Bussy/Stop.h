//
//  Stop.h
//  Bussy
//
//  Created by James Li on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Stop : NSObject {
    @private
    NSString * stopID;
    NSString * stopName;
    NSMutableArray * routes;
}

-(Stop*) stopId: (NSString*) inputId name: (NSString*) inputName;

@property (readonly) NSString * stopID;
@property (readonly) NSString * stopName;
@property (readonly) NSArray * routes;


@end
