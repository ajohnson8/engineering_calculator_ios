//
//  AluminumACVoltDropVariables.h
//  Electrical Calculator
//
//  Created by Paul Marney on 2/10/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BranchCircutVoltageDropVariables.h"
#import "TransformerCalcVariables.h"

@interface MainServiceVoltageDropVariables : NSObject

@property (strong,nonatomic) WSVDWire       *selectWire;
@property (strong,nonatomic) TCPhase        *selectPhase;
@property (strong, nonatomic)NSMutableArray *wires;
@property (strong, nonatomic)NSMutableArray *phases;
@property (strong,nonatomic) NSNumber       *oneWayLength;
@property (strong,nonatomic) NSNumber       *current;
@property (strong,nonatomic) NSNumber       *cirtVoltage;
@property (strong,nonatomic) NSNumber       *resistivity;

-(void) setDefaultsOneWayLength:    (float)oneWayLength;
-(void) setDefaultsCurrent:         (float)current;
-(void) setDefaultsCircuitVoltage:  (float)cirtVoltage;
-(void) setDefaultsResistivity:     (float)resistivity;
-(void) setDefaultsWSVDWire:        (NSMutableArray *)wires;
-(void) setDefaultsAVDPhases:       (NSMutableArray *)phases;
-(void) removeValues;

-(void) addWSVDWire:                (WSVDWire *)wire;
-(void) deleteWSVDWire:             (WSVDWire *)wire;
-(void) updateWSVDWire:             (WSVDWire *)wire andIndex:(int)index;
-(void) updateAVDPhases:            (TCPhase *)phase andIndex:(int)index;

-(float)calulate1PhaseThree;
-(float)calulate2PhaseOne;
-(float)calulateWirePercent:(TCPhase *)phase;

@end



/*

Two phases 
 -Three Phase mult wire
    calc = ((2*K)*L*I*.8661)/CM
 default = K,CM
           K = is the wire resistivity 
           CM= is Base on the wire size 
 
 Inputs = L,I,WireSize
 
 -Signal Phase
    calc = ((2*K)*L*I)/CM
 default = K, CM
           K = is the wire resistivity
           CM= is Base on the wire size
 
 Inputs = L,I,WireSize
 
*/