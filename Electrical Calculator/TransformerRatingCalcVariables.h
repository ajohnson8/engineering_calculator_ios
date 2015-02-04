//
//  TransformerRatingCalcVariables.h
//  Electrical Calculator
//
//  Created by Paul Marney on 2/2/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TRCImpedance : NSObject

@property float KVA;
@property float V208;
@property float V480;

+(float)lookupImpedance:(NSMutableArray *)impedancesList andKiloVoltAmps:(NSNumber *)kva andSecVolts:(NSNumber *)secVolts;

@end

@interface TransformerRatingCalcVariables : NSObject

@property (strong, nonatomic)NSMutableArray *impedances;
@property (strong,nonatomic) NSNumber       *kilovolt_amps;
@property (strong,nonatomic) NSNumber       *ltlPriVolts;
@property (strong,nonatomic) NSNumber       *ltlSecVolts;

-(void) setDefaultskilovolt_amps:   (float)kilovolt_amps;
-(void) setDefaultsPriVolts:        (float)priVolts;
-(void) setDefaultsSecVolts:        (float)secVolts;
-(void) setDefaultsTRCImpedances:   (NSMutableArray *)impedances;

-(void) addTRCImpedances:           (TRCImpedance *)impedance;
-(void) deleteTRCImpedances:        (TRCImpedance *)impedance;
-(void) updateTRCImpedances:        (TRCImpedance *)impedance andIndex:(int)index;

-(float)calulateSNLSImpedance;
-(float)calulatePriCurFLA;
-(float)calulateSecCurFLA;
-(float)calulatePriFuseMax;
-(float)calulatePriFuseMin;
-(float)calulateSecBreaker;
-(float)calulateFaultDutyPri;
-(float)calulateFaultDutySec;
@end
