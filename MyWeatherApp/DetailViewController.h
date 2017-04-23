//
//  DetailViewController.h
//  MyWeatherApp
//
//  Created by Patanachai Boonchokechaikul on 4/21/2560 BE.
//  Copyright © 2560 Patanachai Boonchokechaikul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyWeatherData.h"

@interface DetailViewController : UITableViewController<NSURLSessionDataDelegate>
@property NSString* reqLocation;
@property NSURLSessionDataTask* dataTask;
@property NSURLSessionDownloadTask *downloadPhotoTask;
@property MyWeatherData* mData;

- (void)setDetailValue:(MyWeatherData*) data;

@end
