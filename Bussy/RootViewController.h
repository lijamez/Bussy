//
//  RootViewController.h
//  Bussy
//
//  Created by James Li on 11-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stop.h"

@protocol ModalViewDelegate

- (void) didReceiveStop: (Stop*) newStop;

@end

@interface RootViewController : UITableViewController<ModalViewDelegate> {
    NSMutableArray * watchedStops;
    
    UIBarButtonItem	* addBarButton;
    
    
}

@property (nonatomic, retain) UIBarButtonItem * addBarButton;

@property (nonatomic, retain) NSMutableArray * watchedStops;

- (IBAction)	addWatchedStop:		(id) sender;

- (void) save;

@end
