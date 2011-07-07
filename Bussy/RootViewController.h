//
//  RootViewController.h
//  Bussy
//
//  Created by James Li on 11-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StopRoute.h"

@protocol ModalViewDelegate

- (void) didReceiveStopRoute: (StopRoute*) newStopRoute;

@end

@interface RootViewController : UITableViewController<ModalViewDelegate> {
    
    NSMutableArray * watchedStopRoutes;
    UIBarButtonItem	* addBarButton;
}

@property (nonatomic, retain) UIBarButtonItem * addBarButton;
@property (nonatomic, retain) NSMutableArray * watchedStopRoutes;

- (IBAction)	addWatchedStop:		(id) sender;

- (void) save;

@end
