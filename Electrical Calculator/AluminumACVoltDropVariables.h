//
//  AluminumACVoltDropVariables.h
//  Electrical Calculator
//
//  Created by Paul Marney on 2/10/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AluminumACVoltDropVariables : NSObject

@end

/*

Two phases 
 -Three Phase mult wire
    calc = ((2*K)*L*I*.8661)/CM
 default = K, CM
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