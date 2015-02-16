//
//  ElectricalCal.m
//  Electrical Calculator
//
//  Created by Paul Marney on 2/13/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "ElectricalEnvCal.h"

@implementation ElectricalEnvCal

+(void)setAllDeafults{
    [self setDeafultXFRMR];
    [self setDeafultPhases];
    [self setDeafultVolts];
    [self setDeafultKilovolt_Amps];
    [self setDeafultTCLLSec];
    [self setDeafultTFCOH];
    [self setDeafultTFCUG];
    [self setDeafultTFCSUBD];
    [self setDeafultTRCImpedance];
    [self setDeafultWSVDWire];

    [UICKeyChainStore setString:@"NO" forKey:@"FormulaConfiguration"];
}

+(void)setDeafultXFRMR{
   
    NSMutableArray *defaultSize = [[NSMutableArray alloc]init];
    [defaultSize addObject:[NSNumber numberWithInt:5]];
    [defaultSize addObject:[NSNumber numberWithInt:10]];
    [defaultSize addObject:[NSNumber numberWithInt:15]];
    [defaultSize addObject:[NSNumber numberWithInt:25]];
    [defaultSize addObject:[NSNumber numberWithInt:75]];
    [defaultSize addObject:[NSNumber numberWithInt:100]];
    
    NSData* myDataXFRMR = [NSKeyedArchiver archivedDataWithRootObject:defaultSize];
    [UICKeyChainStore setData:myDataXFRMR forKey:@"SystemDefaultsXFRMR"];
}

+(void)setDeafultPhases{
    
    TCPhase *phase = [[TCPhase alloc]init];
    [phase setPhaseID:1];
    [phase setPhaseLL:7200];
    [phase setPhasevalue:1.0];
    
    TCPhase *phase2 = [[TCPhase alloc]init];
    [phase2 setPhaseID:3];
    [phase2 setPhaseLL:12470];
    [phase2 setPhasevalue:1.732];

    NSMutableArray *defaultPhase = [[NSMutableArray alloc]init];
    [defaultPhase addObject:phase];
    [defaultPhase addObject:phase2];
    
    NSData* myDataArrayPhase = [NSKeyedArchiver archivedDataWithRootObject:defaultPhase];
    [UICKeyChainStore setData:myDataArrayPhase forKey:@"SystemDefaultsArrayPhase"];
}

+(void)setDeafultVolts{
    
    NSData* myDataVolts = [NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:7200]];
    [UICKeyChainStore setData:myDataVolts forKey:@"SystemDefaultsVolts"];
}

+(void)setDeafultKilovolt_Amps{
    
    NSData* myDataKilovolt_Amps = [NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:1000]];
    [UICKeyChainStore setData:myDataKilovolt_Amps forKey:@"SystemDefaultsKilovolt_Amps"];
}

+(void)setDeafultTCLLSec{

    NSMutableArray *defaultLLSec = [[NSMutableArray alloc]init];
    [defaultLLSec addObject:[NSNumber numberWithInt:208]];
    [defaultLLSec addObject:[NSNumber numberWithInt:240]];
    [defaultLLSec addObject:[NSNumber numberWithInt:480]];
    [defaultLLSec addObject:[NSNumber numberWithInt:577]];
    
    NSData* myDataArrayLLSec = [NSKeyedArchiver archivedDataWithRootObject:defaultLLSec];
    [UICKeyChainStore setData:myDataArrayLLSec forKey:@"SystemDefaultsArrayLLSec"];
}

