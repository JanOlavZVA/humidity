//
//  MyLocationsTableViewController.m
//  TempLook
//
//  Created by Vitalka on 17.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import "MyLocationsTableViewController.h"
#import "HelperForLocation.h"

@interface MyLocationsTableViewController ()

@end

@implementation MyLocationsTableViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"savedResults"] != nil){
        self.savedLocations = [[NSMutableArray alloc] initWithArray:[[[NSUserDefaults standardUserDefaults] objectForKey:@"savedResults"] mutableCopy]];
    }
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationTableHeaders = @[@"Current Location",@"Saved Locations"];
    
    
}
-(void)setCurrentLocation:(Location *)currentLocation{
    _currentLocation = currentLocation;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.locationTableHeaders.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.locationTableHeaders objectAtIndex:section];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1){
        return self.savedLocations.count;
    }
    return section;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newCell" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            [[cell textLabel] setText:self.currentLocation.locationName];
            break;
        case 1:
            [[cell textLabel] setText:self.savedLocations[indexPath.row]];
        default:
            break;
    }
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //     Return NO if you do not want the specified item to be editable.
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected locaiton : %@", self.savedLocations[indexPath.row]);
    [[HelperForLocation shared] findLatitudeAndLongitudeForAddress:self.savedLocations[indexPath.row]];
    [[self navigationController] popToRootViewControllerAnimated:YES];
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.savedLocations removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [NSUserDefaults.standardUserDefaults setObject:self.savedLocations forKey:@"savedResults"];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}


@end
