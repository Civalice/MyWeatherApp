//
//  ViewController.m
//  MyWeatherApp
//
//  Created by Patanachai Boonchokechaikul on 4/7/2560 BE.
//  Copyright © 2560 Patanachai Boonchokechaikul. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "MyWeatherData.h"
#import "MyWeatherStoreData.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSURLSessionDataTask* dataTask;
@property NSURLSessionDownloadTask *downloadPhotoTask;
@property MyWeatherStoreData* storageData;


@property BOOL isFiltered;

@property NSMutableArray* filterArray;
- (DetailViewController*) GetDetailView;
@end

@implementation ViewController

@synthesize tableView;
@synthesize dataTask;
@synthesize downloadPhotoTask;
@synthesize storageData;
@synthesize isFiltered;

@synthesize filterArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    storageData = [[MyWeatherStoreData alloc]init];
    [storageData load];
    [tableView reloadData];
}

- (NSURLSession*) getDefaultSession {
    NSURLSessionConfiguration* urlConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: urlConfig delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    return defaultSession;
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
                [self pushDetailView:weatherData];
                
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
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.isFiltered)
        return filterArray.count;
    else
        return storageData.keywordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"LocationCell";
    
    UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    if (!isFiltered)
        cell.textLabel.text = [storageData.keywordArray objectAtIndex:indexPath.row];
    else
        cell.textLabel.text = [filterArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tableValue;
    //Value Selected by user
    if (!isFiltered)
        tableValue = [storageData.keywordArray objectAtIndex:indexPath.row];
    else
        tableValue = [filterArray objectAtIndex:indexPath.row];
    
    [self fetchData:tableValue key:[MyWeatherData APIKey] format:@"json"];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    //go to detailPage sending text
    [self fetchData:searchBar.text key:[MyWeatherData APIKey] format:@"json"];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    isFiltered = FALSE;
    [tableView reloadData];
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        filterArray = [[NSMutableArray alloc] init];
        
        for (NSString* location in storageData.keywordArray)
        {
            NSRange nameRange = [location rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
            {
                [filterArray addObject:location];
            }
        }
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) pushDetailView:(MyWeatherData*) data{
    DetailViewController* controller = [self GetDetailView];
    //data save
    [storageData save:data.Query];
    [tableView reloadData];
    [controller setDetailValue:data];
    [self.navigationController pushViewController:controller animated:YES];
}

- (DetailViewController*) GetDetailView {
    return [self.storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
}
@end
