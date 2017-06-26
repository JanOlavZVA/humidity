//
//  CurrentViewController.m
//  TempLook
//
//  Created by Vitalka on 15.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import "CurrentViewController.h"
#import "DayWeather.h"
#import "WeekViewController.h"

@interface CurrentViewController ()

@end

@implementation CurrentViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.activityIndicator startAnimating];
    [self setupInitialLayout];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setUpCurrentWeatherViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
   
}

-(void)updateTimer{
    self.localTimeLabel.text = [[NSString alloc]initWithFormat:@"Local Time: %@",[self foreignTimeZoneDateFormatter:self.timeZone forDate:[NSDate date]]];
}
- (void)setupInitialLayout {
    self.currentTemperature.text = @"";
    self.feelLikeTemperature.text = @"";
    self.iconWeather.image = nil;
    self.localTimeLabel.text = @"";
    self.sunrize.text = @"";
    self.sunset.text = @"";
    self.windSpeed.text =@"";
    self.descriptionWeather.text =@"";
}

- (void)setCurrentWeather:(CurrentWeather *)currentWeather {
    _currentWeather = currentWeather;
    if (_currentWeather) {
        [self setUpCurrentWeatherViewController];
    }
}

-(void)setUpCurrentWeatherViewController{
    if (self.currentWeather == nil) {
        return;
    }
    self.currentTemperature.text = [[NSString alloc] initWithFormat:@"%@˚F",[[self currentWeather] temperature]];
    self.feelLikeTemperature.text = [[NSString alloc] initWithFormat:@"Feels Like %@˚F",[[self currentWeather] feelsLikeTemp]];
   
    self.iconWeather.image = [UIImage imageNamed:[[self currentWeather] icon]];
    self.descriptionWeather.text =[[NSString alloc] initWithFormat:@"%@",[[self currentWeather] summary]];
    
    if (!self.timeZone) {
        self.timeZone = [NSTimeZone defaultTimeZone];
    }
    self.localTimeLabel.text = [[NSString alloc]initWithFormat:@"Local Time: %@",[self foreignTimeZoneDateFormatter:self.timeZone forDate:[NSDate date]]];
  
    
    WeekViewController *weekVC = [[WeekViewController alloc] init];
    DayWeather *dailyForecast = weekVC.dayWeather.firstObject;
   
    self.sunrize.text = [[NSString alloc] initWithFormat:@"Sunrize: %@",[self foreignTimeZoneDateFormatter:self.timeZone forDate: [self unixTimeStampToDate:dailyForecast.sunrise]]];
    self.sunset.text = [[NSString alloc] initWithFormat:@"Sunset: %@",[self foreignTimeZoneDateFormatter:self.timeZone forDate: [self unixTimeStampToDate:dailyForecast.sunset]]];;
    
    self.windSpeed.text = [NSString stringWithFormat:@"Wind Speed: %.02f m/s", [self.currentWeather.windSpeed floatValue] ];
    [self.activityIndicator stopAnimating];
    
}

-(NSString *)foreignTimeZoneDateFormatter:(NSTimeZone *)timeZone forDate:(NSDate *)date{
    NSTimeZone *tZone = [[NSTimeZone alloc]init];
    tZone = timeZone;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:tZone];
    [formatter setDateFormat:@"h:mm a"];
    return [formatter stringFromDate:date];
}

-(NSString *)temperatureFormatter:(NSString *)temperature{
    return [[NSString alloc] initWithFormat:@"%.0f", [temperature doubleValue]];
}

-(NSDate *)unixTimeStampToDate:(NSString *)timeStamp{
    NSTimeInterval interval = [timeStamp doubleValue];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return date;
}



@end
