//
//  PageViewController.h
//  TempLook
//
//  Created by Vitalka on 15.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekViewController.h"
#import "DayViewController.h"
#import "CurrentViewController.h"

@interface PageViewController : UIViewController<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
