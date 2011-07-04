//
//  RootViewController.h
//  Bussy
//
//  Created by James Li on 11-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalViewDelegate

- (void) didReceiveStopNumber: (NSString*) newStopNumber;

@end

@interface RootViewController : UITableViewController<ModalViewDelegate> {
    NSMutableArray * watchedStops;
    
    UIBarButtonItem	* addBarButton;
    
    
}

@property (nonatomic, retain) UIBarButtonItem * addBarButton;

- (IBAction)	addWatchedStop:		(id) sender;

@end
