//
//  AddStopViewController.h
//  Bussy
//
//  Created by James Li on 11-07-03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalViewDelegate;

@interface AddStopViewController : UIViewController <UIAlertViewDelegate>{
    UITextField * stopNumberTextField;
    
    id<ModalViewDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UITextField * stopNumberTextField;

@property (nonatomic, assign) id<ModalViewDelegate> delegate;

@end
