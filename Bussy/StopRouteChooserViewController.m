//
//  StopRouteChooserViewController.m
//  Bussy
//
//  Created by James Li on 11-07-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StopRouteChooserViewController.h"
#import "StopRoute.h"
#import "MyRoutesViewController.h"
#import "StopRouteCollection.h"

@implementation StopRouteChooserViewController

@synthesize stopRouteTableView;
@synthesize stopRoutes;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"ViewTitle_ChooseRoute", nil);
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
    //[tableView reloadData];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [stopRoutes.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    StopRoute * stopRoute = [stopRoutes.array objectAtIndex:indexPath.row];
    cell.textLabel.text = [stopRoute routeName];
    cell.detailTextLabel.text = [stopRoute generateTimesString];
    cell.imageView.image = [UIImage imageNamed:@"37x-Add.png"];
    // Configure the cell.
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didReceiveStopRoute:[stopRoutes.array objectAtIndex:[indexPath row]]];
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)dealloc
{
    [stopRouteTableView release];
    [stopRoutes release];
    [super dealloc];
}

@end
