//
//  WireSizeVoltageDropVariables.h
//  Electrical Calculator
//
//  Created by Paul Marney on 2/10/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    v120,
    v240
} WSVDVolts;

@interface WSVDWire : NSObject

@property (nonatomic) NSString *wireSize;
@property float ampacity;
@property float ohms;
@property float circ;

+(WSVDWire *)lookupWire:(NSMutableArray *)wireList withWireSize:(NSString *)size;

@end

@interface BranchCircutVoltageDropVariables : NSObject

@property (strong, nonatomic)NSMutableArray *wires;
@property (strong,nonatomic) NSNumber       *oneWayLength;
@property (strong,nonatomic) NSNumber       *current;
@property (strong,nonatomic) WSVDWire       *selectWire;

-(void) setDefaultsOneWayLength:    (float)oneWayLength;
-(void) setDefaultsCurrent:         (float)current;
-(void) setDefaultsWSVDWire:        (NSMutableArray *)wires;
-(void) removeValues;

-(void) addWSVDWire:                (WSVDWire *)wire;
-(void) deleteWSVDWire:             (WSVDWire *)wire;
-(void) updateWSVDWire:             (WSVDWire *)wire andIndex:(int)index;

-(float)calulate1NECAmpacity;
-(float)calulate2Insulation;
-(float)calulate3FullLoadRate ;
-(float)calulate4NeutralCounted;

-(float)calulate5Resistance:(WSVDVolts)volts;
-(float)calulate6VoltageDrop:(WSVDVolts)volts;
-(float)calulate7PercentDrop:(WSVDVolts)volts;
-(float)calulate8PercentDrop:(WSVDVolts)volts;

@end
