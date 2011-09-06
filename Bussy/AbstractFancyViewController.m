//
//  FancyViewController.m
//  Bussy
//
//  Created by James Li on 11-08-14.
//  Copyright (c) 2011 University of British Columbia. All rights reserved.
//

#import "AbstractFancyViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "BussyConstants.h"

@implementation AbstractFancyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIView*) HUDParentView
{
    //Should be overridden
    return self.view;
}

- (UIImageView*) imageLookupByHUDType: (CompletionHUDType) type
{
    if (type == HUD_TYPE_SUCCESS)
    {
        return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Check.png"]];
    }
    else if (type == HUD_TYPE_ADD)
    {
        return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Plus.png"]];
    }
    else if (type == HUD_TYPE_WARNING)
    {
        return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Exclamation.png"]];
    }
    else if (type == HUD_TYPE_FAILURE)
    {
        return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Cross.png"]];
    }
    
    //Default
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Check.png"]];
}

- (void) showHUDWithSelector: (SEL)method mode:(MBProgressHUDMode) mode text: (NSString*) text DimBackground: (BOOL) dimBackground animated: (BOOL)animated onTarget:(id)target withObject:(id)object 
{
    if (HUD != nil)
    {
        [HUD release];
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [[self HUDParentView] addSubview:HUD];
    HUD.delegate = self;  
    
    HUD.mode = mode;
    HUD.labelText = text;
    HUD.dimBackground = dimBackground;
    [HUD showWhileExecuting:method onTarget:target withObject:object animated:animated];
}

- (void) updateHUDWithText: (NSString*) text
{
    HUD.labelText = text;
}

- (void) updateHUDWithDetailsText:(NSString *)text
{
    HUD.detailsLabelText = text;
}

- (void) updateHUDWithMode: (MBProgressHUDMode) mode text: (NSString*) text detailsText: (NSString*) detailsText
{
    HUD.mode = mode;
    HUD.labelText = text;
    HUD.detailsLabelText = detailsText;
}

- (void) updateHUDWithCompletionMessage: (NSString*) message details: (NSString*) messageDetails type: (CompletionHUDType) type
{
    if (!HUD.taskInProgress) return;
    
    NSString * labelText = message;
    if (labelText == nil)
        labelText = NSLocalizedString(@"HUDMessage_Completed", nil);
    
    HUD.customView = [self imageLookupByHUDType:type];
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = labelText;
    HUD.detailsLabelText = messageDetails;
    sleep(1);
}

-(void) sleepForSecs: (NSNumber*) seconds
{
    sleep(seconds.integerValue);
}

-(void) showHUDWithCompletionMessage: (NSString*) message details: (NSString*) detailsMessage type: (CompletionHUDType) type target: (id) target
{
    if (HUD != nil)
    {
        [HUD release];
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [[self HUDParentView] addSubview:HUD];
    HUD.delegate = self;  
    
    
    if (message != nil)
    {
        HUD.labelText = message;
    }
    
    if (detailsMessage != nil)
    {
        HUD.detailsLabelText = detailsMessage;    
    }
    
    HUD.dimBackground = NO;
    HUD.customView = [self imageLookupByHUDType:type];
    
    HUD.mode = MBProgressHUDModeCustomView;

    
    [HUD showWhileExecuting:@selector(sleepForSecs:) onTarget:target withObject:[NSNumber numberWithInt:2] animated:YES];
}

- (UITableViewCell *) getFancyCellForTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CFURLRef soundFileURLRefClick  = CFBundleCopyResourceURL (CFBundleGetMainBundle (), CFSTR ("click"), CFSTR ("wav"), NULL);
    AudioServicesCreateSystemSoundID (soundFileURLRefClick, &clickSoundEffect);
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

- (void) dealloc
{
    [HUD release];
    AudioServicesDisposeSystemSoundID(clickSoundEffect);
    
    [super dealloc];
}

@end
