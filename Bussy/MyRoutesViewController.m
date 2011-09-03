//
//  RootViewController.m
//  Bussy
//
//  Created by James Li on 11-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyRoutesViewController.h"
#import "StopRoute.h"
#import "AddStopViewController.h"
#import "StopRouteCollection.h"
#import "Stop.h"
#import "StopRouteDetailsViewController.h"
#import "TranslinkColors.h"
#import "BussyTableHeaderView.h"
#import "BussyConstants.h"
#import "TranslinkStopManager.h"

@implementation MyRoutesViewController

@synthesize addBarButton, refreshBarButton, watchedStopRoutes, imageView, stopRoutesTableView, noRoutesLabel, noRoutesDetailsLabel;

CGFloat const TABLE_VIEW_CELL_HEIGHT = 80;

//Override
- (UIView*) HUDParentView
{
    return self.navigationController.view;
}

- (NSString*) watchedStopRoutesSavePath
{
    NSArray *saveDataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *saveDataFolder = [saveDataPath objectAtIndex:0];
    return [saveDataFolder stringByAppendingFormat:@"/watchedStopRoutes.plist"];
}

- (NSString*) applicationOptionsSavePath
{
    NSArray *saveDataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *saveDataFolder = [saveDataPath objectAtIndex:0];
    return [saveDataFolder stringByAppendingFormat:@"/applicationOptions.plist"];
}

- (void) save
{    
    //Serialize Watched Stops
    NSMutableArray * watchedStopDictionaries = [[[NSMutableArray alloc] init] autorelease];
    
    for (int stopIndex = 0; stopIndex < [watchedStopRoutes countOfStops]; stopIndex++)
    {
        NSString * stopNumber = [[watchedStopRoutes stopNumbers] objectAtIndex:stopIndex];
        Stop * stop = [TranslinkStopManager getStopWithNumber:stopNumber];
        NSMutableDictionary * stopDictionary = [[NSMutableDictionary alloc] init];

        [stopDictionary setObject:stop.stopID forKey:@"StopID"];
        [stopDictionary setObject:stop.lastRefreshedDate forKey:@"LastRefreshedDate"];
        [stopDictionary setObject:[NSNumber numberWithBool:stop.exists] forKey:@"StopExists"];
        
        NSMutableArray * watchedStopRouteDictionaries = [[[NSMutableArray alloc] init] autorelease]; 
        
        NSArray * stopRoutes = [watchedStopRoutes stopRoutesWithStopNumber:stopNumber];
        for (StopRoute * stopRoute in stopRoutes)
        {
            
            NSMutableDictionary * stopRouteDictionary = [[NSMutableDictionary alloc] init];
            
            [stopRouteDictionary setObject:stopRoute.routeID forKey:@"RouteID"];
            [stopRouteDictionary setObject:stopRoute.direction forKey:@"Direction"];
            [stopRouteDictionary setObject:stopRoute.routeName forKey:@"RouteName"];
            [stopRouteDictionary setObject:stopRoute.times forKey:@"Times"];
            [stopRouteDictionary setObject:[NSNumber numberWithBool:stopRoute.exists] forKey:@"RouteExists"];
            
            [watchedStopRouteDictionaries addObject:stopRouteDictionary];
        }
        [stopRoutes release];
        
        [stopDictionary setObject:watchedStopRouteDictionaries forKey:@"StopRoutes"];
        
        [watchedStopDictionaries addObject:stopDictionary];
    }
    
    [watchedStopDictionaries writeToFile:[self watchedStopRoutesSavePath] atomically:YES];
    
    NSLog(@"Serialization of watched stops complete.");
    
    //Serialize Other Options
    NSMutableDictionary * applicationOptions = [[[NSMutableDictionary alloc] init] autorelease];
    [applicationOptions setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"AppVersion"];
    
    [applicationOptions writeToFile:[self applicationOptionsSavePath] atomically:YES];
    
    
    NSLog(@"Serialization of application options complete.");
    
    
    
    NSLog(@"Serialization complete.");
;}

