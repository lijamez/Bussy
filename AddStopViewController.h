//
//  AddStopViewController.h
//  Bussy
//
//  Created by James Li on 11-07-03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractFancyViewController.h"
#import "Stop.h"

@protocol ModalViewDelegate;

@interface AddStopViewController : AbstractFancyViewController <UIAlertViewDelegate>{
    UITextField * stopNumberTextField;
    UILabel * enterStopNumberLabel;
    
    id<ModalViewDelegate> delegate;
    
    StopRouteCollection * foundStopRoutes;
}

@property (nonatomic, retain) IBOutlet UITextField * stopNumberTextField;
@property (nonatomic, retain) IBOutlet UILabel * enterStopNumberLabel;

@property (nonatomic, retain) StopRouteCollection * foundStopRoutes;
@property (nonatomic, assign) id<ModalViewDelegate> delegate;

@end
