//
//  BussyTableHeaderView.h
//  Bussy
//
//  Created by James Li on 11-08-20.
//  Copyright (c) 2011 University of British Columbia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BussyTableHeaderView : UIView {
    
    UILabel * headerLabel;
    UILabel * subtitleLabel;
}

@property (nonatomic, retain) IBOutlet UILabel * headerLabel;
@property (nonatomic, retain) IBOutlet UILabel * subtitleLabel;


@end
