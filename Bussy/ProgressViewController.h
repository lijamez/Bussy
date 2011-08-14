//
//  ProgressView.h
//  Bussy
//
//  Created by James Li on 11-08-13.
//  Copyright (c) 2011 University of British Columbia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressViewController : UIViewController {

    UIActivityIndicatorView * activityView;

}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView * activityView;

@end
