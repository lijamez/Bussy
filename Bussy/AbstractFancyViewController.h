//
//  FancyViewController.h
//  Bussy
//
//  Created by James Li on 11-08-14.
//  Copyright (c) 2011 University of British Columbia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MBProgressHUD.h"

typedef enum
{
    HUD_TYPE_SUCCESS,
    HUD_TYPE_WARNING,
    HUD_TYPE_FAILURE
} CompletionHUDType;

@interface AbstractFancyViewController : UIViewController<MBProgressHUDDelegate> {
    
    MBProgressHUD * HUD;
    SystemSoundID clickSoundEffect;

}

- (void) showHUDWithSelector: (SEL)method mode:(MBProgressHUDMode) mode text: (NSString*) text DimBackground: (BOOL) dimBackground animated: (BOOL)animated onTarget:(id)target withObject:(id)object;

- (void) updateHUDWithText: (NSString*) text;
- (void) updateHUDWithDetailsText:(NSString *)text;
- (void) updateHUDWithMode: (MBProgressHUDMode) mode text: (NSString*) text detailsText: (NSString*) detailsText;
- (void) updateHUDWithCompletionMessage: (NSString*) message;
-(void) showHUDWithCompletionMessage: (NSString*) message details: (NSString*) detailsMessage type: (CompletionHUDType) type target: (id) target;

@end
