//
//  ForecastModel.m
//  TempLook
//
//  Created by Vitalka on 17.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import "ForecastModel.h"
#import "AFNetworking.h"
#import "ForecastApiClient.h"

NSString *const keyFCErrorDomain = @"com.forecastr.errors";
typedef enum {
    keyFCCachedItemNotFound,
    keyFCCacheNotEnabled
} ForecastrErrorType;

// Cache keys
NSString *const keyFCCacheKey = @"CachedForecasts";
NSString *const keyFCCacheArchiveKey = @"ArchivedForecast";
NSString *const keyFCCacheExpiresKey = @"ExpiresAt";
NSString *const keyFCCacheForecastKey = @"Forecast";
NSString *const keyFCCacheJSONPKey = @"JSONP";

/**
 * A common area for changing the names of all constants used in the JSON response
 */

// Unit types
NSString *const keyFCUSUnits = @"us";
NSString *const keyFCSIUnits = @"si";
NSString *const keyFCUKUnits = @"uk";
NSString *const keyFCCAUnits = @"ca";
NSString *const keyFCAutoUnits = @"auto";

// Languages
NSString *const keyFCLanguageUkrainian = @"uk";
NSString *const keyFCLanguageBosnian = @"bs";
NSString *const keyFCLanguageGerman = @"de";
NSString *const keyFCLanguageEnglish = @"en"; // Default
NSString *const keyFCLanguageSpanish = @"es";
NSString *const keyFCLanguageFrench = @"fr";
NSString *const keyFCLanguageItalian = @"it";
NSString *const keyFCLanguageDutch = @"nl";
NSString *const keyFCLanguagePolish = @"pl";
NSString *const keyFCLanguagePortuguese = @"pt";
NSString *const keyFCLanguageTetum = @"tet";
NSString *const keyFCLanguagePigLatin = @"x-pig-latin";

// Extend types
NSString *const keyFCExtendHourly = @"hourly";

// Forecast names used for the data block hash keys
NSString *const keyFCCurrentlyForecast = @"currently";
NSString *const keyFCMinutelyForecast = @"minutely";
NSString *const keyFCHourlyForecast = @"hourly";
NSString *const keyFCDailyForecast = @"daily";

// Additional names used for the data block hash keys
NSString *const keyFCAlerts = @"alerts";
NSString *const keyFCFlags = @"flags";
NSString *const keyFCLatitude = @"latitude";
NSString *const keyFCLongitude = @"longitude";
NSString *const keyFCOffset = @"offset";
NSString *const keyFCTimezone = @"timezone";

// Names used for the data point hash keys
NSString *const keyFCCloudCover = @"cloudCover";
NSString *const keyFCCloudCoverError = @"cloudCoverError";
NSString *const keyFCDewPoint = @"dewPoint";
NSString *const keyFCHumidity = @"humidity";
NSString *const keyFCHumidityError = @"humidityError";
NSString *const keyFCIcon = @"icon";
NSString *const keyFCMoonPhase = @"moonPhase";
NSString *const keyFCOzone = @"ozone";
NSString *const keyFCPrecipAccumulation = @"precipAccumulation";
NSString *const keyFCPrecipIntensity = @"precipIntensity";
NSString *const keyFCPrecipIntensityMax = @"precipIntensityMax";
NSString *const keyFCPrecipIntensityMaxTime = @"precipIntensityMaxTime";
NSString *const keyFCPrecipProbability = @"precipProbability";
NSString *const keyFCPrecipType = @"precipType";
NSString *const keyFCPressure = @"pressure";
NSString *const keyFCPressureError = @"pressureError";
NSString *const keyFCSummary = @"summary";
NSString *const keyFCSunriseTime = @"sunriseTime";
NSString *const keyFCSunsetTime = @"sunsetTime";
NSString *const keyFCTemperature = @"temperature";
NSString *const keyFCTemperatureMax = @"temperatureMax";
NSString *const keyFCTemperatureMaxError = @"temperatureMaxError";
NSString *const keyFCTemperatureMaxTime = @"temperatureMaxTime";
NSString *const keyFCTemperatureMin = @"temperatureMin";
NSString *const keyFCTemperatureMinError = @"temperatureMinError";
NSString *const keyFCTemperatureMinTime = @"temperatureMinTime";
NSString *const keyFCApparentTemperature = @"apparentTemperature";
NSString *const keyFCApparentTemperatureMax = @"apparentTemperatureMax";
NSString *const keyFCApparentTemperatureMin = @"apparentTemperatureMin";
NSString *const keyFCTime = @"time";
NSString *const keyFCVisibility = @"visibility";
NSString *const keyFCVisibilityError = @"visibilityError";
NSString *const keyFCWindBearing = @"windBearing";
NSString *const keyFCWindSpeed = @"windSpeed";
NSString *const keyFCWindSpeedError = @"windSpeedError";

