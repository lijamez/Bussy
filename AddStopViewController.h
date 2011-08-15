//
//  AddStopViewController.h
//  Bussy
//
//  Created by James Li on 11-07-03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FancyViewController.h"
#import "Stop.h"

@protocol ModalViewDelegate;

@interface AddStopViewController : FancyViewController <UIAlertViewDelegate>{
    UITextField * stopNumberTextField;
    
    id<ModalViewDelegate> delegate;
    
    StopRouteCollection * foundStopRoutes;
}

@property (nonatomic, retain) IBOutlet UITextField * stopNumberTextField;

@property (nonatomic, assign) id<ModalViewDelegate> delegate;

@end
