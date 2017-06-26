//
//  WeekViewCell.h
//  TempLook
//
//  Created by Vitalka on 17.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *summary;
@property (weak, nonatomic) IBOutlet UILabel *lowTemp;
@property (weak, nonatomic) IBOutlet UILabel *hiTemp;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;

@end
