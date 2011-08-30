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
    UILabel * copyrightLabel;
    UILabel * acknowledgementsLabel;
    UILabel * acknowledgementsContentsLabel;
    UILabel * disclaimerLabel;
}

@property (nonatomic, retain) IBOutlet UILabel * appNameLabel;
@property (nonatomic, retain) IBOutlet UILabel * versionLabel;
@property (nonatomic, retain) IBOutlet UILabel * copyrightLabel;
@property (nonatomic, retain) IBOutlet UILabel * acknowledgementsLabel;
@property (nonatomic, retain) IBOutlet UILabel * acknowledgementsContentsLabel;
@property (nonatomic, retain) IBOutlet UILabel * disclaimerLabel;

@end
