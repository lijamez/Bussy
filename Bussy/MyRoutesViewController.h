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
#import "AbstractFancyViewController.h"

@protocol ModalViewDelegate

- (void) didReceiveStopRoute: (StopRoute*) newStopRoute;

@end

@interface MyRoutesViewController : AbstractFancyViewController<ModalViewDelegate> {
    
    WatchedStopRoutesCollection * watchedStopRoutes;
    UIBarButtonItem	* addBarButton;
    UIBarButtonItem	* refreshBarButton;
    UIImageView * imageView;
    UITableView * stopRoutesTableView;
    UILabel * noRoutesLabel;
    
    NSTimeInterval minAgeToRefresh;
}

@property (nonatomic, retain) UIBarButtonItem * addBarButton;
@property (nonatomic, retain) UIBarButtonItem * refreshBarButton;
@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, retain) IBOutlet UITableView * stopRoutesTableView;
@property (nonatomic, retain) IBOutlet UILabel * noRoutesLabel;

@property (nonatomic, retain) WatchedStopRoutesCollection * watchedStopRoutes;

- (IBAction)	addWatchedStopRoute:		(id) sender;
- (void) loadDataFromSave;

- (void) save;

@end
