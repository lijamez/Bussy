//
//  AboutViewController.m
//  Bussy
//
//  Created by James Li on 11-08-14.
//  Copyright (c) 2011 University of British Columbia. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

@synthesize versionLabel, appNameLabel, copyrightLabel, acknowledgementsLabel, acknowledgementsContentsLabel, disclaimerLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    versionLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Version", nil), [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    acknowledgementsLabel.text = NSLocalizedString(@"About_AcknowledgementsHeader", nil);
    disclaimerLabel.text = NSLocalizedString(@"About_Disclaimer", nil);
    copyrightLabel.text = [NSString stringWithFormat:@"%@ © 2011 James Li", NSLocalizedString(@"Copyright", nil)];
    
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

@end
