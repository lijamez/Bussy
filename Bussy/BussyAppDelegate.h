//
//  BussyAppDelegate.h
//  Bussy
//
//  Created by James Li on 11-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface BussyAppDelegate : NSObject <UIApplicationDelegate> {

    IBOutlet RootViewController *rootViewController;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
