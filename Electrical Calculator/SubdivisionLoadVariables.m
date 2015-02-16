//
//  SubdivisionLoadVariables.m
//  Electrical Calculator
//
//  Created by Paul Marney on 1/21/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "SubdivisionLoadVariables.h"

@implementation SubdivisionLoadVariables
@synthesize xfrmr=_xfrmr,kilovolt_amps=_kilovolt_amps,volts=_volts;

-(id)init{
    
    return self;
}

- (void)setDefaultKilovolt_Amps:(NSNumber *)kamps{
    _kilovolt_amps=kamps;
}

- (void)setDefaultVolts:(NSNumber *)volts{
    _volts=volts;
}

- (void)setDefaultXFRMR:(NSMutableArray *)xmfrmr{
    _xfrmr = [[NSMutableArray alloc]init];
    XFRMR *temp = [xmfrmr firstObject];
    if ([temp isKindOfClass:[XFRMR class]]) {
        for (XFRMR *num in xmfrmr) {
            XFRMR *temp = [[XFRMR alloc]init];
            [temp setSize:[num size]];
            [temp setQtyl:0];
            [_xfrmr addObject:temp];
        }
    }
    else{
        for (NSNumber *num in xmfrmr) {
            XFRMR *temp = [[XFRMR alloc]init];
            [temp setSize:[num floatValue]];
            [temp setQtyl:0];
            [_xfrmr addObject:temp];
        }
    }
}

-(void)addXFRMR:(XFRMR *)xfrmr{
    NSMutableArray *temp = [NSMutableArray arrayWithObject:xfrmr];
    [temp addObjectsFromArray:_xfrmr];
    _xfrmr = temp;
}

- (void)updateXFRMRSize:(XFRMR *)xfrmr andIndex:(int)index{
    self.xfrmr[index] = xfrmr;
    [self sortAndRemoveDoubles];
}

-(void)sortAndRemoveDoubles{
    
    NSMutableArray *unique = [NSMutableArray array];
    NSMutableSet *processedXFRMR = [NSMutableSet set];
    
    for (XFRMR *wo in _xfrmr) {
        if (!([processedXFRMR containsObject:[NSNumber numberWithFloat:wo.size]])){
            [unique addObject:wo];
            [processedXFRMR addObject:[NSNumber numberWithFloat:wo.size]];
        }
    }
    _xfrmr = unique;
    
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"size" ascending:YES];
    [_xfrmr sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
}


#pragma  mark - Calulations
-(float)calulateXFRMRFullLoad{
    
    float FULLLOAD = 0.00;
    for (XFRMR *temp in self.xfrmr) {
        float x = ((temp.size * [self.kilovolt_amps floatValue])/[self.volts floatValue])*temp.qtyl;
        FULLLOAD+=x;
    }
    
    return FULLLOAD;
}

@end

@implementation XFRMR
@synthesize size,qtyl;

-(id)init{
    
    return self;
}


-(void) encodeWithCoder: (NSCoder *) encoder
{
    [encoder encodeObject:[NSNumber numberWithFloat:size] forKey:@"size"];
    [encoder encodeObject:[NSNumber numberWithInteger:qtyl] forKey:@"qtyl"];
}

-(id) initWithCoder: (NSCoder *) decoder
{
    size = [[decoder decodeObjectForKey :@"size"] floatValue];
    qtyl = [[decoder decodeObjectForKey :@"qtyl"] intValue];
    return self;
}
@end

