//
//  TransformerFuseCalcVariables.m
//  Electrical Calculator
//
//  Created by Paul Marney on 2/5/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "FuseWizardVariables.h"

@implementation FuseWizardVariables

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
    [self filterOH_UG_SUBD:_ohs];
}
-(void) setDefaultsTFCUG:(NSMutableArray *)TFCUG{
    _ugs = [[NSMutableArray alloc]initWithArray:[TFCUG copy]];
    [self filterOH_UG_SUBD:_ugs];
}
-(void) setDefaultsTFCSUBD:(NSMutableArray *)TFCSUBD{
    _subds = [[NSMutableArray alloc]initWithArray:[TFCSUBD copy]];
    [self filterOH_UG_SUBD:_subds];
}

#pragma mark - Add
-(void) addTFCOHs:(TFCOH *)TFCOH{
    NSMutableArray *temp = [NSMutableArray arrayWithObject:TFCOH];
    [temp addObjectsFromArray:_ohs];
    _ohs = temp;
}

-(void) addTFCUG:(TFCUG *)tfcug{
    NSMutableArray *temp = [NSMutableArray arrayWithObject:tfcug];
    [temp addObjectsFromArray:_ugs];
    _ugs = temp;
}

-(void) addTFCSUBD:(TFCSUBD *)TFCSUBD{
    NSMutableArray *temp = [NSMutableArray arrayWithObject:TFCSUBD];
    [temp addObjectsFromArray:_subds];
    _subds = temp;
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
    _ohs[index]=TFCOH;
    [self filterOH_UG_SUBD:TFCOH];
}

-(void) updateTFCUGs:(TFCUG *)TFCUG andIndex:(int)index{
    _ugs[index]=TFCUG;
    [self filterOH_UG_SUBD:TFCUG];
}

-(void) updateTFCSUBD:(TFCSUBD *)TFCSUBD andIndex:(int)index{
    _subds[index]=TFCSUBD;
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
    if ([object isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray *temp = object;
        object = temp.lastObject;
        temp = nil;
    }
    
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
            if (!([processedXFRMR containsObject:wo.KVA])){
                [unique addObject:wo];
                [processedXFRMR addObject:wo.KVA];
            }
        }
        _ugs = unique;
        
        _ugs =[[_ugs sortedArrayUsingComparator:^NSComparisonResult(TFCUG *obj1, TFCUG *obj2) {
            if ([obj1.KVA intValue]==[obj2.KVA intValue])
                return NSOrderedSame;
            else if ([obj1.KVA intValue]<[obj2.KVA intValue])
                return NSOrderedAscending;
            else
                return NSOrderedDescending;
        }] mutableCopy];
        
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
    [encoder encodeObject:KVA forKey:@"KVA"];
    [encoder encodeObject:[NSNumber numberWithFloat:Bayonet] forKey:@"Bayonet"];
    [encoder encodeObject:NX forKey:@"NX"];
    [encoder encodeObject:SnCSM forKey:@"SnCSM"];
}

-(id) initWithCoder: (NSCoder *) decoder
{
    KVA = [decoder decodeObjectForKey :@"KVA"];
    Bayonet = [[decoder decodeObjectForKey :@"Bayonet"] floatValue];
    NX = [decoder decodeObjectForKey :@"NX"];
    SnCSM = [decoder decodeObjectForKey :@"SnCSM"];
    return self;
}

+(TFCUG *)lookupCUG:(NSMutableArray *)CUGList andKiloVoltAmps:(float)kva{
    TFCUG *ug = [[TFCUG alloc]init];
    for (TFCUG *temp in CUGList) {
        if ([temp.KVA isEqualToString:[NSString stringWithFormat:@"%f",kva]]) {
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