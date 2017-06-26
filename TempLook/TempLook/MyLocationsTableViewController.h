//
//  MyLocationsTableViewController.h
//  TempLook
//
//  Created by Vitalka on 17.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface MyLocationsTableViewController : UITableViewController

@property(strong, nonatomic)Location *currentLocation;
@property(strong, nonatomic)NSArray *locationTableHeaders;
@property(strong, nonatomic)NSMutableArray *savedLocations;

@end
