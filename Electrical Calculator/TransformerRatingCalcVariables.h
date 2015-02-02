//
//  TransformerRatingCalcVariables.h
//  Electrical Calculator
//
//  Created by Paul Marney on 2/2/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TRCImpedance : NSObject

@property float VKA;
@property float V208;
@property float V480;

-(TRCImpedance *) lookupImpedance:(NSMutableArray *)impedancesList andKiloVoltAmps:(NSNumber *)kva;

@end

@interface TransformerRatingCalcVariables : NSObject

@property (strong, nonatomic)NSMutableArray *impedance;
@property (strong,nonatomic) NSNumber       *kilovolt_amps;
@property (strong,nonatomic) NSNumber       *ltlPriVolts;
@property (strong,nonatomic) NSNumber       *ltlSecVolts;

-(void) setDefaultsTRCImpedances:(NSMutableArray *)impedances;
-(void) addTRCImpedances:(TRCImpedance *)impedance;
-(void) deleteTRCImpedances:(TRCImpedance *)impedance;
-(void) updateTRCImpedances:(TRCImpedance *)impedance andIndex:(int)index;
@end
