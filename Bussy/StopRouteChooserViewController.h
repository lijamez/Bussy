//
//  StopRouteChooserViewController.h
//  Bussy
//
//  Created by James Li on 11-07-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalViewDelegate;

@interface StopRouteChooserViewController : UIViewController {
    
    UITableView * tableView;
    NSArray * stopRoutes;
    
    id<ModalViewDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UITableView * tableView;

@property (nonatomic, retain) NSArray * stopRoutes;

@property (nonatomic, assign) id<ModalViewDelegate> delegate;

@end