- (void) loadDataFromSave
{    
    //Deserialize watched stops
    NSString *pathToWatchedStopRoutesSaveFile = [self watchedStopRoutesSavePath];
    NSLog(@"Loading watched stops from %@...", pathToWatchedStopRoutesSaveFile);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathToWatchedStopRoutesSaveFile])
    {
        NSArray * watchedStopDictionaries = [[NSArray alloc] initWithContentsOfFile:pathToWatchedStopRoutesSaveFile];
        
        for ( NSDictionary * stopDictionary in watchedStopDictionaries)
        {
            
            NSString * savedStopID = [stopDictionary objectForKey:@"StopID"];
            NSDate * savedLastRefreshedDate = [stopDictionary objectForKey:@"LastRefreshedDate"];
            BOOL savedStopExists = [[stopDictionary objectForKey:@"StopExists"] boolValue];
            NSArray * watchedStopRouteDictionaries = [stopDictionary objectForKey:@"StopRoutes"];
            
            Stop * stop = [TranslinkStopManager getStopWithNumber:savedStopID lastRefreshDate:savedLastRefreshedDate exists:savedStopExists];
            
            for ( NSDictionary * stopRouteDictionary in watchedStopRouteDictionaries)
            {
                NSString * savedRouteID = [stopRouteDictionary objectForKey:@"RouteID"];
                NSString * savedDirection = [stopRouteDictionary objectForKey:@"Direction"];
                NSString * savedRouteName = [stopRouteDictionary objectForKey:@"RouteName"];
                NSArray * savedRouteTimes = [stopRouteDictionary objectForKey:@"Times"];
                BOOL savedExists = [[stopRouteDictionary objectForKey:@"RouteExists"] boolValue];
                
                StopRoute * stopRoute = [[StopRoute alloc] initWithStop:stop direction:savedDirection routeID:savedRouteID routeName:savedRouteName times:savedRouteTimes exists:savedExists];
                
                [stop.routes addStopRoute:stopRoute];
                
                [self insertStopRoute:stopRoute];
            }
            
        }
        
        NSLog(@"Deserialization of watched stops complete.");
    }
    else
    {
        watchedStopRoutes = [[WatchedStopRoutesCollection alloc] init];
        NSLog(@"Watched stops save file not found.");
    }
    
    [self.stopRoutesTableView reloadData];
    
    //Deserialize application options
    NSString * applicationOptionsSaveFilePath = [self applicationOptionsSavePath];
    NSLog(@"Loading application options from %@...", applicationOptionsSaveFilePath);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:applicationOptionsSaveFilePath])
    {
        NSDictionary * applicationOptions = [[NSDictionary alloc] initWithContentsOfFile:applicationOptionsSaveFilePath];
        
        //TODO Just print out the application version for now...
        NSString * applicationVersion = [applicationOptions objectForKey:@"AppVersion"];
        NSLog(@"These save files came from application version %@", applicationVersion);
        
        NSLog(@"Deserialization of application options complete.");
        
    }
    else
    {
        NSLog(@"Application options save file not found.");
    }
    
}

- (void) insertStopRoute: (StopRoute*) stopRoute
{
    if ([watchedStopRoutes containsStopRoute:stopRoute]) return;
    
    [watchedStopRoutes insertStopRoute:stopRoute];
    [self.stopRoutesTableView reloadData];
}