// Names used for weather icons
NSString *const keyFCIconClearDay = @"clear-day";
NSString *const keyFCIconClearNight = @"clear-night";
NSString *const keyFCIconRain = @"rain";
NSString *const keyFCIconSnow = @"snow";
NSString *const keyFCIconSleet = @"sleet";
NSString *const keyFCIconWind = @"wind";
NSString *const keyFCIconFog = @"fog";
NSString *const keyFCIconCloudy = @"cloudy";
NSString *const keyFCIconPartlyCloudyDay = @"partly-cloudy-day";
NSString *const keyFCIconPartlyCloudyNight = @"partly-cloudy-night";
NSString *const keyFCIconHail = @"hail";
NSString *const keyFCIconThunderstorm = @"thunderstorm";
NSString *const keyFCIconTornado = @"tornado";
NSString *const keyFCIconHurricane = @"hurricane";

// A numerical value representing the distance to the nearest storm
NSString *const keyFCNearestStormDistance = @"nearestStormDistance";
NSString *const keyFCNearestStormBearing = @"nearestStormBearing";

@interface ForecastModel ()
{
    NSUserDefaults *userDefaults;
    
    dispatch_queue_t async_queue;
}

@end
@implementation ForecastModel
# pragma mark - Singleton Methods

+ (id)sharedManager
{
    static ForecastModel *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (id)init {
    if (self = [super init]) {
        // Init code here
        userDefaults = [NSUserDefaults standardUserDefaults];
        
        // Setup the async queue
        async_queue = dispatch_queue_create("com.forecastr.asyncQueue", NULL);
        
        // Caching defaults
        self.cacheEnabled = YES; // Enable cache by default
        self.cacheExpirationInMinutes = 30; // Set default of 30 minutes
    }
    return self;
}
# pragma mark - Instance Methods

- (void)getForecastForLatitude:(double)lat
                     longitude:(double)lon
                          time:(NSNumber *)time
                    exclusions:(NSArray *)exclusions
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error, id response))failure
{
    [self getForecastForLatitude:lat longitude:lon time:time exclusions:exclusions extend:nil success:success failure:failure];
}

- (void)getForecastForLatitude:(double)lat
                     longitude:(double)lon
                          time:(NSNumber *)time
                    exclusions:(NSArray *)exclusions
                        extend:(NSString *)extendCommand
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error, id response))failure
{
    [self getForecastForLatitude:lat longitude:lon time:time exclusions:exclusions extend:nil language:nil success:success failure:failure];
}

