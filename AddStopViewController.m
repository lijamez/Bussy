//
//  AddStopViewController.m
//  Bussy
//
//  Created by James Li on 11-07-03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddStopViewController.h"
#import "RootViewController.h"
#import "Adapter.h"
#import "Stop.h"

@implementation AddStopViewController

@synthesize doneButton, cancelButton, textField;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction) notifyIsDone: (id) sender
{
    NSString * newStopNumber = [self.textField text];
    
    Adapter * adapter = [[Adapter alloc] init];
    Stop * stop = [adapter getStop:newStopNumber];
    
    if ([newStopNumber isEqualToString:[stop stopID]])
    {
        [delegate didReceiveStop:stop];
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        NSString * alertMessage = [NSString stringWithFormat:@"Stop number '%@' not found.", newStopNumber];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}


- (IBAction) notifyIsCancelled: (id) sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc
{
    [doneButton release];
    [cancelButton release];
    [textField release];
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
    [textField becomeFirstResponder];
    
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
