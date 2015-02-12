//
//  TransformerCalc.m
//  Electrical Calculator
//
//  Created by Paul Marney on 1/26/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "TransformerCalcVariables.h"

@implementation TransformerCalcVariables
@synthesize phases,llSecs,ampsPer,kilovolt_amps;

#pragma mark - Initialize
-(id)init{
    self = [super init];
    if (self) {
        if (!phases)
            phases  = [[NSMutableArray alloc]init];
        if (!llSecs)
            llSecs  = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark - Defaults
-(void)setDefaultsTCPhase:(NSMutableArray *)phaseArray{
    
    phases = [[NSMutableArray alloc]initWithArray:[phaseArray copy]];
}

-(void)setDefaultsTCLLSec:(NSMutableArray *)llSecArray{
    llSecs = [[NSMutableArray alloc]init];
    TCLLSec *temp = [llSecArray firstObject];
    if ([temp isKindOfClass:[TCLLSec class]]) {
        llSecs = [[NSMutableArray alloc]initWithArray:llSecArray];
    }
    else{
        for (NSNumber *num in llSecArray) {
            TCLLSec *temp = [[TCLLSec alloc]init];
            [temp setLlSecVaule:[num floatValue]];
            [llSecs addObject:temp];
        }
    }
}

-(void)setDefaultsAmpsPer:(float)updatedAmpsPer{
    ampsPer = updatedAmpsPer;
}
-(void)setDefaultskilovolt_amps:(float)updatedKilovolt_amps{
    kilovolt_amps = updatedKilovolt_amps;
}

#pragma mark - Add
-(void)addTCLLSec:(TCLLSec *)newLLSec {
    [llSecs addObject:newLLSec];
    [self filterSecLLs];
}

-(void) deleteTCLLSec:(TCLLSec *)llsec{
    for (int x = 0; x < self.llSecs.count; x++) {
        TCLLSec *temp = self.llSecs[x];
        if (temp.llSecVaule == llsec.llSecVaule){
            [self.llSecs removeObjectAtIndex: x];
        }
    }
    [self filterSecLLs];
}

#pragma mark - Update
-(void) updateTCLLSec:(TCLLSec *)llsec andIndex:(int)index{
    self.llSecs[index] = llsec;
    [self filterSecLLs];
}

-(void) updateTCPhase:(TCPhase *)phase andIndex:(int)index{
    self.phases[index] = phase;
}

#pragma mark - Calulate
-(float)calulateFullLoadAmpsOnPri:(TCPhase *)phaseCAL {
    return (kilovolt_amps*1000)/(phaseCAL.phaseLL*phaseCAL.phasevalue);
}

-(float)calulateFullLoadAmpsOnSec:(TCPhase *)phaseCAL andLLSec:(TCLLSec *)llsec {
    return (kilovolt_amps*1000)/(llsec.llSecVaule * phaseCAL.phasevalue);
    
}
-(float)calulateAvailablFaultCurrentPri:(TCPhase *)phaseCAL {
    
    return [self calulateFullLoadAmpsOnPri:phaseCAL]/(ampsPer*.01);
}
-(float)calulateAvailablFaultCurrentSec:(TCPhase *)phaseCAL andLLSec:(TCLLSec *)llsec {
    
    return [self calulateFullLoadAmpsOnSec:phaseCAL andLLSec:llsec]/(ampsPer*.01);
}

#pragma mark - Private Methods
-(void)filterSecLLs{
    
    NSMutableArray *unique = [NSMutableArray array];
    NSMutableSet *processedXFRMR = [NSMutableSet set];
    
    for (TCLLSec *wo in llSecs) {
        if (!([processedXFRMR containsObject:[NSNumber numberWithFloat:wo.llSecVaule]])){
            [unique addObject:wo];
            [processedXFRMR addObject:[NSNumber numberWithFloat:wo.llSecVaule]];
        }
    }
    llSecs = unique;
    
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"llSecVaule" ascending:YES];
    [llSecs sortUsingDescriptors:[NSArray arrayWithObject:sort]];
}

@end

#pragma mark - Implementation TCPhase
@implementation TCPhase
@synthesize phasevalue,phaseID,phaseLL;

#pragma mark - Coder
-(void) encodeWithCoder: (NSCoder *) encoder
{
    [encoder encodeObject:[NSNumber numberWithInteger:phaseID] forKey:@"phaseID"];
    [encoder encodeObject:[NSNumber numberWithFloat:phasevalue] forKey:@"phasevalue"];
    [encoder encodeObject:[NSNumber numberWithFloat:phaseLL] forKey:@"phaseLL"];

    
}

-(id) initWithCoder: (NSCoder *) decoder
{
    phaseID = [[decoder decodeObjectForKey :@"phaseID"] intValue];
    phasevalue = [[decoder decodeObjectForKey :@"phasevalue"] floatValue];
    phaseLL = [[decoder decodeObjectForKey :@"phaseLL"] floatValue];


    return self;
}

@end

#pragma mark - Implementation TCLLSec
@implementation TCLLSec
@synthesize llSecVaule;

#pragma mark - Coder
-(void) encodeWithCoder: (NSCoder *) encoder
{
    [encoder encodeObject:[NSNumber numberWithFloat:llSecVaule] forKey:@"llSecVaule"];
}

-(id) initWithCoder: (NSCoder *) decoder
{
    llSecVaule = [[decoder decodeObjectForKey :@"llSecVaule"] floatValue];
    return self;
}


@end