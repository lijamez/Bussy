//
//  FancyViewController.m
//  Bussy
//
//  Created by James Li on 11-08-14.
//  Copyright (c) 2011 University of British Columbia. All rights reserved.
//

#import "AbstractFancyViewController.h"

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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

@end