// Requests the specified forecast for the given location and optional parameters
- (void)getForecastForLatitude:(double)lat
                     longitude:(double)lon
                          time:(NSNumber *)time
                    exclusions:(NSArray *)exclusions
                        extend:(NSString *)extendCommand
                      language:(NSString *)languageCode
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error, id response))failure
{
    // Check if we have an API key set
    [self checkForAPIKey];
    
    // Generate the URL string based on the passed in params
    NSString *urlString = [self urlStringforLatitude:lat longitude:lon time:time exclusions:exclusions extend:(NSString *)extendCommand language:languageCode];
    
    //#ifndef NDEBUG
    //    NSLog(@"Forecastr: Checking forecast for %@", urlString);
    //#endif
    
    NSString *callback = self.callback;
    
    // Check if we have a valid cache item that hasn't expired for this URL
    // If caching isn't enabled or a fresh cache item wasn't found, it will execute a server request in the failure block
    NSString *cacheKey = [self cacheKeyForURLString:urlString forLatitude:lat longitude:lon];
    [self checkForecastCacheForURLString:cacheKey success:^(id cachedForecast) {
        success(cachedForecast);
    } failure:^(NSError *error) {
        // If we got here, cache isn't enabled or we didn't find a valid/unexpired forecast
        // for this location in cache so let's query the servers for one
        
        // Asynchronously kick off the GET request on the API for the generated URL (i.e. not the one used as a cache key)
        if (callback) {
            
            [ForecastApiClient sharedClient].responseSerializer = [AFHTTPResponseSerializer serializer];
            [[ForecastApiClient sharedClient] GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSString *JSONP = [[NSString alloc] initWithData:responseObject encoding:NSASCIIStringEncoding];
                if (self.cacheEnabled) [self cacheForecast:JSONP withURLString:cacheKey];
                [ForecastApiClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
                success(JSONP);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                [ForecastApiClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
                failure(error, response);
            }];
            
        } else {
            
            [[ForecastApiClient sharedClient] GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id JSON) {
                if (self.cacheEnabled) [self cacheForecast:JSON withURLString:cacheKey];
                success(JSON);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                failure(error, response);
            }];
            
        }
    }];
}

// Cancels all requests that are currently queued or being executed
- (void)cancelAllForecastRequests
{
    for (id task in [[ForecastApiClient sharedClient] tasks]) {
        if ([task respondsToSelector:@selector(cancel)]) {
            [task cancel];
        }
    }
}

// Returns a description based on the precicipation intensity
- (NSString *)descriptionForPrecipIntensity:(float)precipIntensity
{
    if (precipIntensity < 0.002) { return @"None"; }
    if (precipIntensity < 0.017) { return @"Very light"; }
    if (precipIntensity < 0.1) { return @"Light"; }
    if (precipIntensity < 0.4) { return @"Moderate"; }
    else return @"Heavy";
}

// Returns an image name based on the weather icon type
- (NSString *)imageNameForWeatherIconType:(NSString *)iconDescription
{
    if ([iconDescription isEqualToString:keyFCIconClearDay]) { return @"clearDay.png"; }
    else if ([iconDescription isEqualToString:keyFCIconClearNight]) { return @"clearNight.png"; }
    else if ([iconDescription isEqualToString:keyFCIconRain]) { return @"rain.png"; }
    else if ([iconDescription isEqualToString:keyFCIconSnow]) { return @"snow.png"; }
    else if ([iconDescription isEqualToString:keyFCIconSleet]) { return @"sleet.png"; }
    else if ([iconDescription isEqualToString:keyFCIconWind]) { return @"wind.png"; }
    else if ([iconDescription isEqualToString:keyFCIconFog]) { return @"fog.png"; }
    else if ([iconDescription isEqualToString:keyFCIconCloudy]) { return @"cloudy.png"; }
    else if ([iconDescription isEqualToString:keyFCIconPartlyCloudyDay]) { return @"partlyCloudyDay.png"; }
    else if ([iconDescription isEqualToString:keyFCIconPartlyCloudyNight]) { return @"partlyCloudyNight.png"; }
    else if ([iconDescription isEqualToString:keyFCIconHail]) { return @"hail.png"; }
    else if ([iconDescription isEqualToString:keyFCIconThunderstorm]) { return @"thunderstorm.png"; }
    else if ([iconDescription isEqualToString:keyFCIconTornado]) { return @"tornado.png"; }
    else if ([iconDescription isEqualToString:keyFCIconHurricane]) { return @"hurricane.png"; }
    else return @"cloudy.png"; // Default in case nothing matched
}

