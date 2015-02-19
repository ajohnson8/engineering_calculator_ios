//
//  SubdivisionLoadVariables.m
//  Electrical Calculator
//
//  Created by Paul Marney on 1/21/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "SubdivisionLoadVariables.h"

@implementation SubdivisionLoadVariables
@synthesize xfrmr=_xfrmr,voltAmps=_voltAmps,volts=_volts;

-(id)init{
    
    return self;
}

- (void)setDefaultVoltAmps:(NSNumber *)voltamps{
    _voltAmps=voltamps;
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
            [temp setVKA:[num vKA]];
            [temp setQtyl:0];
            [_xfrmr addObject:temp];
        }
    }
    else{
        for (NSNumber *num in xmfrmr) {
            XFRMR *temp = [[XFRMR alloc]init];
            [temp setVKA:[num floatValue]];
            [temp setQtyl:0];
            [_xfrmr addObject:temp];
        }
    }
}

- (void) removeValues {
    for (XFRMR *wo in _xfrmr) {
        wo.qtyl = 0;
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
        if (!([processedXFRMR containsObject:[NSNumber numberWithFloat:wo.vKA]])){
            [unique addObject:wo];
            [processedXFRMR addObject:[NSNumber numberWithFloat:wo.vKA]];
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
        float x = ((temp.vKA * [self.voltAmps floatValue])/[self.volts floatValue])*temp.qtyl;
        FULLLOAD+=x;
    }
    
    return FULLLOAD;
}

@end

@implementation XFRMR
@synthesize vKA,qtyl;

-(id)init{
    
    return self;
}


-(void) encodeWithCoder: (NSCoder *) encoder
{
    [encoder encodeObject:[NSNumber numberWithFloat:vKA] forKey:@"size"];
    [encoder encodeObject:[NSNumber numberWithInteger:qtyl] forKey:@"qtyl"];
}

-(id) initWithCoder: (NSCoder *) decoder
{
    vKA = [[decoder decodeObjectForKey :@"size"] floatValue];
    qtyl = [[decoder decodeObjectForKey :@"qtyl"] intValue];
    return self;
}
@end

