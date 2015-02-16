//
//  SubdivisionLoadVariables.h
//  Electrical Calculator
//
//  Created by Paul Marney on 1/21/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface XFRMR: NSObject
@property float size;
@property int qtyl;
@end

@interface SubdivisionLoadVariables : NSObject

@property (strong,nonatomic) NSMutableArray *xfrmr;
@property (strong,nonatomic) NSNumber       *kilovolt_amps;
@property (strong,nonatomic) NSNumber       *volts;

- (void)setDefaultKilovolt_Amps:(NSNumber *)kamps;
- (void)setDefaultVolts:(NSNumber *)volts;
- (void)setDefaultXFRMR:(NSMutableArray *)xmfrmr;
- (void) removeValues;

- (void)addXFRMR:(XFRMR *)xfrmr;

//- (SubdivisionLoadVariables *)updateXFRMRQuantity:(XFRMR *)xfrmr;
- (void)updateXFRMRSize:(XFRMR *)xfrmr andIndex:(int)index;

- (float)calulateXFRMRFullLoad;

@end
