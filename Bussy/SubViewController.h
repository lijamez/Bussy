//
//  SubViewController.h
//  Bussy
//
//  Created by James Li on 11-07-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SubViewController : UIViewController {
    
    IBOutlet UILabel * label;
    IBOutlet UIButton * button;
    
}

@property (retain, nonatomic) IBOutlet UILabel * label;
@property (retain, nonatomic) IBOutlet UIButton * button;

- (IBAction) OnButtonClick:(id) sender;

@end
