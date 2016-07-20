//
//  proximity.m
//  AWARE
//
//  Created by Yuuki Nishiyama on 12/14/15.
//  Copyright © 2015 Yuuki NISHIYAMA. All rights reserved.
//

#import "proximity.h"
#import "EntityProximity.h"

@implementation Proximity

- (instancetype)initWithAwareStudy:(AWAREStudy *)study dbType:(AwareDBType)dbType{
    self = [super initWithAwareStudy:study
                          sensorName:SENSOR_PROXIMITY
                        dbEntityName:NSStringFromClass([EntityProximity class])
                              dbType:dbType
                          bufferSize:0];
    if (self) {
    }
    return self;
}

- (void) createTable{
    NSLog(@"[%@] Create Table", [self getSensorName]);
    NSString *query = [[NSString alloc] init];
    query = @"_id integer primary key autoincrement,"
    "timestamp real default 0,"
    "device_id text default '',"
    "double_proximity real default 0,"
    "accuracy real default 0,"
    "label text default '',"
    "UNIQUE (timestamp,device_id)";
    [super createTable:query];
}


- (BOOL)startSensorWithSettings:(NSArray *)settings{
    NSLog(@"[%@] Start Device Usage Sensor", [self getSensorName]);
    // Set and start proximity sensor
    // NOTE: This sensor is not working in the background
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(proximitySensorStateDidChange:)
                                                 name:UIDeviceProximityStateDidChangeNotification
                                               object:nil];

    return YES;
}


- (BOOL)stopSensor{
    // Stop a sync timer
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceProximityStateDidChangeNotification
                                                  object:nil];
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    return YES;
}


/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////


- (void)proximitySensorStateDidChange:(NSNotification *)notification {
    int state = [UIDevice currentDevice].proximityState;
    // NSLog(@"Proximity: %d", state );
    NSNumber * unixtime = [AWAREUtils getUnixTimestamp:[NSDate new]];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:unixtime forKey:@"timestamp"];
    [dic setObject:[self getDeviceId] forKey:@"device_id"];
    [dic setObject:[NSNumber numberWithInt:state] forKey:@"double_proximity"];
    [dic setObject:@0 forKey:@"accuracy"];
    [dic setObject:@"" forKey:@"label"];
    [self setLatestValue:[NSString stringWithFormat:@"[%d]", state ]];
    [self saveData:dic];
}

- (void)insertNewEntityWithData:(NSDictionary *)data managedObjectContext:(NSManagedObjectContext *)childContext entityName:(NSString *)entity{
    
    EntityProximity* entityProximity = (EntityProximity *)[NSEntityDescription
                                                     insertNewObjectForEntityForName:entity
                                                     inManagedObjectContext:childContext];
    
    entityProximity.device_id = [data objectForKey:@"device_id"];
    entityProximity.timestamp = [data objectForKey:@"timestamp"];
    entityProximity.double_proximity = [data objectForKey:@"double_proximity"];
    entityProximity.accuracy = [data objectForKey:@"accuracy"];
    entityProximity.label = [data objectForKey:@"label"];
    
}

- (void)saveDummyData{
    NSNumber * unixtime = [AWAREUtils getUnixTimestamp:[NSDate new]];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:unixtime forKey:@"timestamp"];
    [dic setObject:[self getDeviceId] forKey:@"device_id"];
    [dic setObject:@1 forKey:@"double_proximity"];
    [dic setObject:@0 forKey:@"accuracy"];
    [dic setObject:@"dummy" forKey:@"label"];
    [self saveData:dic];
}

@end
