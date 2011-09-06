//
//  BussyConstants.m
//  Bussy
//
//  Created by James Li on 11-08-22.
//  Copyright (c) 2011 University of British Columbia. All rights reserved.
//

#import "BussyConstants.h"

//Settings
NSUInteger const DEFAULT_MIN_AGE_FOR_AUTO_REFRESH_IN_SECS = 1800; //30 minutes

//View Tags
const NSInteger ROUTE_NUMBER_LABEL_TAG = 1001;
const NSInteger ROUTE_TIMES_LABEL_TAG = 1002;
const NSInteger ROUTE_NAME_LABEL_TAG = 1003;

//Notification Center
NSString * const REFRESH_NOTIFICATION_UPDATE_NAME = @"RefreshNotificationUpdate";
NSString * const REFRESH_NOTIFICATION_USERINFO_CURRENT_COUNT = @"CurrentCount";
NSString * const REFRESH_NOTIFICATION_USERINFO_TOTAL_COUNT = @"TotalCount";

NSString * const REFRESH_NOTIFICATION_UPDATE_ENDED_NAME = @"RefreshNotificationUpdateEnded";
NSString * const REFRESH_NOTIFICATION_USERINFO_UPDATE_ENDED_REASON = @"RefreshNotificationUpdateEndedReason";
NSString * const REFRESH_NOTIFICATION_USERINFO_UPDATE_ENDED_REASON_DETAILS = @"RefreshNotificationUpdateEndedReasonDetails";
NSString * const REFRESH_NOTIFICATION_USERINFO_UPDATE_ENDED_RESULT = @"RefreshNotificationUpdateEndedResult";

