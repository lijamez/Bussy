//
//  ActionSheetAction.h
//  Bussy
//
//  Created by James Li on 11-09-02.
//  Copyright (c) 2011 University of British Columbia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionSheetAction : NSObject
{
    NSString * actionName;
    SEL actionMethod;
}

@property (retain) NSString * actionName;
@property SEL actionMethod;

- (id) initWithActionName: (NSString*) name selector: (SEL) selector;

@end
