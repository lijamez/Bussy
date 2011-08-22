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

@implementation MyRoutesViewController

@synthesize addBarButton, refreshBarButton, watchedStopRoutes, imageView, stopRoutesTableView, noRoutesLabel;

CGFloat const TABLE_VIEW_CELL_HEIGHT = 100;

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
    NSMutableArray * watchedStopRouteDictionaries = [[[NSMutableArray alloc] init] autorelease]; 
    
    for (int stopIndex = 0; stopIndex < [watchedStopRoutes countOfStops]; stopIndex++)
    {
        for (int routeIndex = 0; routeIndex < [watchedStopRoutes countOfRoutesAtStopIndex:stopIndex]; routeIndex++)
        {
            StopRoute * stopRoute = [watchedStopRoutes stopRouteAtIndex:routeIndex withStopIndex:stopIndex];
            
            NSMutableDictionary * stopRouteDictionary = [[NSMutableDictionary alloc] init];
            
            [stopRouteDictionary setObject:stopRoute.stop.stopID forKey:@"StopID"];
            [stopRouteDictionary setObject:stopRoute.routeID forKey:@"RouteID"];
            [stopRouteDictionary setObject:stopRoute.direction forKey:@"Direction"];
            [stopRouteDictionary setObject:stopRoute.routeName forKey:@"RouteName"];
            [stopRouteDictionary setObject:stopRoute.times forKey:@"Times"];
            [stopRouteDictionary setObject:stopRoute.lastRefreshedDate forKey:@"LastRefreshedDate"];
            
            [watchedStopRouteDictionaries addObject:stopRouteDictionary];
        }
    }
    
    [watchedStopRouteDictionaries writeToFile:watchedStopRoutesSavePath atomically:YES];
    NSLog(@"Saved!");
}

- (void) didReceiveStopRoute: (StopRoute*) newStopRoute
{
    if (![watchedStopRoutes containsStopRoute:newStopRoute])
    {
        [watchedStopRoutes insertStopRoute:newStopRoute];
        [self.stopRoutesTableView reloadData];
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
    if ([watchedStopRoutes countOfItems] <= 0)
    {
        return;
    }
    
    WatchedStopRoutesCollection * refreshedStopRoutes = [[WatchedStopRoutesCollection alloc] init];
    NSError * error = nil;
    
    int currentStopCount = 1;
    
    for (NSString * stopNumber in [watchedStopRoutes stopNumbers])
    {
        for (StopRoute * oldStopRoute in [watchedStopRoutes stopRoutesWithStopNumber:stopNumber])
        {
            [self updateHUDWithDetailsText:[NSString stringWithFormat:@"%d of %d", currentStopCount, watchedStopRoutes.countOfItems]];
            
            Stop * stop = oldStopRoute.stop;
            
            [stop refreshAndCatchError:&error];
            
            if (error)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                break;
            }
            
            for (StopRoute * newStopRoute in stop.routes.array)
            {
                
                if ([oldStopRoute isEqual:newStopRoute])
                {
                    [refreshedStopRoutes insertStopRoute:newStopRoute];
                }
                
            }
            
            currentStopCount++;
        }
    }
        
    if (!error)
    {
        [watchedStopRoutes release];
        watchedStopRoutes = refreshedStopRoutes;
        
        [self.stopRoutesTableView reloadData];
    }
}

- (void) refreshRoutes: (id) sender
{    
    [self showHUDWithSelector:@selector(refreshWatchedStopRoutes) mode:MBProgressHUDModeIndeterminate text:@"Refreshing Routes" DimBackground:NO animated:YES onTarget:self withObject:nil];
}

