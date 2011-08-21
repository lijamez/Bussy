//
//  BussyTableHeaderView.m
//  Bussy
//
//  Created by James Li on 11-08-20.
//  Copyright (c) 2011 University of British Columbia. All rights reserved.
//

#import "BussyTableHeaderView.h"

@implementation BussyTableHeaderView

@synthesize headerLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"BussyTableHeaderView" owner:self options:nil];
        
        self = [nib objectAtIndex:0];
        
    }
    return self;
}

- (void) dealloc
{
    [headerLabel release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
