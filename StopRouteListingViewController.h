//
//  StopRouteListingViewController.h
//  Bussy
//
//  Created by James Li on 11-07-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickStopRouteDelegate;

@interface StopRouteListingViewController : UIViewController {
    NSMutableArray * stopRoutes;
    
    UIBarButtonItem * cancelButton;
    UITableView * stopRouteListing;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem * cancelButton;
@property (nonatomic, retain) IBOutlet UITableView * stopRouteListing;

@end