+(void)setDeafultTFCOH{
    
    NSMutableArray *defaultohs = [[NSMutableArray alloc]init];
    
    TFCOH * oh0 = [[TFCOH alloc]init];
    [oh0 setKVA :5];
    [oh0 setNXCompII:@"12k"];
    [oh0 setSnC:5];
    [oh0 setMultSnC:5];
    [defaultohs addObject:oh0];
    
    TFCOH * oh1 = [[TFCOH alloc]init];
    [oh1 setKVA :10];
    [oh1 setNXCompII:@"12k"];
    [oh1 setSnC:5];
    [oh1 setMultSnC:5];
    [defaultohs addObject:oh1];
    
    TFCOH * oh2 = [[TFCOH alloc]init];
    [oh2 setKVA :15];
    [oh2 setNXCompII:@"12k"];
    [oh2 setSnC:5];
    [oh2 setMultSnC:5];
    [defaultohs addObject:oh2];
    
    TFCOH * oh3 = [[TFCOH alloc]init];
    [oh3 setKVA :25];
    [oh3 setNXCompII:@"12k"];
    [oh3 setSnC:7];
    [oh3 setMultSnC:7];
    [defaultohs addObject:oh3];
    
    TFCOH * oh4 = [[TFCOH alloc]init];
    [oh4 setKVA :37.5];
    [oh4 setNXCompII:@"12k"];
    [oh4 setSnC:10];
    [oh4 setMultSnC:10];
    [defaultohs addObject:oh4];
    
    TFCOH * oh5 = [[TFCOH alloc]init];
    [oh5 setKVA :50];
    [oh5 setNXCompII:@"25k"];
    [oh5 setSnC:10];
    [oh5 setMultSnC:10];
    [defaultohs addObject:oh5];
    
    TFCOH * oh6 = [[TFCOH alloc]init];
    [oh6 setKVA :75];
    [oh6 setNXCompII:@"25k"];
    [oh6 setSnC:15];
    [oh6 setMultSnC:15];
    [defaultohs addObject:oh6];
    
    TFCOH * oh7 = [[TFCOH alloc]init];
    [oh7 setKVA :100];
    [oh7 setNXCompII:@"40k"];
    [oh7 setSnC:20];
    [oh7 setMultSnC:15];
    [defaultohs addObject:oh7];
    
    TFCOH * oh8 = [[TFCOH alloc]init];
    [oh8 setKVA :125];
    [oh8 setNXCompII:@""];
    [oh8 setSnC:0];
    [oh8 setMultSnC:20];
    [defaultohs addObject:oh8];
    
    TFCOH * oh9 = [[TFCOH alloc]init];
    [oh9 setKVA :150];
    [oh9 setNXCompII:@""];
    [oh9 setSnC:0];
    [oh9 setMultSnC:25];
    [defaultohs addObject:oh9];
    
    TFCOH * oh10 = [[TFCOH alloc]init];
    [oh10 setKVA :175];
    [oh10 setNXCompII:@""];
    [oh10 setSnC:0];
    [oh10 setMultSnC:30];
    [defaultohs addObject:oh10];
    
    TFCOH * oh11 = [[TFCOH alloc]init];
    [oh11 setKVA :200];
    [oh11 setNXCompII:@""];
    [oh11 setSnC:0];
    [oh11 setMultSnC:30];
    [defaultohs addObject:oh11];
    
    TFCOH * oh12 = [[TFCOH alloc]init];
    [oh12 setKVA :225];
    [oh12 setNXCompII:@""];
    [oh12 setSnC:0];
    [oh12 setMultSnC:40];
    [defaultohs addObject:oh12];
    
    TFCOH * oh13 = [[TFCOH alloc]init];
    [oh13 setKVA :250];
    [oh13 setNXCompII:@""];
    [oh13 setSnC:0];
    [oh13 setMultSnC:40];
    [defaultohs addObject:oh13];
    
    TFCOH * oh14 = [[TFCOH alloc]init];
    [oh14 setKVA :275];
    [oh14 setNXCompII:@""];
    [oh14 setSnC:0];
    [oh14 setMultSnC:50];
    [defaultohs addObject:oh14];
    
    TFCOH * oh15 = [[TFCOH alloc]init];
    [oh15 setKVA :300];
    [oh15 setNXCompII:@""];
    [oh15 setSnC:0];
    [oh15 setMultSnC:50];
    [defaultohs addObject:oh15];
    
    NSData* myDataArrayPhase = [NSKeyedArchiver archivedDataWithRootObject:defaultohs];
    [UICKeyChainStore setData:myDataArrayPhase forKey:@"SystemDefaultsArrayOH"];
}

