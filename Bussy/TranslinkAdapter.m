//
//  Translink.m
//  Bussy
//
//  Created by James Li on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TranslinkAdapter.h"
#import "SBJson.h"
#import "StopRoute.h"

@implementation TranslinkAdapter

-(NSString*) sendGetRequest:(NSString*) url error: (NSError**) error
{
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    NSURLResponse *urlResponse = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:error];
    
    
    NSString *responseString = [NSString stringWithFormat:@"%.*s", [response length], [response bytes]];
    
    NSLog(@"Response: %@", responseString);
    return responseString;
    
}

-(NSString*) requestArrivalTimesAtStop: (NSString*) stopID error: (NSError**) error
{
    NSString * url = [NSString stringWithFormat:@"http://m.translink.ca/api/stops/?s=%@", stopID];
    NSString *response = [self sendGetRequest:url error:error];
    
    return response;
}

-(NSString*) requestRouteSearch: (NSString*) searchString error: (NSError**) error
{
    NSString * url = [NSString stringWithFormat:@"http://m.translink.ca/api/routes/?q=%@", searchString];
    NSString *response = [self sendGetRequest:url error:error];
    
    return response;
}

-(NSString*) requestRouteDirection: (NSString*) routeID error: (NSError**) error
{
    NSString * url = [NSString stringWithFormat:@"http://m.translink.ca/api/directions/?f=json&r=%@", routeID];
    NSString *response = [self sendGetRequest:url error:error];
    
    return response;
}

-(NSString*) requestRouteStops: (NSString*) routeID direction: (NSString*) direction error: (NSError**) error
{
    NSString * url = [NSString stringWithFormat:@"http://m.translink.ca/api/stops/?f=json&r=%@&d=%@", direction, routeID];
    NSString *response = [self sendGetRequest:url error:error];
    
    return response;
}

-(NSString*) requestStop: (NSString*) stopID error: (NSError**) error
{
    NSString * url = [NSString stringWithFormat:@"http://m.translink.ca/api/stops/?q=%@", stopID];
    NSString *response = [self sendGetRequest:url error:error];
    
    return response;
}

-(NSString*) requestStopLocation: (NSString*) stopID error: (NSError**) error
{
    NSString * url = [NSString stringWithFormat:@"http://m.translink.ca/api/kml/stop/%@/", stopID];
    NSString *response = [self sendGetRequest:url error:error];
    
    return response;
}

-(NSString*) requestStopsByLat: (NSString*) latitude longitude: (NSString*) longitude error: (NSError**) error
{
    NSString * url = [NSString stringWithFormat:@"http://m.translink.ca/api/stops/?f=json&lng=%@&lat=%@", longitude, latitude];
    NSString *response = [self sendGetRequest:url error:error];
    
    return response;
}




@end
