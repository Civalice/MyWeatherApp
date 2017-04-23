//
//  MyWeatherAppTests.m
//  MyWeatherAppTests
//
//  Created by Patanachai Boonchokechaikul on 4/7/2560 BE.
//  Copyright © 2560 Patanachai Boonchokechaikul. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MyWeatherData.h"

@interface MyWeatherAppTests : XCTestCase
@property NSURLSession* testSession;
@end

@implementation MyWeatherAppTests
@synthesize testSession;

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSURLSessionConfiguration* urlConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    testSession = [NSURLSession sessionWithConfiguration:urlConfig];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    testSession = nil;
    [super tearDown];
}

- (void)testAPI_Bangkok {
    //Test call API and get result
    NSURLSessionDataTask* dataTask;
    NSString* key = [MyWeatherData APIKey];
    NSString* city = @"Bangkok";
    NSString* format = @"json";

    NSString* urlStr = [NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v1/weather.ashx?key=%@&q=%@&fx=yes&format=%@",key,city,format];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //start request data task
    if (dataTask != nil) {
        [dataTask cancel];
        dataTask = nil;
    }

    dataTask = [testSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data.length > 0 && error == nil) {
            MyWeatherData* weatherData = [[MyWeatherData alloc]initWithJSONData:data query:city];
            if (weatherData.Error != nil)
                XCTFail(@"API Error : %@",weatherData.Error);
        }
        else {
            //this is session error
            XCTFail(@"Session Error has occured : %@",error.description);
        }
    }];
    [dataTask resume];
}

- (void)testAPI_wrong_query {
    //Test call API and get result
    NSURLSessionDataTask* dataTask;
    NSString* key = [MyWeatherData APIKey];
    NSString* city = @"Bangkokokokfjo";
    NSString* format = @"json";
    
    NSString* urlStr = [NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v1/weather.ashx?key=%@&q=%@&fx=yes&format=%@",key,city,format];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //start request data task
    if (dataTask != nil) {
        [dataTask cancel];
        dataTask = nil;
    }
    
    dataTask = [testSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data.length > 0 && error == nil) {
            MyWeatherData* weatherData = [[MyWeatherData alloc]initWithJSONData:data query:city];
            if (weatherData.Error == nil)
                XCTFail(@"This test must return error");
        }
        else {
            //this is session error
            XCTFail(@"Session Error has occured : %@",error.description);
        }
    }];
    [dataTask resume];
}

@end
