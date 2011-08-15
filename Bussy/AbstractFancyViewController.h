//
//  FancyViewController.h
//  Bussy
//
//  Created by James Li on 11-08-14.
//  Copyright (c) 2011 University of British Columbia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface FancyViewController : UIViewController<MBProgressHUDDelegate> {
    
    MBProgressHUD * HUD;

}

- (void) showHUDWithSelector: (SEL)method mode:(MBProgressHUDMode) mode text: (NSString*) text DimBackground: (BOOL) dimBackground animated: (BOOL)animated onTarget:(id)target withObject:(id)object;

- (void) updateHUDWithText: (NSString*) text;

- (void) updateHUDWithMode: (MBProgressHUDMode) mode text: (NSString*) text;

@end
