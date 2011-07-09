//
//  StopRouteDetailsViewController.h
//  Bussy
//
//  Created by James Li on 11-07-08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StopRoute.h"

@interface StopRouteDetailsViewController : UIViewController
{
    UILabel * stopRouteNameLabel;
    UILabel * stopNumberLabel;
    UITableView * timesTableView;
    
    StopRoute * stopRoute;
}

@property (nonatomic, retain) IBOutlet UILabel * stopRouteNameLabel;
@property (nonatomic, retain) IBOutlet UILabel * stopNumberLabel;
@property (nonatomic, retain) IBOutlet UITableView * timesTableView;

@property (nonatomic, retain) StopRoute * stopRoute;

@end
