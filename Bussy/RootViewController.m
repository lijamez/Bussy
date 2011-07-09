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
#import "DSActivityView.h"

@implementation RootViewController

@synthesize addBarButton, refreshBarButton, watchedStopRoutes;

CGFloat const TABLE_VIEW_CELL_HEIGHT = 64;

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
    addStopRouteNavigationController.navigationBar.tintColor = [UIColor blueColor];
    [self presentModalViewController:addStopRouteNavigationController animated:YES];
}

- (IBAction) refreshRoutes: (id) sender
{
    
    [NSThread detachNewThreadSelector:@selector(newActivityViewForView:) toTarget:[DSBezelActivityView class] withObject:self.view];
    
    NSMutableArray * refreshedStopRoutes = [[NSMutableArray alloc] init];
        
    for(StopRoute * oldStopRoute in watchedStopRoutes)
    {
        Stop * stop = oldStopRoute.stop;
        [stop refresh];
            
        for (StopRoute * newStopRoute in stop.routes.array)
        {
                
            if ([newStopRoute.routeID isEqualToString:oldStopRoute.routeID] &&
                [newStopRoute.direction isEqualToString:oldStopRoute.direction])
            {
                [refreshedStopRoutes addObject:newStopRoute];
            }
                
        }
            
    }
    
    [self.tableView reloadData];
    
    [DSBezelActivityView removeViewAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setRefreshBarButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshRoutes:)]];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = refreshBarButton;
    
    [self setAddBarButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWatchedStopRoute:)]];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = addBarButton;
    
    self.title = @"Bussy";
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    self.navigationController.navigationBar.topItem.leftBarButtonItem.enabled = YES;
    
    watchedStopRoutes = [[NSMutableArray alloc] init];
    
    NSString *pathToWatchedStopRoutesSaveFile = [self watchedStopRoutesSavePath];
    NSLog(@"Loading watched stops from %@...", pathToWatchedStopRoutesSaveFile);
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathToWatchedStopRoutesSaveFile])
    {
        NSArray * watchedStopRouteDictionaries = [[NSArray alloc] initWithContentsOfFile:pathToWatchedStopRoutesSaveFile];
        for ( NSDictionary * stopRouteDictionary in watchedStopRouteDictionaries)
        {
            
            NSString * savedStopID = [stopRouteDictionary objectForKey:@"StopID"];
            NSString * savedRouteID = [stopRouteDictionary objectForKey:@"RouteID"];
            NSString * savedDirection = [stopRouteDictionary objectForKey:@"Direction"];
            
            Stop * stop = [[Stop alloc] initWithAdapter: [[TranslinkAdapter alloc] init] stopId: savedStopID];
            StopRouteCollection * stopRoutes = [[StopRouteCollection alloc] initWithAdapter:[[TranslinkAdapter alloc] init] stop:stop];
            
            for (StopRoute * stopRoute in stopRoutes.array)
            {
                if ([[stopRoute routeID] isEqualToString:savedRouteID] &&
                    [[stopRoute direction] isEqualToString:savedDirection])
                {
                    [self didReceiveStopRoute:stopRoute];
                    break;
                }
                     
            }
            
        }
        NSLog(@"Loaded!");
    }
    else
    {
        watchedStopRoutes = [[NSMutableArray alloc] init];
        NSLog(@"Save file not found.");
    }
    
    [self.tableView reloadData];
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
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
        
    StopRoute * stopRoute = [watchedStopRoutes objectAtIndex:indexPath.row];
    cell.textLabel.text = [stopRoute routeName];
    cell.detailTextLabel.numberOfLines = 2;
    
    NSString * stopNumberLine = [NSString stringWithFormat:@"Stop Number: %@", [[stopRoute stop] stopID]];
    NSString * routeTimesLine = [stopRoute generateTimesString];
    
    NSString * details = [NSString stringWithFormat:@"%@\n%@", stopNumberLine, routeTimesLine];
    cell.detailTextLabel.text = details;

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
