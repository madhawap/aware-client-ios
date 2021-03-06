//----------------------------------------------------------------
//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//
//----------------------------------------------------------------

#import "MSBSensorData.h"

@interface MSBSensorBarometerData : MSBSensorData

/**
 * Air pressure in hectopascals (hPa)
 */
@property (nonatomic, readonly) double airPressure;

/**
 * Temperature in celsius
 */
@property (nonatomic, readonly) double temperature;

@end
