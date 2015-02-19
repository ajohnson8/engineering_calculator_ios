//
//  ElectricalCal.h
//  Electrical Calculator
//
//  Created by Paul Marney on 2/13/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UICKeyChainStore/UICKeyChainStore.h>

#import "SubdivisionLoadVariables.h"
#import "TransformerCalcVariables.h"
#import "TransformerRatingCalcVariables.h"
#import "FuseWizardVariables.h"
#import "MainServiceVoltageDropVariables.h"
#import "BranchCircutVoltageDropVariables.h"

@interface ElectricalEnvCal : NSObject

+(void) setAllDeafults;
+(void) setDeafultXFRMR;
+(void) setDeafultPhases;
+(void) setDeafultVolts;
+(void) setDeafultKilovolt_Amps;
+(void) setDeafultTCLLSec;
+(void) setDeafultTFCOH;
+(void) setDeafultTFCUG;
+(void) setDeafultTFCSUBD;
+(void) setDeafultTRCImpedance;
@end