+(void)setDeafultTFCUG{
    NSMutableArray *defaultugs = [[NSMutableArray alloc]init];
    
    TFCUG * ug = [[TFCUG alloc]init];
    [ug setKVA :@"25"];
    [ug setBayonet:8];
    [ug setNX:@""];
    [ug setSnCSM:@""];
    [defaultugs addObject:ug];
    
    TFCUG * ug1 = [[TFCUG alloc]init];
    [ug1 setKVA :@"50"];
    [ug1 setBayonet:15];
    [ug1 setNX:@""];
    [ug1 setSnCSM:@""];
    [defaultugs addObject:ug1];
    
    TFCUG * ug2 = [[TFCUG alloc]init];
    [ug2 setKVA :@"75"];
    [ug2 setBayonet:25];
    [ug2 setNX:@""];
    [ug2 setSnCSM:@""];
    [defaultugs addObject:ug2];
    
    TFCUG * ug3 = [[TFCUG alloc]init];
    [ug3 setKVA :@"100"];
    [ug3 setBayonet:25];
    [ug3 setNX:@""];
    [ug3 setSnCSM:@""]; 
    [defaultugs addObject:ug3];
    
    TFCUG * ug4 = [[TFCUG alloc]init];
    [ug4 setKVA :@"167"];
    [ug4 setBayonet:50];
    [ug4 setNX:@""];
    [ug4 setSnCSM:@""];
    [defaultugs addObject:ug4];
    
    TFCUG * ug5 = [[TFCUG alloc]init];
    [ug5 setKVA :@"150"];
    [ug5 setBayonet:15];
    [ug5 setNX:@""];
    [ug5 setSnCSM:@""];
    [defaultugs addObject:ug5];
    
    TFCUG * ug6 = [[TFCUG alloc]init];
    [ug6 setKVA :@"300"];
    [ug6 setBayonet:25];
    [ug6 setNX:@""];
    [ug6 setSnCSM:@"30E"]; 
    [defaultugs addObject:ug6];
    
    TFCUG * ug7 = [[TFCUG alloc]init];
    [ug7 setKVA :@"500"];
    [ug7 setBayonet:50];
    [ug7 setNX:@""];
    [ug7 setSnCSM:@"50E"]; 
    [defaultugs addObject:ug7];
    
    TFCUG * ug8 = [[TFCUG alloc]init];
    [ug8 setKVA :@"750"];
    [ug8 setBayonet:65];
    [ug8 setNX:@""];
    [ug8 setSnCSM:@"80E"];
    [defaultugs addObject:ug8];
    
    TFCUG * ug9 = [[TFCUG alloc]init];
    [ug9 setKVA :@"1000"];
    [ug9 setBayonet:65];
    [ug9 setNX:@"100A"];
    [ug9 setSnCSM:@"100E"];
    [defaultugs addObject:ug9];
    
    TFCUG * ug10 = [[TFCUG alloc]init];
    [ug10 setKVA :@"1500"];
    [ug10 setBayonet:140];
    [ug10 setNX:@"2-65A"];
    [ug10 setSnCSM:@"150E"]; 
    [defaultugs addObject:ug10];
    
    TFCUG * ug11 = [[TFCUG alloc]init];
    [ug11 setKVA :@"2000"];
    [ug11 setBayonet:0];
    [ug11 setNX:@"2-100A"];
    [ug11 setSnCSM:@"200E"];
    [defaultugs addObject:ug11];
    
    TFCUG * ug12 = [[TFCUG alloc]init];
    [ug12 setKVA :@"2500"];
    [ug12 setBayonet:0];
    [ug12 setNX:@"2-100A"];
    [ug12 setSnCSM:@"250E"];
    [defaultugs addObject:ug12];
    
    TFCUG * ug13 = [[TFCUG alloc]init];
    [ug13 setKVA :@"2-1500"];
    [ug13 setBayonet:0];
    [ug13 setNX:@"2-100A"];
    [ug13 setSnCSM:@"250E"];
    [defaultugs addObject:ug13];
    
    TFCUG * ug14 = [[TFCUG alloc]init];
    [ug14 setKVA :@"2-2000"];
    [ug14 setBayonet:0];
    [ug14 setNX:@"2-100A"];
    [ug14 setSnCSM:@"300E"];
    [defaultugs addObject:ug14];
    
    TFCUG * ug15 = [[TFCUG alloc]init];
    [ug15 setKVA :@"2-2500"];
    [ug15 setBayonet:0];
    [ug15 setNX:@"2-100A"];
    [ug15 setSnCSM:@"400E"];
    [defaultugs addObject:ug15];
    
    
    NSData* myDataArrayPhase = [NSKeyedArchiver archivedDataWithRootObject:defaultugs];
    [UICKeyChainStore setData:myDataArrayPhase forKey:@"SystemDefaultsArrayUG"];
}

