//
//  RootViewController.h
//  Bussy
//
//  Created by James Li on 11-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StopRoute.h"
#import "StopRouteCollection.h"
#import "WatchedStopRoutesCollection.h"
#import "MBProgressHUD.h"
#import "FancyViewController.h"

@protocol ModalViewDelegate

- (void) didReceiveStopRoute: (StopRoute*) newStopRoute;

@end

@interface RootViewController : FancyViewController<ModalViewDelegate> {
    
    NSMutableArray * watchedStopRoutes;
    UIBarButtonItem	* addBarButton;
    UIBarButtonItem	* refreshBarButton;
    UIImageView * imageView;
    UITableView * tableView;
}

@property (nonatomic, retain) UIBarButtonItem * addBarButton;
@property (nonatomic, retain) UIBarButtonItem * refreshBarButton;
@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, retain) IBOutlet UITableView * tableView;

@property (nonatomic, retain) NSMutableArray * watchedStopRoutes;

- (IBAction)	addWatchedStopRoute:		(id) sender;
- (void) loadDataFromSave;

- (void) save;

@end