- (void) didReceiveStopRoute: (StopRoute*) newStopRoute
{
    if (![watchedStopRoutes containsStopRoute:newStopRoute])
    {
        [self insertStopRoute:newStopRoute];
        [self showHUDWithCompletionMessage:NSLocalizedString(@"HUDMessage_RouteAdded", @"Route Added HUD Message") details:@"" type: HUD_TYPE_ADD target:self];
    }
    else
    {
        [self showHUDWithCompletionMessage:NSLocalizedString(@"HUDMessage_RouteAlreadyAdded", @"Route Already Added HUD Message") details:@"" type: HUD_TYPE_WARNING target:self];
    }
    
    NSIndexPath * indexPath = [watchedStopRoutes getIndexPathForStopRoute:newStopRoute];
    [self.stopRoutesTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (IBAction) addWatchedStopRoute: (id) sender
{
    AddStopViewController * addStopView = [[[AddStopViewController alloc] init] autorelease];
    addStopView.delegate = self;
    UINavigationController * addStopRouteNavigationController = [[UINavigationController alloc] initWithRootViewController:addStopView];
    addStopRouteNavigationController.navigationBar.tintColor = [TranslinkColors GetTranslinkBlue];
    [self presentModalViewController:addStopRouteNavigationController animated:YES];
;}



-(void) refreshStopsWithNumbers: (NSArray*) outdatedStopNumbers
{
    if ([watchedStopRoutes countOfAllWatchedStopRoutes] <= 0) return;
    if ([watchedStopRoutes isRefreshing]) return;
    
    
    UIBackgroundTaskIdentifier bti = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [watchedStopRoutes requestCancel]; 
    }];
    
    NSError * error = nil;
    
    [watchedStopRoutes refreshStopsWithNumbers:outdatedStopNumbers andCatchError:&error];
    
    [[UIApplication sharedApplication] endBackgroundTask:bti]; 
    
    if (error)
    {        
        NSString * errorMessage = [error localizedDescription];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    [self.stopRoutesTableView reloadData];
}

- (void) refreshWatchedStopRoutes
{    
    [self refreshStopsWithNumbers:[watchedStopRoutes stopNumbers]];
}

- (void) refreshRoutesButtonWasTapped: (id) sender
{    
    if (![watchedStopRoutes isRefreshing] && [watchedStopRoutes countOfStops] > 0)
    {
        [self showHUDWithSelector:@selector(refreshWatchedStopRoutes) mode:MBProgressHUDModeIndeterminate text:NSLocalizedString(@"HUDMessage_RefreshingRoutes", @"Refreshing Routes HUD Message") DimBackground:NO animated:YES onTarget:self withObject:nil];
    }
}

- (NSArray*) getOutdatedStopNumbers
{    
    NSTimeInterval greatestTimeInterval = 0;
    
    NSMutableArray * outOfDateStopNumbers = [[NSMutableArray alloc] init];
    
    for (NSString * stopNumber in [watchedStopRoutes stopNumbers])
    {
        Stop * stop = [TranslinkStopManager getStopWithNumber:stopNumber];
        
        NSTimeInterval interval = -[stop.lastRefreshedDate timeIntervalSinceNow];
        
        if (interval > greatestTimeInterval)
            greatestTimeInterval = interval;
        
        if (greatestTimeInterval >= DEFAULT_MIN_AGE_FOR_AUTO_REFRESH_IN_SECS)
        {
            [outOfDateStopNumbers addObject:stopNumber];
        }
    }
    
    return [[NSArray alloc] initWithArray:outOfDateStopNumbers];
}

- (void) refreshRoutesWhenNecessaryAsync
{
    NSArray * outdatedStopNumbers = [self getOutdatedStopNumbers];

    if (outdatedStopNumbers.count > 0 && ![watchedStopRoutes isRefreshing])
    {
        [self showHUDWithSelector:@selector(refreshStopsWithNumbers:) mode:MBProgressHUDModeIndeterminate text:NSLocalizedString(@"HUDMessage_RefreshingRoutes", nil) DimBackground:NO animated:YES onTarget:self withObject:outdatedStopNumbers];
    }
    
}

-(void) receiveNotificationRefreshStatusUpdate: (NSNotification*) notification
{
    NSDictionary * userInfo = notification.userInfo;
    NSString * message = [NSString stringWithFormat:@"%@/%@", [userInfo objectForKey:REFRESH_NOTIFICATION_USERINFO_CURRENT_COUNT], [userInfo objectForKey:REFRESH_NOTIFICATION_USERINFO_TOTAL_COUNT]];
    
    [self updateHUDWithDetailsText: message];
}

-(void) receiveNotificationRefreshEnded: (NSNotification*) notification
{
    NSDictionary * userInfo = notification.userInfo;
    NSString * reason = [userInfo objectForKey:REFRESH_NOTIFICATION_USERINFO_UPDATE_ENDED_REASON];
    NSString * reasonDetails = [userInfo objectForKey:REFRESH_NOTIFICATION_USERINFO_UPDATE_ENDED_REASON_DETAILS];
    RefreshCompletionResult result = [[userInfo objectForKey:REFRESH_NOTIFICATION_USERINFO_UPDATE_ENDED_RESULT] intValue];
    
    CompletionHUDType hudType = HUD_TYPE_SUCCESS;
    
    if (result == REFRESH_SUCCESS)
    {
        hudType = HUD_TYPE_SUCCESS;
    }
    else if (result == REFRESH_PARTIAL_FAILURE)
    {
        hudType = HUD_TYPE_WARNING;
    }
    else if (result == REFRESH_COMPLETE_FAILURE)
    {
        hudType = HUD_TYPE_FAILURE;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Message_ServiceUnavailable", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    else if (result == REFRESH_CANCELLED)
    {
        hudType = HUD_TYPE_WARNING;
    }
    
    [self updateHUDWithCompletionMessage:reason details:reasonDetails type: hudType];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationRefreshStatusUpdate:) name:REFRESH_NOTIFICATION_UPDATE_NAME object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationRefreshEnded:) name:REFRESH_NOTIFICATION_UPDATE_ENDED_NAME object:nil];
        
    [self setRefreshBarButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshRoutesButtonWasTapped:)]];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = refreshBarButton;
    
    [self setAddBarButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWatchedStopRoute:)]];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = addBarButton;
    
    self.title = NSLocalizedString(@"ViewTitle_MyRoutes", @"My Routes View Title");
    self.navigationController.navigationBar.tintColor = [TranslinkColors GetTranslinkBlue];;
    self.navigationController.navigationBar.topItem.leftBarButtonItem.enabled = YES;
    
    noRoutesLabel.text = NSLocalizedString(@"RoutesList_NoRoutes", nil);
    noRoutesDetailsLabel.text = NSLocalizedString(@"RoutesList_NoRoutesDetails", nil);
    
    watchedStopRoutes = [[WatchedStopRoutesCollection alloc] init];

    [self loadDataFromSave];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Deselects the last selected cell when coming back from another view
    NSIndexPath*	selection = [self.stopRoutesTableView indexPathForSelectedRow];
	if (selection)
		[self.stopRoutesTableView deselectRowAtIndexPath:selection animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (UIView *)tableView: (UITableView *)tableView viewForHeaderInSection: (NSInteger) section
{
    if (section >= [[watchedStopRoutes stopNumbers] count]) return nil;
    
    Stop * stop = [TranslinkStopManager getStopWithNumber:[[watchedStopRoutes stopNumbers] objectAtIndex: section ]];
    
    BussyTableHeaderView * headerView = [[BussyTableHeaderView alloc] init];
    headerView.headerLabel.text = [NSString stringWithFormat:@"%@# %@", NSLocalizedString(@"Stop", @"Bus Stop"), stop.stopID];
    
    
     NSString * lastRefreshedDateString =[NSString stringWithFormat:@"%@!", NSLocalizedString(@"Never", nil)];
     if (stop.lastRefreshedDate != nil)
     {
         NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
         [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
         [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
         lastRefreshedDateString = [dateFormatter stringFromDate: stop.lastRefreshedDate];
         [dateFormatter release];
     }     
    
    headerView.subtitleLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Updated", @"Updated String"), lastRefreshedDateString];
    
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section >= [[watchedStopRoutes stopNumbers] count]) return 0;
    
    return 19;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([watchedStopRoutes countOfStops] <= 0)
    {
        noRoutesLabel.hidden = NO;
        noRoutesDetailsLabel.hidden = NO;
    }
    else
    {
        noRoutesLabel.hidden = YES;
        noRoutesDetailsLabel.hidden = YES;
    }
    
    return [watchedStopRoutes countOfStops];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * stopRoutes = [watchedStopRoutes stopRoutesWithStopIndex:section];
    
    if (stopRoutes == nil) return 0;
    
    return [[watchedStopRoutes stopRoutesWithStopIndex:section] count];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return TABLE_VIEW_CELL_HEIGHT;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    const NSInteger ROUTE_NUMBER_LABEL_TAG = 1001;
    const NSInteger ROUTE_TIMES_LABEL_TAG = 1002;
	const NSInteger ROUTE_NAME_LABEL_TAG = 1003;
    
    UILabel *routeNumberLabel;
    UILabel *routeTimesLabel;
	UILabel *routeNameLabel;
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    
        //Indicator
        UIImage * indicatorImage = [UIImage imageNamed:@"indicator.png"];
        cell.accessoryView = [[[UIImageView alloc]
                               initWithImage:indicatorImage]
                              autorelease];
        
        const CGFloat ROUTE_NUMBER_LABEL_HEIGHT = 26;
        const CGFloat ROUTE_NUMBER_LABEL_WIDTH = 48;
        const CGFloat ROUTE_TIMES_LABEL_HEIGHT = 20;
        const CGFloat ROUTE_NAME_LABEL_HEIGHT = 22;

        
        //Route Number Label
        routeNumberLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     2.0 * cell.indentationWidth,
                     tableView.rowHeight * 0.5 - ROUTE_NUMBER_LABEL_HEIGHT,
                     ROUTE_NUMBER_LABEL_WIDTH,
                     ROUTE_NUMBER_LABEL_HEIGHT)]
         autorelease];
        [cell.contentView addSubview:routeNumberLabel];
        
        routeNumberLabel.tag = ROUTE_NUMBER_LABEL_TAG;
        routeNumberLabel.backgroundColor = [UIColor clearColor];
        routeNumberLabel.textColor = [UIColor whiteColor];
        routeNumberLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]+6];
        routeNumberLabel.shadowColor = [UIColor blackColor];
        
        //Route Times Label
        routeTimesLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     2.0 * cell.indentationWidth + ROUTE_NUMBER_LABEL_WIDTH + cell.indentationWidth,
                     tableView.rowHeight * 0.5 - ROUTE_TIMES_LABEL_HEIGHT,
                     tableView.bounds.size.width - 4.0 * cell.indentationWidth - indicatorImage.size.width - ROUTE_NUMBER_LABEL_WIDTH - cell.indentationWidth,
                     ROUTE_TIMES_LABEL_HEIGHT)]
         autorelease];
        [cell.contentView addSubview:routeTimesLabel];
        
        routeTimesLabel.tag = ROUTE_TIMES_LABEL_TAG;
        routeTimesLabel.backgroundColor = [UIColor clearColor];
        routeTimesLabel.textColor = [UIColor whiteColor];
        //middleLabel.highlightedTextColor = [UIColor blackColor];
        routeTimesLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]-2];
        routeTimesLabel.shadowColor = [UIColor blackColor];
        [routeTimesLabel setAdjustsFontSizeToFitWidth:YES];
        
        //Route Name Label
        routeNameLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     2.0 * cell.indentationWidth,
                     0.5 * (tableView.rowHeight),
                     tableView.bounds.size.width - 4.0 * cell.indentationWidth - indicatorImage.size.width,
                     ROUTE_NAME_LABEL_HEIGHT)]
         autorelease];
        [cell.contentView addSubview:routeNameLabel];
        
        // Bottom Label
        routeNameLabel.tag = ROUTE_NAME_LABEL_TAG;
        routeNameLabel.backgroundColor = [UIColor clearColor];
        routeNameLabel.textColor = [UIColor colorWithRed:213.0/255.0 green:235.0/255.0 blue:253.0/255.0 alpha:1.0];
        //bottomLabel.highlightedTextColor = [UIColor grayColor];
        [routeNameLabel setAdjustsFontSizeToFitWidth:NO];
        routeNameLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]-4];
        routeNameLabel.shadowColor = [UIColor blackColor];
        
        //
		// Create a background image view.
		//
		cell.backgroundView =
        [[[UIImageView alloc] init] autorelease];
		cell.selectedBackgroundView =
        [[[UIImageView alloc] init] autorelease];
    }
    else
    {
        routeNumberLabel = (UILabel *)[cell viewWithTag:ROUTE_NUMBER_LABEL_TAG];
		routeNameLabel = (UILabel *)[cell viewWithTag:ROUTE_NAME_LABEL_TAG];
    }
    
    StopRoute * stopRoute = [watchedStopRoutes stopRouteAtIndex:indexPath.row withStopIndex:indexPath.section];
    
    routeNumberLabel.text = [stopRoute routeID];
    
    NSString * timesString = [stopRoute generateTimesString];
    if (timesString == (id)[NSNull null] || timesString.length == 0 )
    {
        timesString = NSLocalizedString(@"RoutesList_NoServiceAtThisTime", @"There is no service right now.");
    }
    routeTimesLabel.text = timesString;
    
    if ([stopRoute exists])
    {
        routeNameLabel.text = [stopRoute displayRouteName];
    }
    else
    {
        routeNameLabel.text = NSLocalizedString(@"RoutesList_RouteNotInService", nil);
    }
    
    //Set the background
	UIImage *rowBackground;
	UIImage *selectionBackground;
	NSInteger sectionRows = [tableView numberOfRowsInSection:[indexPath section]];
	NSInteger row = [indexPath row];
	if (row == 0 && row == sectionRows - 1)
	{
        //One and only one row
		rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
	}
	else if (row == 0)
	{
        //First Row
		rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
	}
	else if (row == sectionRows - 1)
	{
        //Last Row
		rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
	}
	else
	{
        //Middle Row
		rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
	}
    
	((UIImageView *)cell.backgroundView).image = rowBackground;
	((UIImageView *)cell.selectedBackgroundView).image = selectionBackground; 
    
    // Configure the cell. 
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        NSString * stopNumberOfRemovedItem = [[watchedStopRoutes stopNumbers] objectAtIndex:indexPath.section];
        [stopNumberOfRemovedItem retain];
        [watchedStopRoutes removeStopRouteAtIndex:indexPath.row withStopNumber:stopNumberOfRemovedItem];
        
        [tableView beginUpdates];
        
        //Remove the row only
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if (![[watchedStopRoutes stopNumbers] containsObject:stopNumberOfRemovedItem])
        {
            //Remove the entire section
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            //[tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
        [stopNumberOfRemovedItem release];
        
        [tableView endUpdates];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AudioServicesPlaySystemSound (clickSoundEffect);

    StopRoute * selectedStopRoute = [watchedStopRoutes stopRouteAtIndex:indexPath.row withStopIndex:indexPath.section];
    
    StopRouteDetailsViewController * detailsViewController = [[[StopRouteDetailsViewController alloc] init] autorelease];
    detailsViewController.stopRoute = selectedStopRoute;
    
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

@end
