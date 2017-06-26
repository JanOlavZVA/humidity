//
//  WeekViewController.m
//  TempLook
//
//  Created by Vitalka on 15.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import "WeekViewController.h"
#import "WeekViewCell.h"

NSInteger const keyRowWeekHeight = 159;

@interface WeekViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *weekTableView;

@end

@implementation WeekViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    // Do any additional setup after loading the view.
}

-(void)setDailyWeather:(NSArray *)dailyWeather{
    _dayWeather = dailyWeather;
    [_weekTableView reloadData];
}

#pragma - UITableViewDataSource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dayWeather.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DayWeather *day = [self.dayWeather objectAtIndex:indexPath.row];
    WeekViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeekViewCell" forIndexPath:indexPath];
    [[cell lowTemp] setText:[[NSString alloc] initWithFormat:@"Low: %@˚F",day.temperatureMin]];
    [[cell hiTemp] setText:[[NSString alloc] initWithFormat:@"High: %@˚F",day.temperatureMax]];
    [[cell date] setText:[self unixTimeStampToDate:[day time]]];
    [[cell summary] setText:[day summary]];
    [[cell weatherIcon] setImage:[UIImage imageNamed:[day icon]]];
    return cell;
}

-(void)setUpTableView{
    [[self weekTableView]setDataSource:self];
    UINib *hourlyViewNib = [UINib nibWithNibName:@"WeekViewCell" bundle:[NSBundle mainBundle]];
    
    [[self weekTableView] setEstimatedRowHeight:keyRowWeekHeight];
    [[self weekTableView] setRowHeight:UITableViewAutomaticDimension];
    [[self weekTableView] registerNib:hourlyViewNib forCellReuseIdentifier:@"WeekViewCell"];
    
}


-(NSString *)unixTimeStampToDate:(NSString *)timeStamp{
    NSTimeInterval interval = [timeStamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, MMM d, yyyy"];
    return [formatter stringFromDate:date];
}



@end
