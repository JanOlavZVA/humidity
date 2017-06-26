//
//  HelperForLocation.h
//  TempLook
//
//  Created by Vitalka on 17.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;


@protocol HelperLocationDelegate <NSObject>

@required

- (void)didGetLocation:(CLLocation *)location;

@optional

- (void)locationHelperDidFindLocationName:(NSString *)locationName;
- (void)locationHelperDidGetTimeZone:(NSTimeZone *)timeZone;
- (void)locationHelperUserDidDeny;
- (void)locationHelperDidFailWithError:(NSError *)error;

@end

@interface HelperForLocation : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocation *location;
@property(nonatomic, weak) id <HelperLocationDelegate>delegate;
@property(nonatomic, weak) id <HelperLocationDelegate>fetchDelegate;

+(instancetype)shared;

-(void)findNameForLocation:(CLLocation *)location;

-(void)updateLocation;

-(void)findLatitudeAndLongitudeForAddress:(NSString *)address;



@end
