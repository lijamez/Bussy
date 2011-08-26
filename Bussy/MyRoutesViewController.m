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

@synthesize addBarButton, refreshBarButton, watchedStopRoutes, imageView, stopRoutesTableView, noRoutesLabel;

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

- (void) save
{
    NSString* watchedStopRoutesSavePath = [self watchedStopRoutesSavePath];
    NSLog(@"Saving to %@...", watchedStopRoutesSavePath);
    
    //Construct serializable array
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
        
        for (StopRoute * stopRoute in [watchedStopRoutes stopRoutesWithStopNumber:stopNumber])
        {
            
            NSMutableDictionary * stopRouteDictionary = [[NSMutableDictionary alloc] init];
            
            [stopRouteDictionary setObject:stopRoute.routeID forKey:@"RouteID"];
            [stopRouteDictionary setObject:stopRoute.direction forKey:@"Direction"];
            [stopRouteDictionary setObject:stopRoute.routeName forKey:@"RouteName"];
            [stopRouteDictionary setObject:stopRoute.times forKey:@"Times"];
            [stopRouteDictionary setObject:[NSNumber numberWithBool:stopRoute.exists] forKey:@"RouteExists"];
            
            [watchedStopRouteDictionaries addObject:stopRouteDictionary];
        }
        
        [stopDictionary setObject:watchedStopRouteDictionaries forKey:@"StopRoutes"];
        
        [watchedStopDictionaries addObject:stopDictionary];
    }
    
    [watchedStopDictionaries writeToFile:watchedStopRoutesSavePath atomically:YES];
    NSLog(@"Saved!");
}

- (void) didReceiveStopRoute: (StopRoute*) newStopRoute
{
    if (![watchedStopRoutes containsStopRoute:newStopRoute])
    {
        [watchedStopRoutes insertStopRoute:newStopRoute];
        [self.stopRoutesTableView reloadData];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ಠ_ಠ" message:@"This route has already been added." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (IBAction) addWatchedStopRoute: (id) sender
{
    AddStopViewController * addStopView = [[[AddStopViewController alloc] init] autorelease];
    addStopView.delegate = self;
    UINavigationController * addStopRouteNavigationController = [[UINavigationController alloc] initWithRootViewController:addStopView];
    addStopRouteNavigationController.navigationBar.tintColor = [TranslinkColors GetTranslinkBlue];
    [self presentModalViewController:addStopRouteNavigationController animated:YES];
}

- (void) refreshWatchedStopRoutes
{    
    if ([watchedStopRoutes countOfAllWatchedStopRoutes] <= 0)
    {
        return;
    }
    
    NSError * error = nil;
    
    [watchedStopRoutes refreshAndCatchError:&error];
    
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    [self.stopRoutesTableView reloadData];

}

- (void) refreshRoutes: (id) sender
{    
    [self showHUDWithSelector:@selector(refreshWatchedStopRoutes) mode:MBProgressHUDModeIndeterminate text:@"Refreshing Routes" DimBackground:NO animated:YES onTarget:self withObject:nil];
}

- (void) refreshRoutesWhenNecessary
{    
    NSTimeInterval greatestTimeInterval = 0;
    
    NSMutableArray * outOfDateStopNumbers = [[NSMutableArray alloc] init];
    
    for (NSString * stopNumber in [watchedStopRoutes stopNumbers])
    {
        Stop * stop = [TranslinkStopManager getStopWithNumber:stopNumber];
        
        NSTimeInterval interval = -[stop.lastRefreshedDate timeIntervalSinceNow];
        
        if (interval > greatestTimeInterval)
            greatestTimeInterval = interval;
        
        if (greatestTimeInterval >= minAgeToRefresh)
        {
            [outOfDateStopNumbers addObject:stopNumber];
        }
    }
    
    NSError * error = nil;

    [watchedStopRoutes refreshStopsWithNumbers:outOfDateStopNumbers andCatchError:&error];
    
    [self.stopRoutesTableView reloadData];
}

- (void) refreshRoutesWhenNecessaryAsync
{
    [[NSThread alloc] initWithTarget:self selector:@selector(refreshRoutesWhenNecessary) object:nil];
    
}

- (void) loadDataFromSave
{    
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
                
                [self didReceiveStopRoute:stopRoute];
            }
            
        }
        
        NSLog(@"Loaded!");
    }
    else
    {
        watchedStopRoutes = [[WatchedStopRoutesCollection alloc] init];
        NSLog(@"Save file not found.");
    }
    
    [self.stopRoutesTableView reloadData];
    
    //Load Settings 
    //TODO Dynamically set these values when a settings view is implemented
    minAgeToRefresh = DEFAULT_MIN_AGE_FOR_AUTO_REFRESH_IN_SECS;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRoutesWhenNecessaryAsync) name:UIApplicationDidBecomeActiveNotification object:nil];
        
    [self setRefreshBarButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshRoutes:)]];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = refreshBarButton;
    
    [self setAddBarButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWatchedStopRoute:)]];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = addBarButton;
    
    self.title = @"My Routes";
    self.navigationController.navigationBar.tintColor = [TranslinkColors GetTranslinkBlue];
    self.navigationController.navigationBar.topItem.leftBarButtonItem.enabled = YES;
    
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
    headerView.headerLabel.text = [NSString stringWithFormat:@"Stop# %@", stop.stopID];
    
    
     NSString * lastRefreshedDateString = @"Never!";
     if (stop.lastRefreshedDate != nil)
     {
         NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init] retain];
         [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
         [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
         lastRefreshedDateString = [dateFormatter stringFromDate: stop.lastRefreshedDate];
         [dateFormatter release];
     }     
    
    headerView.subtitleLabel.text = [NSString stringWithFormat:@"Updated: %@", lastRefreshedDateString];
    
    
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
    }
    else
    {
        noRoutesLabel.hidden = YES;
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
        timesString = @"No service at this time";
    }
    routeTimesLabel.text = timesString;
    
    routeNameLabel.text = [stopRoute displayRouteName];
    
    //Set the background
	UIImage *rowBackground;
	UIImage *selectionBackground;
	NSInteger sectionRows = [tableView numberOfRowsInSection:[indexPath section]];
	NSInteger row = [indexPath row];
	if (row == 0 && row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
	}
	else if (row == 0)
	{
		rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
	}
	else if (row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
	}
	else
	{
		rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
	}
    
	((UIImageView *)cell.backgroundView).image = rowBackground;
	((UIImageView *)cell.selectedBackgroundView).image = selectionBackground; 
    
    // Configure the cell. 
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


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


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AudioServicesPlaySystemSound (clickSoundEffect);

    StopRoute * selectedStopRoute = [watchedStopRoutes stopRouteAtIndex:indexPath.row withStopIndex:indexPath.section];
    
    StopRouteDetailsViewController * detailsViewController = [[[StopRouteDetailsViewController alloc] init] autorelease];
    detailsViewController.stopRoute = selectedStopRoute;
    
    [self.navigationController pushViewController:detailsViewController animated:YES];
    

    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
	*/
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
