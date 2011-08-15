//
//  BussyAppDelegate.h
//  Bussy
//
//  Created by James Li on 11-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyRoutesViewController.h"

@interface BussyAppDelegate : NSObject <UIApplicationDelegate> {

    IBOutlet MyRoutesViewController *rootViewController;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController * tabBarController;

@property (nonatomic, retain) IBOutlet UIImageView * imageView;

@end
