//
//  AddStopViewController.m
//  Bussy
//
//  Created by James Li on 11-07-03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddStopViewController.h"
#import "MyRoutesViewController.h"
#import "Stop.h"
#import "StopRouteChooserViewController.h"
#import "TranslinkStopManager.h"

@implementation AddStopViewController

@synthesize stopNumberTextField, enterStopNumberLabel, foundStopRoutes;
@synthesize delegate;

int const MAX_FIELD_CHARS = 5;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"ViewTitle_EnterStopNumber", nil);
    }
    return self;
}

//Override
- (UIView*) HUDParentView
{
    return self.navigationController.view;
}


- (void) hudWasHidden
{
    if (foundStopRoutes != nil)
    {
        StopRouteChooserViewController * stopRouteChooserView = [[[StopRouteChooserViewController alloc] init] autorelease];
        stopRouteChooserView.stopRoutes = foundStopRoutes;
        stopRouteChooserView.delegate = self.delegate;
        
        [self.navigationController pushViewController:stopRouteChooserView animated:YES];
        
        self.foundStopRoutes = nil;
    }
    else
    {
        [stopNumberTextField becomeFirstResponder];
    }
}

- (void) processStopNumber: (NSString*) stopNumber
{
    [stopNumberTextField resignFirstResponder];

    NSError * error = nil;
    
    Stop * stop = [TranslinkStopManager getStopWithNumber:stopNumber];
    [stop refreshAndCatchError:&error];
    
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    if ([stopNumber isEqualToString:stop.stopID] && [stop.routes.array count] > 0)
    {
        
        self.foundStopRoutes = [stop routes];

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"DialogMessage_StopNumberNotFound", @"Stop Number Not Found dialog message") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (IBAction) notifyNext: (id) sender
{
    NSString * newStopNumber = [self.stopNumberTextField text];
    
    if ([newStopNumber length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"DialogMessage_MissingStopNumber", @"Please enter a stop number dialog message") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    if ([newStopNumber length] != 5)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"DialogMessage_InsufficientStopNumberDigits", @"A stop number should be 5 digits long.") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    
    [stopNumberTextField resignFirstResponder];

    [self showHUDWithSelector:@selector(processStopNumber:) mode:MBProgressHUDModeIndeterminate text:NSLocalizedString(@"HUDMessage_FetchingRoutes", nil) DimBackground:YES animated:YES onTarget:self withObject:newStopNumber];
    
}


- (IBAction) notifyIsCancelled: (id) sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > MAX_FIELD_CHARS) ? NO : YES;
}


- (void)dealloc
{
    [stopNumberTextField release];
    [super dealloc];
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
    
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(notifyIsCancelled:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem * nextButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(notifyNext:)];
    self.navigationItem.rightBarButtonItem = nextButton;
    
    enterStopNumberLabel.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"AddRoute_EnterStopNumber", nil)];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [stopNumberTextField becomeFirstResponder];
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
