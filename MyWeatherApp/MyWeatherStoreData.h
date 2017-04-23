//
//  MyWeatherStoreData.h
//  MyWeatherApp
//
//  Created by Patanachai Boonchokechaikul on 4/24/2560 BE.
//  Copyright © 2560 Patanachai Boonchokechaikul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyWeatherStoreData : NSObject
- (void)load;
- (void)save:(NSString*) str;
- (void)clear;
@property NSMutableArray* keywordArray;

@end
