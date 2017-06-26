//
//  DayViewController.m
//  TempLook
//
//  Created by Vitalka on 15.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import "DayViewController.h"
#import "HourWeather.h"
#import "HourlyViewCell.h"

NSInteger const keyRowDayHeight =120;


@interface DayViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *hourTableView;

@end

@implementation DayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    // Do any additional setup after loading the view.
}
- (void)setHourlyWeather:(NSDictionary *)hourlyWeather {
    _hourWeather = hourlyWeather;
    [_hourTableView reloadData];
}
-(void)setSectionTitles:(NSArray *)sectionTitles{
    _sectionTitles = sectionTitles;
}

#pragma - UITableViewDataSource methods
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sectionTitles[section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *sectionString = self.sectionTitles[section];
    NSArray *array = self.hourWeather[sectionString];
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HourViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HourlyViewCell" forIndexPath:indexPath];
    HourWeather *hour;
    switch (indexPath.section) {
        case 0:
            hour = self.hourWeather[self.sectionTitles[indexPath.section]][indexPath.row];
            cell.temperature.text = [[NSString alloc] initWithFormat:@"%@˚F",hour.temperature];
            cell.time.text = [self unixTimeStampToNSDate:hour.time];
            cell.precipitation.text = [[NSString alloc] initWithFormat:@"Precip:\n %@%%",[self precipitationDouble: hour.precipProbability]];
            cell.weatherIcon.image = [UIImage imageNamed: hour.icon];
            break;
        case 1:
            hour = self.hourWeather[self.sectionTitles[indexPath.section]][indexPath.row];
            cell.temperature.text = [[NSString alloc] initWithFormat:@"%@˚F",hour.temperature];
            cell.time.text = [self unixTimeStampToNSDate:hour.time];
            cell.precipitation.text = [[NSString alloc] initWithFormat:@"Precip:\n %@%%",[self precipitationDouble: hour.precipProbability]];
            cell.weatherIcon.image = [UIImage imageNamed: hour.icon];
            break;
        case 2:
            hour = self.hourWeather[self.sectionTitles[indexPath.section]][indexPath.row];
            cell.temperature.text = [[NSString alloc] initWithFormat:@"%@˚F",hour.temperature];
            cell.time.text = [self unixTimeStampToNSDate:hour.time];
            cell.precipitation.text = [[NSString alloc] initWithFormat:@"Precip:\n   %@%%",[self precipitationDouble: hour.precipProbability]];
            cell.weatherIcon.image = [UIImage imageNamed: hour.icon];
            break;
        default:
            break;
    }
    return cell;
}

-(void)setUpTableView{
    self.hourTableView.dataSource = self;
    UINib *hourlyViewNib = [UINib nibWithNibName:@"HourlyViewCell" bundle:[NSBundle mainBundle]];
    
    [self.hourTableView setEstimatedRowHeight:keyRowDayHeight];
    [self.hourTableView setRowHeight:UITableViewAutomaticDimension];
    [self.hourTableView registerNib:hourlyViewNib forCellReuseIdentifier:@"HourlyViewCell"];
    
}

-(NSDate *)unixTimeStampToDate:(NSString *)timeStamp{
    NSTimeInterval interval = [timeStamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return date;
}
-(NSString *)formatDate:(NSDate *)date{
    if (!date) {
        NSException *exception = [NSException exceptionWithName:@"InvalidException" reason:@"Argument passed was nil." userInfo:nil];
        @throw exception;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, MMM d, yyyy"];
    return [formatter stringFromDate:date];
}

-(NSString *)unixTimeStampToNSDate:(NSString *)timeStamp{
    if (!timeStamp) {
        NSException *exception = [NSException exceptionWithName:@"InvalidException" reason:@"Argument passed was nil" userInfo:nil];
        @throw exception;
    }
    NSTimeInterval _interval=[timeStamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"h a"];
    return [_formatter stringFromDate:date];
}
-(NSString *)precipitationDouble:(NSString *)precipitation{
    return (NSString *)[[NSNumber alloc]initWithDouble:ceil(([precipitation doubleValue] * 100))];
}

@end
