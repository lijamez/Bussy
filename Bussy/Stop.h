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
    NSString * stopId;
    NSString * name;
    NSMutableArray * routes;
}

-(Stop*) stopId: (NSString*) inputId name: (NSString*) inputName;

-(NSString*) stopID;
-(NSString*) stopName;
-(NSArray*) routes;

@end
