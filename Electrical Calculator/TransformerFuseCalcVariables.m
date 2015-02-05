//
//  TransformerFuseCalcVariables.m
//  Electrical Calculator
//
//  Created by Paul Marney on 2/5/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "TransformerFuseCalcVariables.h"

@implementation TransformerFuseCalcVariables

@end

@interface TFCOH : NSObject

@property float KVA;
@property float SnC;
@property float MultSnC;
@property (nonatomic) NSString *NXCompII;

@end

@interface TFCUG : NSObject

@property float KVA;
@property float Bayonet;
@property (nonatomic) NSString *NX;
@property (nonatomic) NSString *SnCSM;

@end

@interface TFCSUBD : NSObject

@property (nonatomic) NSString *CKVAnPhase;
@property float SnCSTD;

@end