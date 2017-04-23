//
//  MyWeatherData.m
//  MyWeatherApp
//
//  Created by Patanachai Boonchokechaikul on 4/21/2560 BE.
//  Copyright © 2560 Patanachai Boonchokechaikul. All rights reserved.
//

#import "MyWeatherData.h"


@implementation MyWeatherData

@synthesize Error;
@synthesize Query;
@synthesize IconUrl;
@synthesize City;
@synthesize ObservationTime;
@synthesize Humidity;
@synthesize Desc;


+(NSString*) APIKey
{
    return @"vzkjnx2j5f88vyn5dhvvqkzc";
}

-(MyWeatherData*) initWithJSONData:(NSData*) jsonData query:(NSString*) str{
    self.Query = str;
    NSDictionary *weatherData = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    if (weatherData == nil)
    {
        Error = @"Cannot get data from server.";
        return self;
    }
    NSLog(@"%@",weatherData.description);
    NSMutableDictionary* data = [weatherData valueForKey:@"data"];
    //check if data is error
    if ([data valueForKey:@"error"]!=nil) {
        //data is error
        Error = [[data valueForKeyPath:@"error"][0] objectForKey:@"msg"];
    }
    else {
        //parse data
        City = [[data valueForKeyPath:@"request"][0] objectForKey:@"query"];
        IconUrl = [[[data valueForKeyPath:@"current_condition"][0]
                   valueForKeyPath:@"weatherIconUrl"][0]
                   objectForKey:@"value"];
        ObservationTime = [[data valueForKeyPath:@"current_condition"][0]
                           objectForKey:@"observation_time"];
        Humidity = [[data valueForKeyPath:@"current_condition"][0]
                    objectForKey:@"humidity"];
        Desc = [[[data valueForKeyPath:@"current_condition"][0]
                valueForKeyPath:@"weatherDesc"][0]
                objectForKey:@"value"];
    }
    return self;
}

@end
