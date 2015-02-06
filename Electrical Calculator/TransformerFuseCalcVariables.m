//
//  TransformerFuseCalcVariables.m
//  Electrical Calculator
//
//  Created by Paul Marney on 2/5/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "TransformerFuseCalcVariables.h"

@implementation TransformerFuseCalcVariables

#pragma mark - Initialize
-(id)init{
    self = [super init];
    if (self) {
        if (!_ohs)
            _ohs  = [[NSMutableArray alloc]init];
        if (!_ugs)
            _ugs  = [[NSMutableArray alloc]init];
        if (!_subds)
            _subds= [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark - Defaults
-(void) setDefaultsTFCOH:(NSMutableArray *)TFCOH{
    _ohs = [[NSMutableArray alloc]initWithArray:[TFCOH copy]];
}
-(void) setDefaultsTFCUG:(NSMutableArray *)TFCUG{
    _ugs = [[NSMutableArray alloc]initWithArray:[TFCUG copy]];
}
-(void) setDefaultsTFCSUBD:(NSMutableArray *)TFCSUBD{
    _subds = [[NSMutableArray alloc]initWithArray:[TFCSUBD copy]];
}

#pragma mark - Add
-(void) addTFCOHs:(TFCOH *)TFCOH{
    [_ohs addObject:TFCOH];
    [self filterOH_UG_SUBD:TFCOH];
}

-(void) addTFCUG:(TFCUG *)TFCUG{
    [_ugs addObject:TFCUG];
    [self filterOH_UG_SUBD:TFCUG];
}

-(void) addTFCSUBD:(TFCSUBD *)TFCSUBD{
    [_subds addObject:TFCSUBD];
    [self filterOH_UG_SUBD:TFCSUBD];
}
#pragma mark - Delete
-(void) deleteTFCOHs:(TFCOH *)TFCOH{
    [_ohs removeObject:TFCOH];
    [self filterOH_UG_SUBD:TFCOH];
}

-(void) deleteTFCUGs:(TFCUG *)TFCUG{
    [_ugs removeObject:TFCUG];
    [self filterOH_UG_SUBD:TFCUG];
}

-(void) deleteTFCSUBD:(TFCSUBD *)TFCSUBD{
    [_subds removeObject:TFCSUBD];
    [self filterOH_UG_SUBD:TFCSUBD];
}
#pragma mark - Update
-(void) updateTFCOH:(TFCOH *)TFCOH andIndex:(int)index{
    [_ohs replaceObjectAtIndex:index withObject:TFCOH];
    [self filterOH_UG_SUBD:TFCOH];
}

-(void) updateTFCUGs:(TFCUG *)TFCUG andIndex:(int)index{
    [_ugs replaceObjectAtIndex:index withObject:TFCUG];
    [self filterOH_UG_SUBD:TFCUG];
}

-(void) updateTFCSUBD:(TFCSUBD *)TFCSUBD andIndex:(int)index{
    [_subds replaceObjectAtIndex:index withObject:TFCSUBD];
    [self filterOH_UG_SUBD:TFCSUBD];
}

#pragma mark - Calulate
-(TFCSUBD *)calulateTFCSUBD{
    TFCSUBD *subd = [[TFCSUBD alloc]init];
    return subd;
}
-(TFCUG *)calulateTFCUG{
    TFCUG *ug = [[TFCUG alloc]init];
    return ug;
}
-(TFCOH *)calulateTFCOH{
    TFCOH *oh = [[TFCOH alloc]init];
    return oh;
}

#pragma mark - Private Methods
-(void)filterOH_UG_SUBD:(id)object{
    
    NSMutableArray *unique = [NSMutableArray array];
    NSMutableSet *processedXFRMR = [NSMutableSet set];
    
    if ([object isKindOfClass:[TFCOH class]]){
        for (TFCOH *wo in _ohs) {
            if (!([processedXFRMR containsObject:[NSNumber numberWithFloat:wo.KVA]])){
                [unique addObject:wo];
                [processedXFRMR addObject:[NSNumber numberWithFloat:wo.KVA]];
            }
        }
        _ohs = unique;
        
        NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"KVA" ascending:YES];
        [_ohs sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    } else if ([object isKindOfClass:[TFCUG class]]){
        for (TFCUG *wo in _ugs) {
            if (!([processedXFRMR containsObject:[NSNumber numberWithFloat:wo.KVA]])){
                [unique addObject:wo];
                [processedXFRMR addObject:[NSNumber numberWithFloat:wo.KVA]];
            }
        }
        _ugs = unique;
        
        NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"KVA" ascending:YES];
        [_ugs sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    } else if ([object isKindOfClass:[TFCSUBD class]]) {
        for (TFCSUBD *wo in _subds) {
            if (!([processedXFRMR containsObject:wo.CKVAnPhase])){
                [unique addObject:wo];
                [processedXFRMR addObject:wo.CKVAnPhase];
            }
        }
        _subds = unique;
        
        NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"CKVAnPhase" ascending:YES];
        [_subds sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    }
}


@end

@implementation TFCOH
@synthesize KVA,SnC,MultSnC,NXCompII;

#pragma mark - Coder

-(void) encodeWithCoder: (NSCoder *) encoder
{
    [encoder encodeObject:[NSNumber numberWithFloat:KVA] forKey:@"KVA"];
    [encoder encodeObject:[NSNumber numberWithFloat:SnC] forKey:@"SnC"];
    [encoder encodeObject:[NSNumber numberWithFloat:MultSnC] forKey:@"MultSnC"];
    [encoder encodeObject:NXCompII forKey:@"NXCompII"];
}

-(id) initWithCoder: (NSCoder *) decoder
{
    KVA = [[decoder decodeObjectForKey :@"KVA"] floatValue];
    MultSnC = [[decoder decodeObjectForKey :@"MultSnC"] floatValue];
    SnC = [[decoder decodeObjectForKey :@"SnC"] floatValue];
    NXCompII = [decoder decodeObjectForKey :@"NXCompII"];
    return self;
}

+(TFCOH *)lookupOH:(NSMutableArray *)OHList andKiloVoltAmps:(float)kva{
    TFCOH *oh = [[TFCOH alloc]init];
    for (TFCOH *temp in OHList) {
        if (temp.KVA == kva) {
            return temp;
        }
    }
    [oh setKVA:0];
    [oh setMultSnC:0];
    [oh setNXCompII:@""];
    [oh setSnC:0];

    return oh;
}

@end

@implementation TFCUG
@synthesize KVA,Bayonet,NX,SnCSM;

#pragma mark - Coder

-(void) encodeWithCoder: (NSCoder *) encoder
{
    [encoder encodeObject:[NSNumber numberWithFloat:KVA] forKey:@"KVA"];
    [encoder encodeObject:[NSNumber numberWithFloat:Bayonet] forKey:@"Bayonet"];
    [encoder encodeObject:NX forKey:@"NX"];
    [encoder encodeObject:SnCSM forKey:@"SnCSM"];
}

-(id) initWithCoder: (NSCoder *) decoder
{
    KVA = [[decoder decodeObjectForKey :@"KVA"] floatValue];
    Bayonet = [[decoder decodeObjectForKey :@"Bayonet"] floatValue];
    NX = [decoder decodeObjectForKey :@"NX"];
    SnCSM = [decoder decodeObjectForKey :@"SnCSM"];
    return self;
}

+(TFCUG *)lookupCUG:(NSMutableArray *)CUGList andKiloVoltAmps:(float)kva{
    TFCUG *ug = [[TFCUG alloc]init];
    for (TFCUG *temp in CUGList) {
        if (temp.KVA == kva) {
            return temp;
        }
    }
    [ug setKVA:0];
    [ug setBayonet:0];
    [ug setNX:@""];
    [ug setSnCSM:@""];
    
    return ug;
}

@end

@implementation TFCSUBD
@synthesize CKVAnPhase,SnCSTD;
#pragma mark - Coder

-(void) encodeWithCoder: (NSCoder *) encoder
{
    [encoder encodeObject:CKVAnPhase forKey:@"CKVAnPhase"];
    [encoder encodeObject:[NSNumber numberWithFloat:SnCSTD] forKey:@"SnCSTD"];
}

-(id) initWithCoder: (NSCoder *) decoder
{
    CKVAnPhase = [decoder decodeObjectForKey :@"CKVAnPhase"];
    SnCSTD = [[decoder decodeObjectForKey :@"SnCSTD"] floatValue];
    return self;
}

+(TFCSUBD *)lookupSUBD:(NSMutableArray *)SUBDList andCKVAnPhase:(NSString *)CKVAnPhase{
    TFCSUBD *subd = [[TFCSUBD alloc]init];
    for (TFCSUBD *temp in SUBDList) {
        if ([temp.CKVAnPhase isEqualToString:CKVAnPhase]) {
            return temp;
        }
    }
    [subd setCKVAnPhase:@""];
    [subd setSnCSTD:0];
    return subd;
}

@end