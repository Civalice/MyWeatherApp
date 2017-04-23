//
//  MyWeatherStoreData.m
//  MyWeatherApp
//
//  Created by Patanachai Boonchokechaikul on 4/24/2560 BE.
//  Copyright © 2560 Patanachai Boonchokechaikul. All rights reserved.
//

#import "MyWeatherStoreData.h"

@implementation MyWeatherStoreData
@synthesize keywordArray;

- (void)load {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* lArray = [userDefaults objectForKey:@"locationList"];
    if (lArray == nil)
        keywordArray = [[NSMutableArray alloc]init];
    else
        keywordArray = [[NSMutableArray alloc]initWithArray:lArray];
}

- (void)save:(NSString*) str {
    //add locationTxt
    NSString* location = str;
    
    if ([keywordArray containsObject:location]) {
        [keywordArray removeObjectAtIndex:[keywordArray indexOfObject:location]];
    }
    
    [keywordArray insertObject:location atIndex:0];
    
    while ([keywordArray count] > 10)
        [keywordArray removeLastObject];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:keywordArray forKey:@"locationList"];
    [userDefaults synchronize];
}

- (void)clear {
    if (keywordArray == nil)
        keywordArray = [[NSMutableArray alloc]init];
    [keywordArray removeAllObjects];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:keywordArray forKey:@"locationList"];
    [userDefaults synchronize];
}
@end
