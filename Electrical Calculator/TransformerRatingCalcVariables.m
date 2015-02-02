
//
//  TransformerRatingCalcVariables.m
//  Electrical Calculator
//
//  Created by Paul Marney on 2/2/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "TransformerRatingCalcVariables.h"

@implementation TransformerRatingCalcVariables
@synthesize impedance = _impedance;

-(id)init{
    self = [super init];
    if (self) {
        if (!_impedance)
            _impedance  = [[NSMutableArray alloc]init];
    }
    return self;
}


-(void)setDefaultsTRCImpedances:(NSMutableArray *)impedances{
    
    _impedance = [[NSMutableArray alloc]initWithArray:[impedances copy]];
}

-(void) addTRCImpedances:(TRCImpedance *)impedance{
    [_impedance addObject:impedance];
    [self sortAndRemoveDoubles];
}

-(void) deleteTRCImpedances:(TRCImpedance *)impedance{
    [_impedance removeObject:impedance];
    [self sortAndRemoveDoubles];
}

-(void) updateTRCImpedances:(TRCImpedance *)impedance andIndex:(int)index{
    [_impedance replaceObjectAtIndex:index withObject:impedance];
    [self sortAndRemoveDoubles];
}

-(void)sortAndRemoveDoubles{
    
    NSMutableArray *unique = [NSMutableArray array];
    NSMutableSet *processedXFRMR = [NSMutableSet set];
    
    for (TRCImpedance *wo in _impedance) {
        if (!([processedXFRMR containsObject:[NSNumber numberWithFloat:wo.VKA]])){
            [unique addObject:wo];
            [processedXFRMR addObject:[NSNumber numberWithFloat:wo.VKA]];
        }
    }
    _impedance = unique;
    
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"VKA" ascending:YES];
    [_impedance sortUsingDescriptors:[NSArray arrayWithObject:sort]];
}


@end

@implementation TRCImpedance
@synthesize V208,V480,VKA;

-(void) encodeWithCoder: (NSCoder *) encoder
{
    [encoder encodeObject:[NSNumber numberWithFloat:VKA] forKey:@"VKA"];
    [encoder encodeObject:[NSNumber numberWithFloat:V208] forKey:@"V208"];
    [encoder encodeObject:[NSNumber numberWithFloat:V208] forKey:@"V480"];
}

-(id) initWithCoder: (NSCoder *) decoder
{
    VKA = [[decoder decodeObjectForKey :@"VKA"] floatValue];
    V208 = [[decoder decodeObjectForKey :@"V208"] floatValue];
    V480 = [[decoder decodeObjectForKey :@"V480"] floatValue];
    return self;
}

-(TRCImpedance *) lookupImpedance:(NSMutableArray *)impedancesList andKiloVoltAmps:(NSNumber *)kva{
    TRCImpedance * returnValue = [[TRCImpedance alloc]init];
    
    return returnValue;
}

@end