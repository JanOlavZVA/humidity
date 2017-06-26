//
//  DayViewController.h
//  TempLook
//
//  Created by Vitalka on 15.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayViewController : UIViewController

@property(strong, nonatomic) NSDictionary *hourWeather;
@property(strong, nonatomic) NSArray *sectionTitles;

-(NSString *)formatDate:(NSDate *)date;

-(NSString *)unixTimeStampToNSDate:(NSString *)timeStamp;



@end
