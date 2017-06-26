//
//  HelperForLocation.m
//  TempLook
//
//  Created by Vitalka on 17.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import "HelperForLocation.h"
#import "WeatherForecast.h"
#import "ForecastModel.h"

@import UIKit;

@interface HelperForLocation()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation HelperForLocation 

+(instancetype)shared{
    
    static HelperForLocation *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[[self class] alloc] init];
    });
    return shared;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self requestPermissions];
        self.location = [[CLLocation alloc] init];
    }
    
    return self;
}
-(void)requestPermissions {
    self.locationManager = [[CLLocationManager alloc]init];
    
    [self.locationManager requestWhenInUseAuthorization];
    
    self.locationManager.delegate = self;
    
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [self.locationManager setDistanceFilter: 100];
    
    
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusDenied :
            [self.delegate locationHelperUserDidDeny];
            break;
        default:
            break;
    }
}


//Reverses geocode and gets the name of the location based on the coordinates provided.
-(void)findNameForLocation:(CLLocation *)location{
    __block NSString *locationName;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Failed to get location name. Error: %@",error.localizedDescription);
            locationName = [self coordinateStringForLocation:location];
        } else if (placemarks && placemarks.count > 0){
            //A CLPlacemark object stores placemark data for a given latitude and longitude. Placemark data includes information such as the country, state, city, and street address associated with the specified coordinate.
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
            locationName = [placemark locality];
            locationName = [[NSString alloc] initWithFormat:@"%@, %@",placemark.locality,placemark.administrativeArea];
            
            //if the locality returns nil, return the coordinate string instead

            if (!locationName) {
                locationName = [self coordinateStringForLocation:location];
            }
            
        }
        [self.delegate locationHelperDidFindLocationName:locationName];
        [self.fetchDelegate locationHelperDidFindLocationName:locationName];
    }];
    
}
//gets the latitude and longitude of a location given an address
-(void)findLatitudeAndLongitudeForAddress:(NSString *)address{
    __block NSString *locationName;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder  geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Failed to get lat. and lon. for location. Error: %@",error.description);
        } else if (placemarks && placemarks.count > 0){
            //CLPlacemarker will contain lat. and lon. data as well geographic information such as the country, state, city, etc.
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSLog(@"Time Zone: %@",placemark.timeZone);
            [self.delegate locationHelperDidGetTimeZone:placemark.timeZone];
            NSLog(@"placemark: %@",placemark);
            [self.delegate didGetLocation:placemark.location];
            [self.fetchDelegate didGetLocation:placemark.location];
            if (placemark.locality == nil || placemark.administrativeArea == nil) {
                locationName = [[NSString alloc] initWithFormat:@"%@",placemark.name];
            } else {
                locationName = [[NSString alloc] initWithFormat:@"%@, %@",placemark.locality,placemark.administrativeArea];
            }
            [self.delegate locationHelperDidFindLocationName:locationName];
            [self.fetchDelegate locationHelperDidFindLocationName:locationName];
        }
    }];
    
}

-(NSString *)coordinateStringForLocation:(CLLocation *)location{
    NSString *str = [[NSString alloc] initWithFormat:@"Lat: %f, Lon: %f",location.coordinate.latitude, location.coordinate.longitude];
    return str;
}
-(void)updateLocation{
    [[self locationManager] startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate methods
//Stop the CLLocation from updating the location (to save battery power)
-(void)stopUpdating{
    NSLog(@"Stopped updating location.");
    [self.locationManager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
    
    [self findNameForLocation:location];
    self.location = location;
    
    NSLog(@"Location for: Lat: %f Lon: %f",location.coordinate.latitude, location.coordinate.longitude);
    
    //maximize battery power by stopping the location manager as soon as possible
    [self stopUpdating];
    
    [self.delegate didGetLocation:self.location];
    [self.fetchDelegate didGetLocation:self.location];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (error) {
        NSLog(@"Failed to find location : %@", error.localizedDescription);
        [self.delegate locationHelperDidFailWithError:error];
    }
}


@end
