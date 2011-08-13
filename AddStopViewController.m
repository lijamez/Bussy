//
//  AddStopViewController.m
//  Bussy
//
//  Created by James Li on 11-07-03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddStopViewController.h"
#import "RootViewController.h"
#import "Stop.h"
#import "StopRouteChooserViewController.h"

@implementation AddStopViewController

@synthesize stopNumberTextField;
@synthesize delegate;

int const MAX_FIELD_CHARS = 5;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Stop Number";
    }
    return self;
}

- (IBAction) notifyNext: (id) sender
{
    NSString * newStopNumber = [self.stopNumberTextField text];
    
    if ([newStopNumber length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a stop number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    NSError * error = nil;
    
    Stop * stop = [[Stop alloc] initWithAdapter:[[TranslinkAdapter alloc] init] stopId:newStopNumber error:&error];
    
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    if ([newStopNumber isEqualToString:stop.stopID] && [stop.routes.array count] > 0)
    {
        
        StopRouteCollection * stopRoutes = [stop routes];
        StopRouteChooserViewController * stopRouteChooserView = [[[StopRouteChooserViewController alloc] init] autorelease];
        stopRouteChooserView.stopRoutes = stopRoutes;
        stopRouteChooserView.delegate = self.delegate;
        
        [self.navigationController pushViewController:stopRouteChooserView animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Stop number not found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    
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
    [stopNumberTextField becomeFirstResponder];
    
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(notifyIsCancelled:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem * nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(notifyNext:)];
    self.navigationItem.rightBarButtonItem = nextButton;
    
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
