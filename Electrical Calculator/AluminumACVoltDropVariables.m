//
//  AluminumACVoltDropVariables.m
//  Electrical Calculator
//
//  Created by Paul Marney on 2/10/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "AluminumACVoltDropVariables.h"

@implementation AluminumACVoltDropVariables

-(void) setDefaultsOneWayLength:(float)oneWayLength{
    _oneWayLength = [[NSNumber alloc]initWithFloat:oneWayLength];
}
-(void) setDefaultsCurrent:(float)current{
    _current = [[NSNumber alloc]initWithFloat:current];
}
-(void) setDefaultsCircuitVoltage:(float)cirtVoltage{
    _cirtVoltage = [[NSNumber alloc]initWithFloat:cirtVoltage];
}
-(void) setDefaultsResistivity:(float)resistivity{
    _resistivity = [[NSNumber alloc]initWithFloat:resistivity];
}
-(void) setDefaultsWSVDWire:(NSMutableArray *)wires{
    _wires = [[NSMutableArray alloc]initWithArray:[wires copy]];
}
-(void) setDefaultsAVDPhases:(NSMutableArray *)phases{
    _phases = [[NSMutableArray alloc]initWithArray:[phases copy]];
}

-(void) addWSVDWire:(WSVDWire *)wire{
    NSMutableArray *temp = [NSMutableArray arrayWithObject:wire];
    [temp addObjectsFromArray:_wires];
    _wires = temp;
}
-(void) deleteWSVDWire:(WSVDWire *)wire{
    [_wires removeObject:wire];
    [self filterWires];
}
-(void) updateWSVDWire:(WSVDWire *)wire andIndex:(int)index{
    _wires[index]=wire;
    [self filterWires];
}

-(void) updateAVDPhases:(TCPhase *)phase andIndex:(int)index{
    _phases[index]=phase;
}

-(float)calulate1PhaseThree{
    return ((2*[_resistivity floatValue])*[_oneWayLength floatValue]*[_current floatValue]*.8661)/_selectWire.circ;
}
-(float)calulate2PhaseOne{
    return ((2*[_resistivity floatValue])*[_oneWayLength floatValue]*[_current floatValue])/_selectWire.circ;
}

-(void)filterWires{
    
    NSMutableArray *unique = [NSMutableArray array];
    NSMutableSet *processedXFRMR = [NSMutableSet set];
    
    for (WSVDWire *wo in _wires) {
        if (wo.wireSize.length == 0 && wo.circ == 0 && wo.ampacity == 0 && wo.ohms == 0) {
            [_wires removeObject:wo];
            break;
        }
    }
    
    for (WSVDWire *wo in _wires) {
        if (!([processedXFRMR containsObject:wo.wireSize])){
            [unique addObject:wo];
            [processedXFRMR addObject:wo.wireSize];
        }
    }
    _wires = unique;
    
    _wires =[[_wires sortedArrayUsingComparator:^NSComparisonResult(WSVDWire *obj1, WSVDWire *obj2) {
        if ([obj1.wireSize intValue]==[obj2.wireSize intValue])
            return NSOrderedSame;
        else if ([obj1.wireSize intValue]<[obj2.wireSize intValue])
            return NSOrderedAscending;
        else
            return NSOrderedDescending;
    }] mutableCopy];
}

@end
