//
//  CurrentViewController.h
//  TempLook
//
//  Created by Vitalka on 15.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentWeather.h"

@interface CurrentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *currentTemperature;
@property (weak, nonatomic) IBOutlet UILabel *feelLikeTemperature;
@property (weak, nonatomic) IBOutlet UILabel *sunrize;
@property (weak, nonatomic) IBOutlet UILabel *sunset;
@property (weak, nonatomic) IBOutlet UILabel *windSpeed;
@property (weak, nonatomic) IBOutlet UILabel *descriptionWeather;
@property (weak, nonatomic) IBOutlet UIImageView *iconWeather;
@property (weak, nonatomic) IBOutlet UILabel *localTimeLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) CurrentWeather *currentWeather;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSTimeZone *timeZone;
@property(strong, nonatomic) NSString *locationName;
-(NSString *)foreignTimeZoneDateFormatter:(NSTimeZone *)timeZone forDate:(NSDate *)date;
-(NSString *)temperatureFormatter:(NSString *)temperature;
@end
