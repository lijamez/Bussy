//
//  Translink.m
//  Bussy
//
//  Created by James Li on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Translink.h"
#import "SBJson.h"
#import "StopRoute.h"

@implementation Translink

+(NSString*) sendGetRequest:(NSString*) url
{
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    NSError *error;
    NSURLResponse *urlResponse = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *responseString = [NSString stringWithFormat:@"%.*s", [response length], [response bytes]];
    
    NSLog(@"Response: %@", responseString);
    return responseString;
    
}

+(NSString*) requestArrivalTimesAtStop: (NSString*) stopID
{
    NSString * url = [NSString stringWithFormat:@"http://m.translink.ca/api/stops/?s=%@", stopID];
    NSString *response = [self sendGetRequest:url];
    
    return response;
}

+(NSString*) requestRouteSearch: (NSString*) searchString
{
    NSString * url = [NSString stringWithFormat:@"http://m.translink.ca/api/routes/?q=%@", searchString];
    NSString *response = [self sendGetRequest:url];
    
    return response;
}

+(NSString*) requestRouteDirection: (NSString*) routeID
{
    NSString * url = [NSString stringWithFormat:@"http://m.translink.ca/api/directions/?f=json&r=%@", routeID];
    NSString *response = [self sendGetRequest:url];
    
    return response;
}

+(NSString*) requestRouteStops: (NSString*) routeID direction: (NSString*) direction
{
    NSString * url = [NSString stringWithFormat:@"http://m.translink.ca/api/stops/?f=json&r=%@&d=%@", direction, routeID];
    NSString *response = [self sendGetRequest:url];
    
    return response;
}

+(NSString*) requestStop: (NSString*) stopID
{
    NSString * url = [NSString stringWithFormat:@"http://m.translink.ca/api/stops/?q=%@", stopID];
    NSString *response = [self sendGetRequest:url];
    
    return response;
}

+(NSString*) requestStopLocation: (NSString*) stopID
{
    NSString * url = [NSString stringWithFormat:@"http://m.translink.ca/api/kml/stop/%@/", stopID];
    NSString *response = [self sendGetRequest:url];
    
    return response;
}

+(NSString*) requestStopsByLat: (NSString*) latitude longitude: (NSString*) longitude
{
    NSString * url = [NSString stringWithFormat:@"http://m.translink.ca/api/stops/?f=json&lng=%@&lat=%@", longitude, latitude];
    NSString *response = [self sendGetRequest:url];
    
    return response;
}




@end
