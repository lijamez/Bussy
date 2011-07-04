//
//  AddStopViewController.h
//  Bussy
//
//  Created by James Li on 11-07-03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalViewDelegate;

@interface AddStopViewController : UIViewController {
    UIBarButtonItem * doneButton;
    UIBarButtonItem * cancelButton;
    UITextField * textField;
    
    id<ModalViewDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem * doneButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * cancelButton;
@property (nonatomic, retain) IBOutlet UITextField * textField;

@property (nonatomic, assign) id<ModalViewDelegate> delegate;

@end
