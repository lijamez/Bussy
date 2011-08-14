//
//  RootViewController.m
//  Bussy
//
//  Created by James Li on 11-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "StopRoute.h"
#import "AddStopViewController.h"
#import "StopRouteCollection.h"
#import "Stop.h"
#import "StopRouteDetailsViewController.h"
#import "TranslinkColors.h"

@implementation RootViewController

@synthesize addBarButton, refreshBarButton, watchedStopRoutes, imageView, tableView;

CGFloat const TABLE_VIEW_CELL_HEIGHT = 100;

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
    
    for (StopRoute * stopRoute in watchedStopRoutes)
    {
        NSMutableDictionary * stopRouteDictionary = [[NSMutableDictionary alloc] init];
        
        [stopRouteDictionary setObject:stopRoute.stop.stopID forKey:@"StopID"];
        [stopRouteDictionary setObject:stopRoute.routeID forKey:@"RouteID"];
        [stopRouteDictionary setObject:stopRoute.direction forKey:@"Direction"];
        
        [watchedStopRouteDictionaries addObject:stopRouteDictionary];
    }
    
    [watchedStopRouteDictionaries writeToFile:watchedStopRoutesSavePath atomically:YES];
    NSLog(@"Saved!");
}

- (void) didReceiveStopRoute: (StopRoute*) newStopRoute
{
    if (![watchedStopRoutes containsObject:newStopRoute])
    {
        [watchedStopRoutes addObject:newStopRoute];
        [self.tableView reloadData];
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

- (void) showActivityView
{
    UIBarButtonItem * leftNavButton = self.navigationController.navigationItem.leftBarButtonItem;
    UIBarButtonItem * rightNavButton = self.navigationController.navigationItem.rightBarButtonItem;
    
    leftNavButton.enabled = NO;
    rightNavButton.enabled = NO;
}

- (void) removeActivityView
{
    
    UIBarButtonItem * leftNavButton = self.navigationController.navigationItem.leftBarButtonItem;
    UIBarButtonItem * rightNavButton = self.navigationController.navigationItem.rightBarButtonItem;
    
    leftNavButton.enabled = YES;
    rightNavButton.enabled = YES;
}

- (void) refreshWatchedStopRoutes
{
    if ([watchedStopRoutes count] <= 0)
    {
        return;
    }
    
    NSMutableArray * refreshedStopRoutes = [[NSMutableArray alloc] init];
    NSError * error = nil;
    
    for(StopRoute * oldStopRoute in watchedStopRoutes)
    {
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
                [refreshedStopRoutes addObject:newStopRoute];
            }
            
        }
        
    }
    
    if (!error)
    {
        [watchedStopRoutes release];
        watchedStopRoutes = refreshedStopRoutes;
        
        [self.tableView reloadData];
    }
}

- (IBAction) refreshRoutes: (id) sender
{
    [self showActivityView];
    
    [self refreshWatchedStopRoutes];

    [self removeActivityView];
}

