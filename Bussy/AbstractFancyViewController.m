//
//  FancyViewController.m
//  Bussy
//
//  Created by James Li on 11-08-14.
//  Copyright (c) 2011 University of British Columbia. All rights reserved.
//

#import "AbstractFancyViewController.h"
#import <AudioToolbox/AudioToolbox.h>


@implementation AbstractFancyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIView*) HUDParentView
{
    //Should be overridden
    return self.view;
}

- (void) showHUDWithSelector: (SEL)method mode:(MBProgressHUDMode) mode text: (NSString*) text DimBackground: (BOOL) dimBackground animated: (BOOL)animated onTarget:(id)target withObject:(id)object 
{
    if (HUD != nil)
    {
        [HUD release];
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [[self HUDParentView] addSubview:HUD];
    HUD.delegate = self;  
    
    HUD.mode = mode;
    HUD.labelText = text;
    HUD.dimBackground = dimBackground;
    [HUD showWhileExecuting:method onTarget:target withObject:object animated:animated];
}

- (void) updateHUDWithText: (NSString*) text
{
    HUD.labelText = text;
}

- (void) updateHUDWithDetailsText:(NSString *)text
{
    HUD.detailsLabelText = text;
}

- (void) updateHUDWithMode: (MBProgressHUDMode) mode text: (NSString*) text detailsText: (NSString*) detailsText
{
    HUD.mode = mode;
    HUD.labelText = text;
    HUD.detailsLabelText = detailsText;
}

- (void) updateHUDWithCompletionMessage: (NSString*) message
{
    if (!HUD.taskInProgress) return;
    
    NSString * labelText = message;
     
    if (labelText == nil)
        labelText = NSLocalizedString(@"HUDMessage_Completed", nil);
    
    HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Check.png"]] autorelease];
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = labelText;
    HUD.detailsLabelText = @"";
    sleep(1);
}

-(void) sleepForSecs: (NSNumber*) seconds
{
    sleep(seconds.integerValue);
}

-(void) showHUDWithCompletionMessage: (NSString*) message details: (NSString*) detailsMessage type: (CompletionHUDType) type target: (id) target
{
    if (HUD != nil)
    {
        [HUD release];
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [[self HUDParentView] addSubview:HUD];
    HUD.delegate = self;  
    
    
    if (message != nil)
    {
        HUD.labelText = message;
    }
    
    if (detailsMessage != nil)
    {
        HUD.detailsLabelText = detailsMessage;    
    }
    
    HUD.dimBackground = NO;
    
    if (type == HUD_TYPE_SUCCESS)
    {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Check.png"]];
    }
    else if (type == HUD_TYPE_WARNING)
    {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Exclamation.png"]];
    }
    else if (type == HUD_TYPE_FAILURE)
    {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Cross.png"]];
    }
    
    HUD.mode = MBProgressHUDModeCustomView;

    
    [HUD showWhileExecuting:@selector(sleepForSecs:) onTarget:target withObject:[NSNumber numberWithInt:2] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CFURLRef soundFileURLRefClick  = CFBundleCopyResourceURL (CFBundleGetMainBundle (), CFSTR ("click"), CFSTR ("wav"), NULL);
    AudioServicesCreateSystemSoundID (soundFileURLRefClick, &clickSoundEffect);
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc
{
    [HUD release];
    AudioServicesDisposeSystemSoundID(clickSoundEffect);
    
    [super dealloc];
}

@end
