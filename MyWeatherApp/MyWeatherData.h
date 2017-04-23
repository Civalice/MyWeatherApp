//
//  MyWeatherData.h
//  MyWeatherApp
//
//  Created by Patanachai Boonchokechaikul on 4/21/2560 BE.
//  Copyright © 2560 Patanachai Boonchokechaikul. All rights reserved.
//
#ifndef _MYWEATHERDATA_
#define _MYWEATHERDATA_

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyWeatherData : NSObject<NSURLSessionDataDelegate>

+(NSString*) APIKey;
-(MyWeatherData*) initWithJSONData:(NSData*) jsonData query:(NSString*) str;

@property NSString* Error;
@property NSString* Query;
@property NSString* IconUrl;
@property NSString* City;
@property NSString* ObservationTime;
@property NSString* Humidity;
@property NSString* Desc;
@end

#endif
