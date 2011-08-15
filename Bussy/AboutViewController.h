//
//  AboutViewController.h
//  Bussy
//
//  Created by James Li on 11-08-14.
//  Copyright (c) 2011 University of British Columbia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController {
    
    UILabel * appNameLabel;
    UILabel * versionLabel;
}

@property (nonatomic, retain) IBOutlet UILabel * appNameLabel;
@property (nonatomic, retain) IBOutlet UILabel * versionLabel;

@end
