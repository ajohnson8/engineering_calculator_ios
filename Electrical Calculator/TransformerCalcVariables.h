//
//  TransformerCalc.h
//  Electrical Calculator
//
//  Created by Paul Marney on 1/26/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TCPhase : NSObject

@property int phaseID;
@property float phasevalue;
@property float phaseLL;

@end

@interface TCLLSec : NSObject

@property float llSecVaule;

@end

@interface TransformerCalcVariables : NSObject

@property float ampsPer;
@property float kilovolt_amps;
@property (strong, nonatomic)NSMutableArray *phases;
@property (strong, nonatomic)NSMutableArray *llSecs;

-(void) setDefaultsTCPhase:(NSMutableArray *)phaseArray;
-(void) setDefaultsTCLLSec:(NSMutableArray *)llSecArray;
-(void) setDefaultsAmpsPer:(float)updatedAmpsPer;
-(void) setDefaultskilovolt_amps:(float)updatedKilovolt_amps;
-(void) removeValues;

-(void) addTCLLSec:(TCLLSec *)newLLSec;
-(void) deleteTCLLSec:(TCLLSec *)llsec;

-(void) updateTCLLSec:(TCLLSec *)llsec andIndex:(int)index;
-(void) updateTCPhase:(TCPhase *)phase andIndex:(int)index;

-(float)calulateFullLoadAmpsOnPri:(TCPhase *)phaseCAL;
-(float)calulateFullLoadAmpsOnSec:(TCPhase *)phaseCAL andLLSec:(TCLLSec *)llsec;
-(float)calulateAvailablFaultCurrentPri:(TCPhase *)phaseCAL;
-(float)calulateAvailablFaultCurrentSec:(TCPhase *)phaseCAL andLLSec:(TCLLSec *)llsec;

@end


