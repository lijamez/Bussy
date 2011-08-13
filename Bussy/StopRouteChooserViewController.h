//
//  StopRouteChooserViewController.h
//  Bussy
//
//  Created by James Li on 11-07-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalViewDelegate;

@class StopRouteCollection;

@interface StopRouteChooserViewController : UIViewController {
    
    UITableView * stopRouteTableView;
    
    StopRouteCollection * stopRoutes;
    
    id<ModalViewDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UITableView * stopRouteTableView;

@property (nonatomic, retain) StopRouteCollection * stopRoutes;

@property (nonatomic, assign) id<ModalViewDelegate> delegate;

@end
