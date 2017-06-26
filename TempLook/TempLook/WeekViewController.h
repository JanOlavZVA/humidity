//
//  WeekViewController.h
//  TempLook
//
//  Created by Vitalka on 15.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayWeather.h"

#import "WeekViewCell.h"

@interface WeekViewController : UIViewController

@property(strong, nonatomic)NSArray *dayWeather;

@end
