//
//  DetailViewController.m
//  MyWeatherApp
//
//  Created by Patanachai Boonchokechaikul on 4/21/2560 BE.
//  Copyright © 2560 Patanachai Boonchokechaikul. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *WeatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *LocationTxt;
@property (weak, nonatomic) IBOutlet UILabel *ObserveTimeTxt;
@property (weak, nonatomic) IBOutlet UILabel *HumidityTxt;
@property (weak, nonatomic) IBOutlet UITextView *DescTxt;
- (IBAction)pullToRefresh:(UIRefreshControl *)sender;
@end

@implementation DetailViewController
@synthesize mData;
@synthesize reqLocation;
@synthesize dataTask;
@synthesize downloadPhotoTask;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUIValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void) fetchData:(NSString*)city key:(NSString*)key format:(NSString*)format {
    NSString* urlStr = [NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v1/weather.ashx?key=%@&q=%@&fx=yes&format=%@",key,city,format];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //start request data task
    if (dataTask != nil) {
        [dataTask cancel];
        dataTask = nil;
    }
    dataTask = [[self getDefaultSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data.length > 0 && error == nil) {
            MyWeatherData* weatherData = [[MyWeatherData alloc]initWithJSONData:data query:city];
            if (weatherData.Error == nil) {
                //save persistent data

                [self setDetailValue:weatherData];
                
                dataTask = nil;
            }
            else {
                //show error message and back to screen
                [self showAlertDismiss:weatherData.Error];
            }
        }
        else {
            
        }
    }];
    [self.refreshControl beginRefreshing];
    [dataTask resume];
}

- (void)showAlertDismiss:(NSString*) errorMsg {
    UIAlertController * alert= [UIAlertController
                                alertControllerWithTitle:@"Error"
                                message:errorMsg
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             if (dataTask != nil) {
                                 [dataTask cancel];
                                 dataTask = nil;
                             }
                             if (downloadPhotoTask != nil) {
                                 [downloadPhotoTask cancel];
                                 downloadPhotoTask = nil;
                             }
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             [self.navigationController popViewControllerAnimated:YES];
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setDetailValue:(MyWeatherData*) data{
    mData = data;
    [self setUIValue];

    NSURL* iconUrl = [NSURL URLWithString:data.IconUrl];
    
    self.WeatherIcon.image = nil;
    
    if (downloadPhotoTask != nil) {
        [downloadPhotoTask cancel];
        downloadPhotoTask = nil;
    }
    downloadPhotoTask = [[self getDefaultSession] downloadTaskWithURL:iconUrl
                                                    completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                        UIImage *downloadedImage = [UIImage imageWithData:
                                                                                    [NSData dataWithContentsOfURL:location]];
                                                        self.WeatherIcon.image = downloadedImage;
                                                        [self.refreshControl endRefreshing];
                                                        downloadPhotoTask = nil;
                                                    }];
    [downloadPhotoTask resume];

}

- (void) setUIValue {
    self.reqLocation = mData.Query;
    self.LocationTxt.text = mData.City;
    self.ObserveTimeTxt.text = mData.ObservationTime;
    self.HumidityTxt.text = mData.Humidity;
    self.DescTxt.text = mData.Desc;
}

- (NSURLSession*) getDefaultSession {
    NSURLSessionConfiguration* urlConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: urlConfig delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    return defaultSession;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    NSLog(@"URLSession Complete");
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    //data: response from the server.
    NSLog(@"URLSession Response");
}

- (IBAction)pullToRefresh:(UIRefreshControl *)sender {
        [self fetchData:reqLocation key:[MyWeatherData APIKey] format:@"json"];
        //once all the data has been fetched
        //we should end the refresh animation by
        //calling the endRefreshing Method of UIRefreshControl
}


@end
