
//
//  TransformerRatingCalcVariables.m
//  Electrical Calculator
//
//  Created by Paul Marney on 2/2/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "TransformerRatingCalcVariables.h"

@implementation TransformerRatingCalcVariables
@synthesize impedances = _impedances;

#pragma mark - Initialize
-(id)init{
    self = [super init];
    if (self) {
        if (!_impedances)
            _impedances  = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark - Defaults
-(void) setDefaultskilovolt_amps:   (float)kilovolt_amps{
    _kilovolt_amps = [[NSNumber alloc]initWithFloat:kilovolt_amps];
}
-(void)setDefaultsTRCImpedances:(NSMutableArray *)impedances{
    
    _impedances = [[NSMutableArray alloc]initWithArray:[impedances copy]];
}
-(void) setDefaultsPriVolts:   (float)priVolts{
    _ltlPriVolts = [[NSNumber alloc]initWithFloat:priVolts];
}

-(void) setDefaultsSecVolts:   (float)secVolts{
    _ltlSecVolts = [[NSNumber alloc]initWithFloat:secVolts];
}

#pragma mark - Add
-(void) addTRCImpedances:(TRCImpedance *)impedance{
    [_impedances addObject:impedance];
    [self filterImpedances];
}

#pragma mark - Delete
-(void) deleteTRCImpedances:(TRCImpedance *)impedance{
    [_impedances removeObject:impedance];
    [self filterImpedances];
}

#pragma mark - Update
-(void) updateTRCImpedances:(TRCImpedance *)impedance andIndex:(int)index{
    [_impedances replaceObjectAtIndex:index withObject:impedance];
    [self filterImpedances];
}

-(void)filterImpedances{
    
    NSMutableArray *unique = [NSMutableArray array];
    NSMutableSet *processedXFRMR = [NSMutableSet set];
    
    for (TRCImpedance *wo in _impedances) {
        if (!([processedXFRMR containsObject:[NSNumber numberWithFloat:wo.KVA]])){
            [unique addObject:wo];
            [processedXFRMR addObject:[NSNumber numberWithFloat:wo.KVA]];
        }
    }
    _impedances = unique;
    
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"VKA" ascending:YES];
    [_impedances sortUsingDescriptors:[NSArray arrayWithObject:sort]];
}

#pragma mark - Calulate
-(float)calulateSNLSImpedance{
    
    return [TRCImpedance lookupImpedance:_impedances andKiloVoltAmps:_kilovolt_amps andSecVolts:_ltlSecVolts];
}

-(float)calulatePriCurFLA{
    return (([_kilovolt_amps floatValue] * 1000)/[_ltlPriVolts floatValue]/1.732);
}

-(float)calulateSecCurFLA{
    return (([_kilovolt_amps floatValue] * 1000)/[_ltlSecVolts floatValue]/1.732);
}

-(float)calulatePriFuseMax{
    return [self calulatePriCurFLA] * 3;
}

-(float)calulatePriFuseMin{
    return [self calulatePriCurFLA] * 1.25;
}

-(float)calulateSecBreaker{
    return [self calulateSecCurFLA] * 1.25;
}

-(float)calulateFaultDutyPri{
    return [self calulatePriCurFLA]/([self calulateSNLSImpedance]*.01);
}

-(float)calulateFaultDutySec{
    return [self calulateSecCurFLA]/([self calulateSNLSImpedance]*.01);
}


@end

@implementation TRCImpedance
@synthesize V208,V480,KVA;

#pragma mark - Coder

-(void) encodeWithCoder: (NSCoder *) encoder
{
    [encoder encodeObject:[NSNumber numberWithFloat:KVA] forKey:@"VKA"];
    [encoder encodeObject:[NSNumber numberWithFloat:V208] forKey:@"V208"];
    [encoder encodeObject:[NSNumber numberWithFloat:V480] forKey:@"V480"];
}

-(id) initWithCoder: (NSCoder *) decoder
{
    KVA = [[decoder decodeObjectForKey :@"VKA"] floatValue];
    V208 = [[decoder decodeObjectForKey :@"V208"] floatValue];
    V480 = [[decoder decodeObjectForKey :@"V480"] floatValue];
    return self;
}

#pragma mark - Class Methods
+(float)lookupImpedance:(NSMutableArray *)impedancesList andKiloVoltAmps:(NSNumber *)kva andSecVolts:(NSNumber *)secVolts{
    TRCImpedance * returnValue = [[TRCImpedance alloc]init];
    TRCImpedance * testfirst   = [[TRCImpedance alloc]init];
    
    testfirst = impedancesList.firstObject;
    if (testfirst.KVA == [kva floatValue]) {
        if ([secVolts floatValue] >= 208)
            return testfirst.V480;
        else
            return testfirst.V208;
    } else if ([secVolts floatValue] >= 208){
        for (TRCImpedance* temp in impedancesList) {
            if (temp.KVA >= [kva floatValue])
                return returnValue.V480;
            returnValue = temp;
        }
    }else{
        for (TRCImpedance* temp in impedancesList) {
            if (temp.KVA >= [kva floatValue])
                return returnValue.V208;
            returnValue = temp;
        }
            return returnValue.V208;
    }
    return 0;
}

@end