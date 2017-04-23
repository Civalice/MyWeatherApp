//
//  MyWeatherStorageTest.m
//  MyWeatherApp
//
//  Created by Patanachai Boonchokechaikul on 4/24/2560 BE.
//  Copyright © 2560 Patanachai Boonchokechaikul. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MyWeatherStoreData.h"

@interface MyWeatherStorageTest : XCTestCase
@property MyWeatherStoreData* testData;
@end

@implementation MyWeatherStorageTest
@synthesize testData;
- (void)setUp {
    [super setUp];
    testData = [[MyWeatherStoreData alloc]init];
    [testData clear];
}

- (void)tearDown {
    testData = nil;
    [super tearDown];
}

- (void)testDuplicateData {
    [testData save:@"Bangkok"];
    [testData save:@"China"];
    [testData save:@"cnc"];
    [testData save:@"zimb"];
    [testData save:@"Bangkok"];
    
    NSString* firstIdxStr = testData.keywordArray[0];
    if (![firstIdxStr isEqualToString:@"Bangkok"]) {
        XCTFail(@"Duplicated data didn't go to first index.");
    }
    if (testData.keywordArray.count != 4) {
        XCTFail(@"Have duplicated data in storageData.");
    }
}

- (void)testMaximumData {
    [testData save:@"Bangkok"];
    [testData save:@"China"];
    [testData save:@"cnc"];
    [testData save:@"zimb"];
    [testData save:@"Blk"];
    
    [testData save:@"america"];
    [testData save:@"german"];
    [testData save:@"cdc"];
    [testData save:@"western"];
    [testData save:@"laos"];
    
    [testData save:@"korean"];
    [testData save:@"korat"];
    
    if (testData.keywordArray.count > 10) {
        XCTFail(@"Data shouldn't exceed 10.");
    }
}

@end
