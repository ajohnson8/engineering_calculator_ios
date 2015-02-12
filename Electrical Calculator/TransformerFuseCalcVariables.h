//
//  TransformerFuseCalcFormula.h
//  Electrical Calculator
//
//  Created by Paul Marney on 2/5/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFCOH : NSObject

@property float KVA;
@property float SnC;
@property float MultSnC;
@property (nonatomic) NSString *NXCompII;

+(TFCOH *)lookupOH:(NSMutableArray *)OHList andKiloVoltAmps:(float)kva;

@end

@interface TFCUG : NSObject

@property (nonatomic) NSString *KVA;
@property float Bayonet;
@property (nonatomic) NSString *NX;
@property (nonatomic) NSString *SnCSM;

+(TFCUG *)lookupCUG:(NSMutableArray *)CUGList andKiloVoltAmps:(float)kva;

@end

@interface TFCSUBD : NSObject

@property (nonatomic) NSString *CKVAnPhase;
@property float SnCSTD;

+(TFCSUBD *)lookupSUBD:(NSMutableArray *)SUBDList andCKVAnPhase:(NSString *)CKVAnPhase;

@end

@interface TransformerFuseCalcVariables : NSObject

@property (strong, nonatomic)   NSMutableArray *ohs;
@property (strong, nonatomic)   NSMutableArray *ugs;
@property (strong, nonatomic)   NSMutableArray *subds;

-(void) setDefaultsTFCOH:           (NSMutableArray *)TFCOH;
-(void) setDefaultsTFCUG:           (NSMutableArray *)TFCUG;
-(void) setDefaultsTFCSUBD:         (NSMutableArray *)TFCSUBD;

-(void) addTFCOHs:                  (TFCOH *)TFCOH;
-(void) deleteTFCOHs:               (TFCOH *)TFCOH;
-(void) updateTFCOH:                (TFCOH *)TFCOH andIndex:(int)index;

-(void) addTFCUG:                   (TFCUG *)tfcug;
-(void) deleteTFCUGs:               (TFCUG *)TFCUG;
-(void) updateTFCUGs:               (TFCUG *)TFCUG andIndex:(int)index;

-(void) addTFCSUBD:                 (TFCSUBD *)TFCSUBD;
-(void) deleteTFCSUBD:              (TFCSUBD *)TFCSUBD;
-(void) updateTFCSUBD:              (TFCSUBD *)TFCSUBD andIndex:(int)index;

-(TFCSUBD *)calulateTFCSUBD;
-(TFCUG *)  calulateTFCUG;
-(TFCOH *)  calulateTFCOH;


@end
