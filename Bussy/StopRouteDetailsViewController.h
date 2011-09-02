//
//  StopRouteDetailsViewController.h
//  Bussy
//
//  Created by James Li on 11-07-08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>
#import "StopRoute.h"

@interface StopRouteDetailsViewController : UIViewController<UIActionSheetDelegate, MFMessageComposeViewControllerDelegate>
{
    UILabel * stopRouteNumberLabel;
    UILabel * stopRouteNameLabel;
    UILabel * stopNumberLabel;
    UILabel * directionLabel;
    UILabel * lastRefreshedLabel;
    UITableView * timesTableView;
    UIBarButtonItem * exportBarButton;
    UILabel * noServiceLabel;
    
    StopRoute * stopRoute;
    NSMutableArray * actionSheetActions;
}

@property (nonatomic, retain) UIBarButtonItem * exportBarButton;
@property (nonatomic, retain) IBOutlet UILabel * stopRouteNumberLabel;
@property (nonatomic, retain) IBOutlet UILabel * stopRouteNameLabel;
@property (nonatomic, retain) IBOutlet UILabel * stopNumberLabel;
@property (nonatomic, retain) IBOutlet UILabel * directionLabel;
@property (nonatomic, retain) IBOutlet UILabel * lastRefreshedLabel;
@property (nonatomic, retain) IBOutlet UITableView * timesTableView;
@property (nonatomic, retain) IBOutlet UILabel * noServiceLabel;

@property (nonatomic, retain) StopRoute * stopRoute;

@end
