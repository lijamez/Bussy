//
//  StopRouteDetailsViewController.m
//  Bussy
//
//  Created by James Li on 11-07-08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "StopRouteDetailsViewController.h"
#import "Stop.h"
#import "ActionSheetAction.h"

@implementation StopRouteDetailsViewController

@synthesize stopRouteNumberLabel, stopRouteNameLabel, stopNumberLabel, directionLabel, timesTableView, lastRefreshedLabel, exportBarButton, noServiceLabel;
@synthesize stopRoute;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"ViewTitle_RouteDetails", @"Name of the Details view");
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

- (void) shareViaSMS
{
    MFMessageComposeViewController * messageViewController = [[MFMessageComposeViewController alloc] init];
    
    NSString * messageBody = [NSString stringWithFormat:@"%@: %@\n%@: %@\n%@: %@",
                              NSLocalizedString(@"StopNumber", nil), [stopRoute.stop stopID],
                              NSLocalizedString(@"Route", nil), [stopRoute routeID],
                              NSLocalizedString(@"ArrivalTimes", nil), [stopRoute generateTimesString]];
    
    messageViewController.body = messageBody;
    
    messageViewController.messageComposeDelegate = self;

    [self presentModalViewController:messageViewController animated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    [controller release];
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
        return NSLocalizedString(@"ArrivalTimes" , @"Arrival Times table header");
    }
    
    return @"";
    
}

- (void) initializeActionSheetActions
{
    actionSheetActions = [[NSMutableArray alloc] init];
    
    //Show in Maps
    ActionSheetAction * showInMapsAction = [[ActionSheetAction alloc] initWithActionName:NSLocalizedString(@"ActionSheetButton_ShowInMaps", nil) selector:@selector(openInMaps)];
    [actionSheetActions addObject:showInMapsAction];
    
    //Share via SMS
    if ([MFMessageComposeViewController canSendText])
    {
        ActionSheetAction * sendViaSMSAction = [[ActionSheetAction alloc] initWithActionName:NSLocalizedString(@"ActionSheetButton_ShareViaSMS", nil) selector:@selector(shareViaSMS)];
        [actionSheetActions addObject:sendViaSMSAction];
    }
    
    
}

- (void) showActionSheet
{
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle: NSLocalizedString(@"ActionSheetLabel_SelectAnAction", nil) delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (int i = 0; i < actionSheetActions.count; i++)
    {
        ActionSheetAction * action = [actionSheetActions objectAtIndex:i];
        [actionSheet addButtonWithTitle:action.actionName];
    }
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.parentViewController.tabBarController.view];
    [actionSheet release];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex >= actionSheetActions.count) return;
    
    ActionSheetAction * action = [actionSheetActions objectAtIndex:buttonIndex];
    
    if (action == nil) return;
        
    [self performSelector:action.actionMethod];
    
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
    
    [self setExportBarButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet)]];
    self.navigationItem.rightBarButtonItem = exportBarButton;
    
    noServiceLabel.text = [NSString stringWithFormat:@"%@ :(", NSLocalizedString(@"StopRouteDetails_NoServiceMessage", nil)];
    
    stopRouteNumberLabel.text = stopRoute.routeID;
    stopRouteNameLabel.text = [stopRoute displayRouteName];
    stopNumberLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"StopNumber", nil), stopRoute.stop.stopID];
    directionLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Direction", nil), stopRoute.direction];
    
    NSString * lastRefreshedString = NSLocalizedString(@"Never", nil);
    if (stopRoute.stop.lastRefreshedDate != nil)
    {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        
        lastRefreshedString = [dateFormatter stringFromDate:stopRoute.stop.lastRefreshedDate];
        [dateFormatter release];
    }
    
    lastRefreshedLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"LastUpdated", nil), lastRefreshedString];
    
    [self initializeActionSheetActions];
    
    
    
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