+(void)setDeafultTFCSUBD{
    NSMutableArray *defaultsubds = [[NSMutableArray alloc]init];
    
    TFCSUBD * subd1 = [[TFCSUBD alloc]init];
    [subd1 setCKVAnPhase:@"<150"];
    [subd1 setSnCSTD:20];
    [defaultsubds addObject:subd1];
    
    TFCSUBD * subd2 = [[TFCSUBD alloc]init];
    [subd2 setCKVAnPhase:@"<200"];
    [subd2 setSnCSTD:30];
    [defaultsubds addObject:subd2];
    
    TFCSUBD * subd3 = [[TFCSUBD alloc]init];
    [subd3 setCKVAnPhase:@"<275"];
    [subd3 setSnCSTD:40];   
    [defaultsubds addObject:subd3];
    
    TFCSUBD * subd4 = [[TFCSUBD alloc]init];
    [subd4 setCKVAnPhase:@"<350"];
    [subd4 setSnCSTD:50];
    [defaultsubds addObject:subd4];
    
    TFCSUBD * subd5 = [[TFCSUBD alloc]init];
    [subd5 setCKVAnPhase:@"<450"];
    [subd5 setSnCSTD:65];
    [defaultsubds addObject:subd5];
    
    TFCSUBD * subd6 = [[TFCSUBD alloc]init];
    [subd6 setCKVAnPhase:@"<573"];
    [subd6 setSnCSTD:80];
    [defaultsubds addObject:subd6];
    
    NSData* myDataArrayPhase = [NSKeyedArchiver archivedDataWithRootObject:defaultsubds];
    [UICKeyChainStore setData:myDataArrayPhase forKey:@"SystemDefaultsArraySUBD"];
}