- (void) loadDataFromSave
{    
    NSString *pathToWatchedStopRoutesSaveFile = [self watchedStopRoutesSavePath];
    NSLog(@"Loading watched stops from %@...", pathToWatchedStopRoutesSaveFile);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathToWatchedStopRoutesSaveFile])
    {
        NSArray * watchedStopRouteDictionaries = [[NSArray alloc] initWithContentsOfFile:pathToWatchedStopRoutesSaveFile];
        int currentStopRoute = 1;
        for ( NSDictionary * stopRouteDictionary in watchedStopRouteDictionaries)
        {
            [self updateHUDWithDetailsText:[NSString stringWithFormat:@"%d of %d", currentStopRoute, [watchedStopRouteDictionaries count]]];
            
            NSString * savedStopID = [stopRouteDictionary objectForKey:@"StopID"];
            NSString * savedRouteID = [stopRouteDictionary objectForKey:@"RouteID"];
            NSString * savedDirection = [stopRouteDictionary objectForKey:@"Direction"];
            NSString * savedRouteName = [stopRouteDictionary objectForKey:@"RouteName"];
            NSArray * savedRouteTimes = [stopRouteDictionary objectForKey:@"Times"];
            NSDate * savedLastRefreshedDate = [stopRouteDictionary objectForKey:@"LastRefreshedDate"];
            
            Stop * stop = [[Stop alloc] initWithAdapter: [[TranslinkAdapter alloc] init] stopId: savedStopID];
            
            //StopRouteCollection * stopRoutes = [[StopRouteCollection alloc] initWithAdapter:[[TranslinkAdapter alloc] init] stop:stop];
            
            StopRoute * stopRoute = [[StopRoute alloc] initWithStop:stop direction:savedDirection routeID:savedRouteID routeName:savedRouteName times:savedRouteTimes lastRefreshedDate:savedLastRefreshedDate];
            
            [self didReceiveStopRoute:stopRoute];
            
            currentStopRoute++;
        }
        NSLog(@"Loaded!");
    }
    else
    {
        watchedStopRoutes = [[WatchedStopRoutesCollection alloc] init];
        NSLog(@"Save file not found.");
    }
    
    [self.stopRoutesTableView reloadData];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    [self setRefreshBarButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshRoutes:)]];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = refreshBarButton;
    
    [self setAddBarButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWatchedStopRoute:)]];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = addBarButton;
    
    self.title = @"My Routes";
    self.navigationController.navigationBar.tintColor = [TranslinkColors GetTranslinkBlue];
    self.navigationController.navigationBar.topItem.leftBarButtonItem.enabled = YES;
    
    watchedStopRoutes = [[WatchedStopRoutesCollection alloc] init];
    
    [self showHUDWithSelector:@selector(loadDataFromSave) mode:MBProgressHUDModeIndeterminate text:@"Loading routes" DimBackground:YES animated:YES onTarget:self withObject:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Deselects the last selected cell when coming back from another view
    NSIndexPath*	selection = [self.stopRoutesTableView indexPathForSelectedRow];
	if (selection)
		[self.stopRoutesTableView deselectRowAtIndexPath:selection animated:YES];
    
	[self.stopRoutesTableView reloadData];
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
    
    BussyTableHeaderView * headerView = [[BussyTableHeaderView alloc] init];
    headerView.headerLabel.text =  [NSString stringWithFormat:@"Stop# %@", [[watchedStopRoutes stopNumbers] objectAtIndex:section]];
    
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
    return [watchedStopRoutes countOfStops];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([watchedStopRoutes countOfItems] <= 0)
    {
        noRoutesLabel.hidden = NO;
    }
    else
    {
        noRoutesLabel.hidden = YES;
    }
    
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
    const NSInteger TOP_LABEL_TAG = 1001;
    const NSInteger MIDDLE_LABEL_TAG = 1002;
	const NSInteger BOTTOM_LABEL_TAG = 1003;
    
    UILabel *topLabel;
    UILabel *middleLabel;
	UILabel *bottomLabel;
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    
        //Indicator
        UIImage * indicatorImage = [UIImage imageNamed:@"indicator.png"];
        cell.accessoryView = [[[UIImageView alloc]
                               initWithImage:indicatorImage]
                              autorelease];
        
        const CGFloat TOP_LABEL_HEIGHT = 20;
        const CGFloat MIDDLE_LABEL_HEIGHT = 20;
        const CGFloat BOTTOM_LABEL_HEIGHT = 15;

        
        //Top Label
        topLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     2.0 * cell.indentationWidth,
                     0.5 * (tableView.rowHeight - TOP_LABEL_HEIGHT - MIDDLE_LABEL_HEIGHT - BOTTOM_LABEL_HEIGHT),
                     tableView.bounds.size.width - 4.0 * cell.indentationWidth - indicatorImage.size.width,
                     TOP_LABEL_HEIGHT)]
         autorelease];
        [cell.contentView addSubview:topLabel];
        
        topLabel.tag = TOP_LABEL_TAG;
        topLabel.backgroundColor = [UIColor clearColor];
        topLabel.textColor = [UIColor whiteColor];
        //topLabel.highlightedTextColor = [UIColor blackColor];
        topLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize] - 2];
        
        //Middle Label
        middleLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     2.0 * cell.indentationWidth,
                     0.5 * (tableView.rowHeight - TOP_LABEL_HEIGHT - MIDDLE_LABEL_HEIGHT - BOTTOM_LABEL_HEIGHT) + TOP_LABEL_HEIGHT,
                     tableView.bounds.size.width - 4.0 * cell.indentationWidth - indicatorImage.size.width,
                     MIDDLE_LABEL_HEIGHT)]
         autorelease];
        [cell.contentView addSubview:middleLabel];
        
        middleLabel.tag = MIDDLE_LABEL_TAG;
        middleLabel.backgroundColor = [UIColor clearColor];
        middleLabel.textColor = [UIColor whiteColor];
        //middleLabel.highlightedTextColor = [UIColor blackColor];
        middleLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 2];
        
        //Bottom Label
        bottomLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     2.0 * cell.indentationWidth,
                     0.5 * (tableView.rowHeight - TOP_LABEL_HEIGHT - MIDDLE_LABEL_HEIGHT - BOTTOM_LABEL_HEIGHT) + TOP_LABEL_HEIGHT + MIDDLE_LABEL_HEIGHT,
                     tableView.bounds.size.width - 4.0 * cell.indentationWidth - indicatorImage.size.width,
                     BOTTOM_LABEL_HEIGHT)]
         autorelease];
        [cell.contentView addSubview:bottomLabel];
        
        // Bottom Label
        bottomLabel.tag = BOTTOM_LABEL_TAG;
        bottomLabel.backgroundColor = [UIColor clearColor];
        bottomLabel.textColor = [UIColor lightGrayColor];
        //bottomLabel.highlightedTextColor = [UIColor grayColor];
        bottomLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 5];
        
        
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
        topLabel = (UILabel *)[cell viewWithTag:TOP_LABEL_TAG];
		bottomLabel = (UILabel *)[cell viewWithTag:BOTTOM_LABEL_TAG];
    }
    
    StopRoute * stopRoute = [watchedStopRoutes stopRouteAtIndex:indexPath.row withStopIndex:indexPath.section];
    
    topLabel.text = [stopRoute routeName];
    
    NSString * timesString = [stopRoute generateTimesString];
    if (timesString == (id)[NSNull null] || timesString.length == 0 )
    {
        timesString = @"No service at this time";
    }
    middleLabel.text = timesString;
    
    NSString * lastRefreshedDateString = @"Never!";
    if (stopRoute.lastRefreshedDate != nil)
    {
        NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        lastRefreshedDateString = [dateFormatter stringFromDate: stopRoute.lastRefreshedDate];
    }
    bottomLabel.text = [NSString stringWithFormat:@"Last updated: %@", lastRefreshedDateString];
    
    /*
    cell.textLabel.text = [stopRoute routeName];
    cell.detailTextLabel.numberOfLines = 2;
    
    NSString * stopNumberLine = [NSString stringWithFormat:@"Stop Number: %@", [[stopRoute stop] stopID]];
    NSString * routeTimesLine = [stopRoute generateTimesString];
    
    NSString * details = [NSString stringWithFormat:@"%@\n%@", stopNumberLine, routeTimesLine];
    cell.detailTextLabel.text = details;
*/
    
    
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
        [watchedStopRoutes removeStopRouteAtIndex:indexPath.row withStopIndex:indexPath.section];
        
        [tableView beginUpdates];
        
        //Remove the row only
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if ([watchedStopRoutes countOfRoutesAtStopIndex:indexPath.section] <= 0)
        {
            //Remove the entire section
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            //[tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
        
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
    [super dealloc];
}

@end
