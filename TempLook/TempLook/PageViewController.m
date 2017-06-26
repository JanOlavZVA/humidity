
//  PageViewController.m
//  TempLook
//
//  Created by Vitalka on 15.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import "PageViewController.h"
#import "CurrentViewController.h"
#import "DayViewController.h"
#import "WeekViewController.h"
#import "HelperForLocation.h"
#import "Location.h"
#import "DayWeather.h"
#import "HourWeather.h"
#import "ForecastModel.h"
#import "MyLocationsTableViewController.h"

@interface PageViewController () <HelperLocationDelegate, WeatherForecastDelegate>{
    
    NSArray *pages;
}


@property (retain, nonatomic) NSArray *pages;
@property (strong, nonatomic) UIPageViewController *pageController;
@property(strong, nonatomic)Location *currentLocation;
@property(strong, nonatomic)DayViewController *hourViewController;
@property(strong, nonatomic)WeekViewController *weekViewController;
@property(strong, nonatomic)CurrentViewController *currentViewController;
@property(strong, nonatomic)MyLocationsTableViewController *myLocationTableViewController;

@end

@implementation PageViewController

@synthesize pages = _pages;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentLocation = [[Location alloc] init];
    self.currentLocation.locationTimeZone = [[NSTimeZone alloc] init];
    [HelperForLocation shared].delegate = self;
    
    self.currentLocation.weatherForecast = [[WeatherForecast alloc] init];
    self.currentLocation.weatherForecast.delegate = self;
    self.currentViewController = [[CurrentViewController alloc] init];
    self.hourViewController =[[DayViewController alloc] init];
    self.weekViewController =[[WeekViewController alloc] init];
    
    _currentViewController= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"currentViewController"];
    _hourViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"dayViewController"];
    _weekViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"weekViewController"];
    self.pages = [[NSArray alloc] initWithObjects:self.currentViewController, self.hourViewController, self.weekViewController, nil];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [self.pageController setDelegate:self];
    [self.pageController setDataSource:self];
    
    [[self.pageController view] setFrame:[[self view] bounds]];
    NSArray *viewControllers = [NSArray arrayWithObject:[self.pages objectAtIndex:0]];
    [self.pageControl setCurrentPage:0];
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    
    [self.view addSubview:self.pageControl];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
    [self.view sendSubviewToBack:[self.pageController view]];
    
   
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger currentIndex = [self.pages indexOfObject:viewController];
    [self.pageControl setCurrentPage:self.pageControl.currentPage+1];
    
    if ( currentIndex < [self.pages count]-1) {
        return [self.pages objectAtIndex:currentIndex+1];
    } else {
        return nil;
    }
}




- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger currentIndex = [self.pages indexOfObject:viewController];
    [self.pageControl setCurrentPage:self.pageControl.currentPage-1];
    if ( currentIndex > 0) {
        return [self.pages objectAtIndex:currentIndex-1];
        
    } else {
        return nil;
    }
}

- (void)changePage:(id)sender {
    
    UIViewController *visibleViewController = self.pageController.viewControllers[0];
    NSUInteger currentIndex = [self.pages indexOfObject:visibleViewController];
    
    NSArray *viewControllers = [NSArray arrayWithObject:[self.pages objectAtIndex:self.pageControl.currentPage]];
    
    if (self.pageControl.currentPage > currentIndex) {
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    } else {
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
        
    }
}
#pragma - HelperLocationDelegate

-(void)didGetLocation:(CLLocation *)location{
    self.currentLocation.location = location;
}

-(void)locationHelperDidFindLocationName:(NSString *)locationName{
    self.currentLocation.locationName = locationName;
    NSLog(@"Location: %@",self.currentLocation.locationName);
    self.currentViewController.locationName = locationName;
    self.navigationItem.title = self.currentLocation.locationName;
}

- (void)locationHelperDidGetTimeZone:(NSTimeZone *)timeZone{
    self.currentLocation.locationTimeZone = timeZone;
}

- (void)locationHelperUserDidDeny {
    [self showAlertControllerWithTitle:@"Application requires location."
                               message:@"Go to 'Settings' to change the permissions."
                         okActionTitle:@"Settings" okHandler:^() {
                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                         } cancelActionTitle:@"Cancel"];
    
}

-(void)locationHelperDidFailWithError:(NSError *)error {
    if (error) {
        [self showAlertControllerWithTitle:@"Can't get the weather data" message:@"Sorry! We're unable to fetch data from server. Please try again later!" okActionTitle:@"OK" okHandler:^() {
            [self.currentViewController.activityIndicator stopAnimating];
        } cancelActionTitle: nil];
    }
}

- (void)showAlertControllerWithTitle:(NSString *)title
                             message:(NSString *)message
                       okActionTitle:(NSString *)okayTitle
                           okHandler:(void (^ __nullable)())okayHandler
                   cancelActionTitle:(nullable NSString *)cancelTitle {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:okayTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (okayHandler) {
            okayHandler();
        }
    }];
    [alertController addAction:okayAction];
    
    if (cancelTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma - WeatherForecastDelegate method

-(void)currentWeatherForLocation:(id)weather{
    WeatherForecast *forecast = (WeatherForecast *)weather;
    self.currentLocation.weatherForecast = forecast;
    
    NSMutableDictionary *hourDictionary = [[NSMutableDictionary alloc] init];
    NSMutableArray *hourKeys = [[NSMutableArray alloc] init];
    for (HourWeather *hourWeather in forecast.hourlyForecasts) {
        NSString *hourlyWeatherTime = [self unixTimeStampToDate:hourWeather.time];
        
        if (![[hourDictionary allKeys] containsObject:hourlyWeatherTime]) {
            hourDictionary[hourlyWeatherTime] = [[NSMutableArray alloc] init];
            [hourKeys addObject:hourlyWeatherTime];
        }
        [hourDictionary[hourlyWeatherTime] addObject:hourWeather];
    }
    
    self.hourViewController.sectionTitles = hourKeys;
    self.hourViewController.hourWeather = hourDictionary;
    self.weekViewController.dayWeather = forecast.dailyForecasts;
    
    self.currentViewController.timeZone = self.currentLocation.locationTimeZone;
    self.currentViewController.currentWeather = forecast.currentWeather;
}

#pragma - prepareForSegue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"MyLocationsTableViewController"]){
        MyLocationsTableViewController *destinationController = (MyLocationsTableViewController *)segue.destinationViewController;
        destinationController.currentLocation = self.currentLocation;
    }
}

-(NSString *)unixTimeStampToDate:(NSString *)timeStamp{
    NSTimeInterval interval = [timeStamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [self formatDate:date];
}

-(NSString *)formatDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, MMM d, yyyy"];
    return [formatter stringFromDate:date];
}




@end