+(void)setDeafultTRCImpedance{
    TRCImpedance * impedance = [[TRCImpedance alloc]init];
    
    NSMutableArray *defaultimpedances = [[NSMutableArray alloc]init];
    [impedance setKVA :50];
    [impedance setV208:2.90];
    [impedance setV480:2.60];
    [defaultimpedances addObject:impedance];
    
    TRCImpedance * impedance2 = [[TRCImpedance alloc]init];
    [impedance2 setKVA :75];
    [impedance2 setV208:2.90];
    [impedance2 setV480:2.60];
    [defaultimpedances addObject:impedance2];
    
    TRCImpedance * impedance3 = [[TRCImpedance alloc]init];
    [impedance3 setKVA :112.5];
    [impedance3 setV208:3.00];
    [impedance3 setV480:2.60];
    [defaultimpedances addObject:impedance3];
    
    
    TRCImpedance * impedance4 = [[TRCImpedance alloc]init];
    [impedance4 setKVA :150];
    [impedance4 setV208:3.00];
    [impedance4 setV480:2.60];
    [defaultimpedances addObject:impedance4];
    
    TRCImpedance * impedance5 = [[TRCImpedance alloc]init];
    [impedance5 setKVA :300];
    [impedance5 setV208:4.70];
    [impedance5 setV480:2.60];
    [defaultimpedances addObject:impedance5];
    
    TRCImpedance * impedance6 = [[TRCImpedance alloc]init];
    [impedance6 setKVA :500];
    [impedance6 setV208:4.70];
    [impedance6 setV480:4.30];
    [defaultimpedances addObject:impedance6];
    
    TRCImpedance * impedance7 = [[TRCImpedance alloc]init];
    [impedance7 setKVA :750];
    [impedance7 setV208:5.75];
    [impedance7 setV480:5.75];
    [defaultimpedances addObject:impedance7];
    
    TRCImpedance * impedance8 = [[TRCImpedance alloc]init];
    [impedance8 setKVA :1000];
    [impedance8 setV208:5.75];
    [impedance8 setV480:5.75];
    [defaultimpedances addObject:impedance8];
    
    TRCImpedance * impedance9 = [[TRCImpedance alloc]init];
    [impedance9 setKVA :1500];
    [impedance9 setV208:5.75];
    [impedance9 setV480:5.75];
    [defaultimpedances addObject:impedance9];
    
    TRCImpedance * impedance11 = [[TRCImpedance alloc]init];
    [impedance11 setKVA :2000];
    [impedance11 setV208:5.75];
    [impedance11 setV480:5.75];
    
    [defaultimpedances addObject:impedance11];
    
    TRCImpedance * impedance12 = [[TRCImpedance alloc]init];
    [impedance12 setKVA :2500];
    [impedance12 setV208:5.75];
    [impedance12 setV480:5.75];
    
    [defaultimpedances addObject:impedance12];
    
    NSData* myDataArrayPhase = [NSKeyedArchiver archivedDataWithRootObject:defaultimpedances];
    
    [UICKeyChainStore setData:myDataArrayPhase forKey:@"SystemDefaultsArrayImpedance"];
}