// Returns a string with the JSON error message, if given, or the appropriate localized description for the NSError object
- (NSString *)messageForError:(NSError *)error withResponse:(id)response
{
    
    return nil;
}

# pragma mark - Private Methods

// Check for an empty API key
- (void)checkForAPIKey
{
    if (!self.apiKey || !self.apiKey.length) {
        [NSException raise:@"Forecastr" format:@"Your Forecast.io API key must be populated before you can access the API.", nil];
    }
}

// Generates a URL string for the given options
- (NSString *)urlStringforLatitude:(double)lat longitude:(double)lon time:(NSNumber *)time exclusions:(NSArray *)exclusions extend:(NSString *)extendCommand language:(NSString *)languageCode
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%.6f,%.6f", self.apiKey, lat, lon];
    if (time) urlString = [urlString stringByAppendingFormat:@",%.0f", [time doubleValue]];
    if (exclusions) urlString = [urlString stringByAppendingFormat:@"?exclude=%@", [self stringForExclusions:exclusions]];
    if (extendCommand) urlString = [urlString stringByAppendingFormat:@"%@extend=%@", exclusions ? @"&" : @"?", extendCommand];
    if (languageCode) urlString = [urlString stringByAppendingFormat:@"%@lang=%@", (exclusions || extendCommand) ? @"&" : @"?", languageCode];
    if (self.units) urlString = [urlString stringByAppendingFormat:@"%@units=%@", (exclusions || extendCommand || languageCode) ? @"&" : @"?", self.units];
    if (self.callback) urlString = [urlString stringByAppendingFormat:@"%@callback=%@", (exclusions || self.units || extendCommand || languageCode) ? @"&" : @"?", self.callback];
    return urlString;
}

// Generates a string from an array of exclusions
- (NSString *)stringForExclusions:(NSArray *)exclusions
{
    __block NSString *exclusionString = @"";
    [exclusions enumerateObjectsUsingBlock:^(id exclusion, NSUInteger idx, BOOL *stop) {
        exclusionString = [exclusionString stringByAppendingFormat:idx == 0 ? @"%@" : @",%@", exclusion];
    }];
    return exclusionString;
}

# pragma mark - Cache Instance Methods

// Checks the NSUserDefaults for a cached forecast that is still fresh
- (void)checkForecastCacheForURLString:(NSString *)urlString
                               success:(void (^)(id cachedForecast))success
                               failure:(void (^)(NSError *error))failure
{
    if (self.cacheEnabled) {
        
        //  Perform this on a background thread
        dispatch_async(async_queue, ^{
            BOOL cachedItemWasFound = NO;
            @try {
                NSDictionary *cachedForecasts = [userDefaults dictionaryForKey:keyFCCacheKey];
                if (cachedForecasts) {
                    // Create an NSString object from the coordinates as the dictionary key
                    NSData *archivedCacheItem = [cachedForecasts objectForKey:urlString];
                    // Check if the forecast exists and hasn't expired yet
                    if (archivedCacheItem) {
                        NSDictionary *cacheItem = [self objectForArchive:archivedCacheItem];
                        if (cacheItem) {
                            NSDate *expirationTime = (NSDate *)[cacheItem objectForKey:keyFCCacheExpiresKey];
                            NSDate *rightNow = [NSDate date];
                            if ([rightNow compare:expirationTime] == NSOrderedAscending) {
                                cachedItemWasFound = YES;
                                // Cache item is still fresh
                                dispatch_sync(dispatch_get_main_queue(), ^{
                                    success([cacheItem objectForKey:keyFCCacheForecastKey]);
                                });
                                
                            }
                            // As a note, there is no need to remove any stale cache item since it will
                            // be overwritten when the forecast is cached again
                        }
                    }
                }
                if (!cachedItemWasFound) {
                    // If we don't have anything fresh in the cache
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        failure([NSError errorWithDomain:keyFCErrorDomain code:keyFCCachedItemNotFound userInfo:nil]);
                    });
                }
            }
            @catch (NSException *exception) {
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    failure([NSError errorWithDomain:keyFCErrorDomain code:keyFCCachedItemNotFound userInfo:nil]);
                });
            }
        });
        
    } else {
        failure([NSError errorWithDomain:keyFCErrorDomain code:keyFCCacheNotEnabled userInfo:nil]);
    }
}

