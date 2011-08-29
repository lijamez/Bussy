//
//  StopRouteDetailsViewController.m
//  Bussy
//
//  Created by James Li on 11-07-08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StopRouteDetailsViewController.h"
#import "Stop.h"

@implementation StopRouteDetailsViewController

@synthesize stopRouteNumberLabel, stopRouteNameLabel, stopNumberLabel, directionLabel, timesTableView, lastRefreshedLabel, exportBarButton, noServiceLabel;
@synthesize stopRoute;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Details";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)openInMaps
{
    NSString * translinkUrlString = [NSString stringWithFormat:@"http://m.translink.ca/api/kml/stop/%@/", stopRoute.stop.stopID];
    NSString * mapsAppUrlString = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", translinkUrlString];
    NSURL * url = [NSURL URLWithString:mapsAppUrlString];
    [[UIApplication sharedApplication] openURL:url];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([stopRoute.times count] <= 0)
    {
        noServiceLabel.hidden = NO;
    }
    else
    {
        noServiceLabel.hidden = YES;
    }
        
    return [stopRoute.times count];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 32;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"Arrival Times";
    }
    
    return @"";
    
}

- (void) showActionSheet
{
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select an action" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Show in Maps", nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.parentViewController.tabBarController.view];
    [actionSheet release];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [self openInMaps];
    }
    
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [stopRoute.times objectAtIndex:[indexPath row]];
    
    // Configure the cell. 
    return cell;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setExportBarButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet)]];
    self.navigationItem.rightBarButtonItem = exportBarButton;
    
    stopRouteNumberLabel.text = stopRoute.routeID;
    stopRouteNameLabel.text = [stopRoute displayRouteName];
    stopNumberLabel.text = [NSString stringWithFormat:@"Stop Number: %@", stopRoute.stop.stopID];
    directionLabel.text = [NSString stringWithFormat:@"Direction: %@", stopRoute.direction];
    
    NSString * lastRefreshedString = @"Never";
    if (stopRoute.stop.lastRefreshedDate != nil)
    {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        
        lastRefreshedString = [dateFormatter stringFromDate:stopRoute.stop.lastRefreshedDate];
        [dateFormatter release];
    }
    
    lastRefreshedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", lastRefreshedString];
    
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