+(void)setDeafultWSVDWire{
    NSMutableArray *defaultWires = [[NSMutableArray alloc]init];
    
    WSVDWire * wire1 = [[WSVDWire alloc]init];
    [wire1 setWireSize:@"18/"];
    [wire1 setAmpacity:6];
    [wire1 setOhms:0.006385];
    [wire1 setCirc:1620];
    [defaultWires addObject:wire1];
    
    WSVDWire * wire2 = [[WSVDWire alloc]init];
    [wire2 setWireSize:@"16/"];
    [wire2 setAmpacity:10.0];
    [wire2 setOhms:0.004016];
    [wire2 setCirc:2580];
    [defaultWires addObject:wire2];
    
    WSVDWire * wire3 = [[WSVDWire alloc]init];
    [wire3 setWireSize:@"14"];
    [wire3 setOhms:0.002525];
    [wire3 setAmpacity:15.00];
    [wire3 setCirc:4110];
    [defaultWires addObject:wire3];
    
    WSVDWire * wire4 = [[WSVDWire alloc]init];
    [wire4 setWireSize:@"12"];
    [wire4 setOhms:0.001588];
    [wire4 setAmpacity:20];
    [wire4 setCirc:6530];
    [defaultWires addObject:wire4];
    
    WSVDWire * wire5 = [[WSVDWire alloc]init];
    [wire5 setWireSize:@"10"];
    [wire5 setOhms:0.000999];
    [wire5 setAmpacity:30];
    [wire5 setCirc:10380];
    [defaultWires addObject:wire5];
    
    WSVDWire * wire6 = [[WSVDWire alloc]init];
    [wire6 setWireSize:@"8"];
    [wire6 setOhms:0.000628];
    [wire6 setAmpacity:50];
    [wire6 setCirc:16510];
    [defaultWires addObject:wire6];
    
    WSVDWire * wire7 = [[WSVDWire alloc]init];
    [wire7 setWireSize:@"6"];
    [wire7 setOhms:0.000395];
    [wire7 setAmpacity:65];
    [wire7 setCirc:26240.00];
    [defaultWires addObject:wire7];
    
    WSVDWire * wire8 = [[WSVDWire alloc]init];
    [wire8 setWireSize:@"4"];
    [wire8 setOhms:0.000249];
    [wire8 setAmpacity:85];
    [wire8 setCirc:41740.00];
    [defaultWires addObject:wire8];
    
    WSVDWire * wire9 = [[WSVDWire alloc]init];
    [wire9 setWireSize:@"3"];
    [wire9 setOhms:0.000197];
    [wire9 setAmpacity:100];
    [wire9 setCirc:52620.00];
    [defaultWires addObject:wire9];
    
    WSVDWire * wire10 = [[WSVDWire alloc]init];
    [wire10 setWireSize:@"2"];
    [wire10 setOhms:0.000156];
    [wire10 setAmpacity:115];
    [wire10 setCirc:66360.00];
    [defaultWires addObject:wire10];
    
    WSVDWire * wire11 = [[WSVDWire alloc]init];
    [wire11 setWireSize:@"1"];
    [wire11 setOhms:0.0001239];
    [wire11 setAmpacity:130];
    [wire11 setCirc:83690.00];
    [defaultWires addObject:wire11];
    
    WSVDWire * wire12 = [[WSVDWire alloc]init];
    [wire12 setWireSize:@"0"];
    [wire12 setOhms:0.000098];
    [wire12 setAmpacity:150];
    [wire12 setCirc:105600.00];
    [defaultWires addObject:wire12];
    
    WSVDWire * wire13 = [[WSVDWire alloc]init];
    [wire13 setWireSize:@"00"];
    [wire13 setOhms:0.000078];
    [wire13 setAmpacity:175];
    [wire13 setCirc:133100.00];
    [defaultWires addObject:wire13];
    
    WSVDWire * wire14 = [[WSVDWire alloc]init];
    [wire14 setWireSize:@"000"];
    [wire14 setOhms:0.000062];
    [wire14 setAmpacity:200];
    [wire14 setCirc:167800.00];
    [defaultWires addObject:wire14];
    
    WSVDWire * wire15 = [[WSVDWire alloc]init];
    [wire15 setWireSize:@"0000"];
    [wire15 setOhms:0.000049];
    [wire15 setAmpacity:230];
    [wire15 setCirc:211600.00];
    [defaultWires addObject:wire15];
    
    WSVDWire * wire16 = [[WSVDWire alloc]init];
    [wire16 setWireSize:@"250"];
    [wire16 setAmpacity:0.0];
    [wire16 setOhms:0.0];
    [wire16 setCirc:250000.00];
    [defaultWires addObject:wire16];
    
    WSVDWire * wire17 = [[WSVDWire alloc]init];
    [wire17 setWireSize:@"350"];
    [wire17 setAmpacity:0.0];
    [wire17 setOhms:0.0];
    [wire17 setCirc:350000.00];
    [defaultWires addObject:wire17];
    
    WSVDWire * wire18 = [[WSVDWire alloc]init];
    [wire18 setWireSize:@"500"];
    [wire18 setAmpacity:0.0];
    [wire18 setOhms:0.0];
    [wire18 setCirc:500000.00];
    [defaultWires addObject:wire18];
    
    WSVDWire * wire19 = [[WSVDWire alloc]init];
    [wire19 setWireSize:@"750"];
    [wire19 setAmpacity:0.0];
    [wire19 setOhms:0.0];
    [wire19 setCirc:750000.00];
    [defaultWires addObject:wire19];
    
    
    NSData* myDataArrayPhase = [NSKeyedArchiver archivedDataWithRootObject:defaultWires];
    [UICKeyChainStore setData:myDataArrayPhase forKey:@"SystemDefaultsArrayWire"];
}


@end
