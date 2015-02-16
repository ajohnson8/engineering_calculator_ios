//
//  WireSizeVoltageDropVariables.m
//  Electrical Calculator
//
//  Created by Paul Marney on 2/10/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "WireSizeVoltageDropVariables.h"

@implementation WireSizeVoltageDropVariables

-(void) setDefaultsOneWayLength:(float)oneWayLength{
    
    _oneWayLength = [[NSNumber alloc]initWithFloat:oneWayLength];
}

-(void) setDefaultsCurrent:(float)current{
    _current = [[NSNumber alloc]initWithFloat:current];
}

-(void) setDefaultsWSVDWire:(NSMutableArray *)wires{
    _wires = [[NSMutableArray alloc]initWithArray:[wires copy]];
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

-(float)calulate1NECAmpacity{
    
    return _selectWire.ampacity*.8;
}

-(float)calulate2Insulation{//8
    return [self calulate1NECAmpacity]*.8;
}

-(float)calulate3FullLoadRate {//7
    return [self calulate1NECAmpacity]*.7;
}

-(float)calulate4NeutralCounted{//5
    return [self calulate1NECAmpacity]*.5;
}

-(float)calulate5Resistance:(WSVDVolts)volts{
    if (volts == v120)
        return [_oneWayLength floatValue]*_selectWire.ohms*2;
    else
        return [_oneWayLength floatValue]*_selectWire.ohms;
    
}
-(float)calulate6VoltageDrop:(WSVDVolts)volts{
    return [self calulate5Resistance:volts]*[_current floatValue];
}
-(float)calulate7PercentDrop:(WSVDVolts)volts{
    return [self calulate6VoltageDrop:volts]/120;
}
-(float)calulate8PercentDrop:(WSVDVolts)volts{
    if (volts == v120)
        return 120-[self calulate6VoltageDrop:volts];
    else
        return 240-[self calulate6VoltageDrop:volts];
}



-(void)filterWires{
    
    NSMutableArray *unique = [NSMutableArray array];
    NSMutableSet *processedXFRMR = [NSMutableSet set];
    
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

@implementation WSVDWire
-(void) encodeWithCoder: (NSCoder *) encoder
{
    [encoder encodeObject:_wireSize forKey:@"wireSize"];
    [encoder encodeObject:[NSNumber numberWithFloat:_ampacity] forKey:@"ampacity"];
    [encoder encodeObject:[NSNumber numberWithFloat:_ohms] forKey:@"ohms"];
    [encoder encodeObject:[NSNumber numberWithFloat:_circ] forKey:@"circ"];
}

-(id) initWithCoder: (NSCoder *) decoder
{
    _wireSize = [decoder decodeObjectForKey :@"wireSize"];
    _ampacity = [[decoder decodeObjectForKey :@"ampacity"] floatValue];
    _ohms     = [[decoder decodeObjectForKey :@"ohms"] floatValue];
    _circ     = [[decoder decodeObjectForKey :@"circ"] floatValue];
    return self;
}


+(WSVDWire *)lookupWire:(NSMutableArray *)wireList withWireSize:(NSString *)size{
    WSVDWire *wire = [[WSVDWire alloc]init];
    for (WSVDWire *temp in wireList) {
        if ([temp.wireSize isEqualToString:size])
            return temp;
    }
    [wire setWireSize:@"-1"];
    return wire;
}
@end