// Caches a forecast in NSUserDefaults based on the original URL string used to request it
- (void)cacheForecast:(id)forecast withURLString:(NSString *)urlString
{
   
    // Save to cache on a background thread
    dispatch_async(async_queue, ^{
        NSMutableDictionary *cachedForecasts = [[userDefaults dictionaryForKey:keyFCCacheKey] mutableCopy];
        if (!cachedForecasts) cachedForecasts = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        // Set up the new dictionary we are going to cache
        NSDate *expirationDate = [[NSDate date] dateByAddingTimeInterval:self.cacheExpirationInMinutes * 60]; // X minutes from now
        NSMutableDictionary *newCacheItem = [[NSMutableDictionary alloc] initWithCapacity:2];
        [newCacheItem setObject:expirationDate forKey:keyFCCacheExpiresKey];
        [newCacheItem setObject:forecast forKey:keyFCCacheForecastKey];
        
        // Save the new cache item and sync the user defaults
        [cachedForecasts setObject:[self archivedObject:newCacheItem] forKey:urlString];
        [userDefaults setObject:cachedForecasts forKey:keyFCCacheKey];
        [userDefaults synchronize];
    });
}

// Deprecated method
- (void)removeCachedForecastForLatitude:(double)lat longitude:(double)lon time:(NSNumber *)time exclusions:(NSArray *)exclusions extend:(NSString *)extendCommand
{
    [self removeCachedForecastForLatitude:lat longitude:lon time:time exclusions:exclusions extend:extendCommand language:nil];
}

// Removes a cached forecast in case you want to refresh it prematurely
- (void)removeCachedForecastForLatitude:(double)lat longitude:(double)lon time:(NSNumber *)time exclusions:(NSArray *)exclusions extend:(NSString *)extendCommand language:(NSString *)languageCode
{
    NSString *urlString = [self urlStringforLatitude:lat longitude:lon time:time exclusions:exclusions extend:extendCommand language:languageCode];
    NSString *cacheKey = [self cacheKeyForURLString:urlString forLatitude:lat longitude:lon];
    
    NSMutableDictionary *cachedForecasts = [[userDefaults dictionaryForKey:keyFCCacheKey] mutableCopy];
    if (cachedForecasts) {
        
        [cachedForecasts removeObjectForKey:cacheKey];
        [userDefaults setObject:cachedForecasts forKey:keyFCCacheKey];
        [userDefaults synchronize];
    }
}

// Flushes all forecasts from the cache
- (void)flushCache
{
    
    [userDefaults removeObjectForKey:keyFCCacheKey];
    [userDefaults synchronize];
}

# pragma mark - Cache Private Methods

// Truncates the latitude and longitude within the URL so that it's more generalized to the user's location
// Otherwise, you end up requesting forecasts from the server even though your lat/lon has only changed by a very small amount
- (NSString *)cacheKeyForURLString:(NSString *)urlString forLatitude:(double)lat longitude:(double)lon
{
    NSString *oldLatLon = [NSString stringWithFormat:@"%f,%f", lat, lon];
    NSString *generalizedLatLon = [NSString stringWithFormat:@"%.2f,%.2f", lat, lon];
    return [urlString stringByReplacingOccurrencesOfString:oldLatLon withString:generalizedLatLon];
}

// Creates an archived object suitable for storing in NSUserDefaults
- (NSData *)archivedObject:(id)object
{
    return object ? [NSKeyedArchiver archivedDataWithRootObject:object] : nil;
}

// Unarchives an object that was stored as NSData
- (id)objectForArchive:(NSData *)archivedObject
{
    return archivedObject ? [NSKeyedUnarchiver unarchiveObjectWithData:archivedObject] : nil;
}

@end