- (void) loadDataFromSave
{
    [self showActivityView];
    
    NSString *pathToWatchedStopRoutesSaveFile = [self watchedStopRoutesSavePath];
    NSLog(@"Loading watched stops from %@...", pathToWatchedStopRoutesSaveFile);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathToWatchedStopRoutesSaveFile])
    {
        NSArray * watchedStopRouteDictionaries = [[NSArray alloc] initWithContentsOfFile:pathToWatchedStopRoutesSaveFile];
        int currentStopRoute = 1;
        for ( NSDictionary * stopRouteDictionary in watchedStopRouteDictionaries)
        {
            NSString * activityString = [NSString stringWithFormat:@"Loading stop %d of %d", currentStopRoute, [watchedStopRouteDictionaries count]];
            NSLog(@"%@", activityString);
            
            NSString * savedStopID = [stopRouteDictionary objectForKey:@"StopID"];
            NSString * savedRouteID = [stopRouteDictionary objectForKey:@"RouteID"];
            NSString * savedDirection = [stopRouteDictionary objectForKey:@"Direction"];
            
            NSError * httpGetStopError = nil;
            
            Stop * stop = [[Stop alloc] initWithAdapter: [[TranslinkAdapter alloc] init] stopId: savedStopID error:&httpGetStopError];
            
            if (httpGetStopError)
            {
                NSLog(@"%@: %@", @"Failed to GET stop", httpGetStopError );
                continue;
            }
            
            NSError * httpGetStopRoutesError = nil;
            
            StopRouteCollection * stopRoutes = [[StopRouteCollection alloc] initWithAdapter:[[TranslinkAdapter alloc] init] stop:stop error:&httpGetStopRoutesError];
            
            if (httpGetStopRoutesError)
            {
                NSLog(@"%@: %@", @"Failed to GET stop routes", httpGetStopRoutesError );
                continue;
            }
            
            for (StopRoute * stopRoute in stopRoutes.array)
            {
                if ([[stopRoute routeID] isEqualToString:savedRouteID] &&
                    [[stopRoute direction] isEqualToString:savedDirection])
                {
                    [self didReceiveStopRoute:stopRoute];
                    break;
                }
                
            }
            currentStopRoute++;
        }
        NSLog(@"Loaded!");
    }
    else
    {
        watchedStopRoutes = [[NSMutableArray alloc] init];
        NSLog(@"Save file not found.");
    }
    
    [self.tableView reloadData];

    [self removeActivityView];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    [self setRefreshBarButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshRoutes:)]];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = refreshBarButton;
    
    [self setAddBarButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWatchedStopRoute:)]];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = addBarButton;
    
    self.title = @"Bussy";
    self.navigationController.navigationBar.tintColor = [TranslinkColors GetTranslinkBlue];
    self.navigationController.navigationBar.topItem.leftBarButtonItem.enabled = YES;
    
    watchedStopRoutes = [[NSMutableArray alloc] init];

    [NSThread detachNewThreadSelector:@selector(loadDataFromSave) toTarget:self withObject:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [watchedStopRoutes count];
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
        
        const CGFloat LABEL_HEIGHT = 20;
        
        //Top Label
        topLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     2.0 * cell.indentationWidth,
                     0.5 * (tableView.rowHeight - 2 * LABEL_HEIGHT),
                     tableView.bounds.size.width - 4.0 * cell.indentationWidth - indicatorImage.size.width,
                     LABEL_HEIGHT)]
         autorelease];
        [cell.contentView addSubview:topLabel];
        
        topLabel.tag = TOP_LABEL_TAG;
        topLabel.backgroundColor = [UIColor clearColor];
        topLabel.textColor = [UIColor whiteColor];
        topLabel.highlightedTextColor = [UIColor blackColor];
        topLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        
        
        //Bottom Label
        bottomLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     2.0 * cell.indentationWidth,
                     0.5 * (tableView.rowHeight - 2 * LABEL_HEIGHT) + LABEL_HEIGHT,
                     tableView.bounds.size.width - 4.0 * cell.indentationWidth - indicatorImage.size.width,
                     LABEL_HEIGHT)]
         autorelease];
        [cell.contentView addSubview:bottomLabel];
        
        // Bottom Label
        bottomLabel.tag = BOTTOM_LABEL_TAG;
        bottomLabel.backgroundColor = [UIColor clearColor];
        bottomLabel.textColor = [UIColor whiteColor];
        bottomLabel.highlightedTextColor = [UIColor blackColor];
        bottomLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 2];
        
        
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
    
    StopRoute * stopRoute = [watchedStopRoutes objectAtIndex:indexPath.row];
    
    topLabel.text = [stopRoute routeName];
    bottomLabel.text = [stopRoute generateTimesString];
    
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
        [watchedStopRoutes removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    StopRoute * selectedStopRoute = [watchedStopRoutes objectAtIndex:[indexPath row]];
    
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

- (void)dealloc
{
    [super dealloc];
}

@end
