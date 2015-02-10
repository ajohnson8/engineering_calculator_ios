//
//  TransformerFuseCalcFormula.m
//  Electrical Calculator
//
//  Created by Paul Marney on 2/5/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "TransformerFuseCalcFormula.h"

@interface TransformerFuseCalcFormula () {
    BOOL _config;
}

@end

@implementation TransformerFuseCalcFormula

#pragma mark - Life Cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [_typeLbl setText:@"UG"];
    UIBarButtonItem * configure = [[UIBarButtonItem alloc]initWithTitle:@"Configure" style:UIBarButtonItemStylePlain target:self action:@selector(pressedConfig:)];
    
    BOOL boolValue = [[UICKeyChainStore stringForKey:@"FormulaConfiguration"] boolValue];
    
    if (!boolValue) {
        _config = NO;
        [_defaultBtn setTitle:@"Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addFuseBtn setHidden:YES];
        [_addFuseBtn setEnabled:NO];
        [configure setTitle:@"Configure"];
        [[self.navigationController.viewControllers.lastObject navigationItem] setRightBarButtonItem:configure];
        [self.navigationController.viewControllers.lastObject setTitle:@"Transformer Rating"];
    }else {
        _config = YES;
        [_defaultBtn setTitle:@"Set Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addFuseBtn setHidden:NO];
        [_addFuseBtn setEnabled:YES];
        [configure setTitle:@"Done"];
        [[self.navigationController.viewControllers.lastObject navigationItem] setRightBarButtonItem:configure];
        [self.navigationController.viewControllers.lastObject setTitle:@"Transformer Rating Configuration"];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_typeSmc.selectedSegmentIndex) {
        case 0:
            return _transformerFuseCalcV.ugs.count+1;
            break;
        case 1:
            return _transformerFuseCalcV.ohs.count+1;
            break;
        case 2:
            return _transformerFuseCalcV.subds.count+1;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0 && !_config){
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        switch (_typeSmc.selectedSegmentIndex) {
            case 0:
            case 1:
                [cell.textLabel setText:@"kVA"];
                break;
            case 2:
                [cell.textLabel setText:@"kVA/Phase"];
                break;
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    } else if (indexPath.row == 0){
        
        static NSString *simpleTableIdentifier = @"Celllabels";
        TransformerFuseLabelCell *cell = (TransformerFuseLabelCell *)[_fuseTV dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Celllabels" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        
        if (_typeSmc.selectedSegmentIndex == 0) {
            [cell.attribute1Lbl setText:@"KVA"];
            [cell.attribute2Lbl setText:@"BAYONET"];
            [cell.attribute3Lbl setText:@"NX"];
            [cell.attribute4Lbl setText:@"S&C SM"];
        } else if (_typeSmc.selectedSegmentIndex == 1) {
            [cell.attribute1Lbl setText:@"KVA"];
            [cell.attribute2Lbl setText:@"NX Comp II"];
            [cell.attribute2Lbl setAdjustsFontSizeToFitWidth:YES];
            [cell.attribute3Lbl setText:@"S&C"];
            [cell.attribute4Lbl setText:@"S&C Mult"];
        }else if (_typeSmc.selectedSegmentIndex == 2) {
            [cell.attribute1Lbl setText:@"KVA/Phase"];
            [cell.attribute1Lbl setAdjustsFontSizeToFitWidth:YES];
            [cell.attribute2Lbl setText:@"S&C STD"];
            [cell.attribute3Lbl setText:@""];
            [cell.attribute4Lbl setText:@""];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    }else {
        if (_config) {
            static NSString *simpleTableIdentifier = @"Celltexts";
            TransformerFuseEditCell *cell = (TransformerFuseEditCell *)[_fuseTV dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Celltexts" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            if (_typeSmc.selectedSegmentIndex == 0) {
                TFCUG *temp = _transformerFuseCalcV.ugs[indexPath.row-1];
                [cell.attribute1Txt setText:temp.KVA];
                [cell.attribute2Txt setText:[self roundingUp:temp.Bayonet andDecimalPlace:2]];
                [cell.attribute3Txt setText:temp.NX];
                [cell.attribute4Txt setText:temp.SnCSM];
            } else if (_typeSmc.selectedSegmentIndex == 1) {
                TFCOH *temp = _transformerFuseCalcV.ohs[indexPath.row-1];
                [cell.attribute1Txt setText:[self roundingUp:temp.KVA andDecimalPlace:2]];
                [cell.attribute2Txt setText:temp.NXCompII];
                [cell.attribute2Txt setAdjustsFontSizeToFitWidth:YES];
                [cell.attribute3Txt setText:[self roundingUp:temp.SnC andDecimalPlace:2]];
                [cell.attribute4Txt setText:[self roundingUp:temp.MultSnC andDecimalPlace:2]];
            }else if (_typeSmc.selectedSegmentIndex == 2) {
                TFCSUBD *temp = _transformerFuseCalcV.subds[indexPath.row-1];
                [cell.attribute1Txt setText:temp.CKVAnPhase];
                [cell.attribute1Txt setAdjustsFontSizeToFitWidth:YES];
                [cell.attribute2Txt setText:[self roundingUp:temp.SnCSTD andDecimalPlace:2]];
                [cell.attribute3Txt setText:@""];
                [cell.attribute4Txt setText:@""];
            }
            
            [cell.attribute1Txt setDelegate:cell];
            [cell.attribute2Txt setDelegate:cell];
            [cell.attribute3Txt setDelegate:cell];
            [cell.attribute4Txt setDelegate:cell];
            [cell setDelegate:self];
            [cell setTag:indexPath.row-1];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            
            
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            
            if (_typeSmc.selectedSegmentIndex == 0) {
                TFCUG *temp = _transformerFuseCalcV.ugs[indexPath.row-1];
                [cell.textLabel setText:[NSString stringWithFormat:@"%@",temp.KVA]];
            } else if (_typeSmc.selectedSegmentIndex == 1) {
                TFCOH *temp = _transformerFuseCalcV.ohs[indexPath.row-1];
                [cell.textLabel setText:[self roundingUp:temp.KVA andDecimalPlace:1]];
            }else if (_typeSmc.selectedSegmentIndex == 2) {
                TFCSUBD *temp = _transformerFuseCalcV.subds[indexPath.row-1];
                [cell.textLabel setText:temp.CKVAnPhase];
            }
            return cell;
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return NO;
    }
    return _config;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id temp;
        switch (_typeSmc.selectedSegmentIndex) {
            case 0:
                //UG
                temp  = _transformerFuseCalcV.ugs[indexPath.row-1];
                [_transformerFuseCalcV deleteTFCUGs:temp];
                break;
            case 1:
                //OH
                temp = _transformerFuseCalcV.ohs[indexPath.row-1];
                [_transformerFuseCalcV deleteTFCOHs:temp];
                break;
            case 2:
                //SUBD
                temp  = _transformerFuseCalcV.subds[indexPath.row-1];
                [_transformerFuseCalcV deleteTFCSUBD:temp];
                break;
        }
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationLeft];
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!_config && indexPath.row != 0) {
        if (_typeSmc.selectedSegmentIndex == 0) {
            TFCUG *temp = _transformerFuseCalcV.ugs[indexPath.row-1];
            [self calulateTotal:temp];
        } else if (_typeSmc.selectedSegmentIndex == 1) {
            TFCOH *temp = _transformerFuseCalcV.ohs[indexPath.row-1];
            [self calulateTotal:temp];
        }else if (_typeSmc.selectedSegmentIndex == 2) {
            TFCSUBD *temp = _transformerFuseCalcV.subds[indexPath.row-1];
            [self calulateTotal:temp];
        }
    }
}

#pragma mark - IBActions

- (IBAction)pressedConfig:(id)sender {
    
    [UIView transitionWithView:self.view
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{ }
                    completion:NULL];
    
    BOOL boolValue = [[UICKeyChainStore stringForKey:@"FormulaConfiguration"] boolValue];
    [self.view endEditing:YES];
    
    if (boolValue) {
        _config = NO;
        [UICKeyChainStore setString:@"NO" forKey:@"FormulaConfiguration"];
        [_defaultBtn setTitle:@"Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addFuseBtn setHidden:YES];
        [_addFuseBtn setEnabled:NO];
        [self.navigationController.viewControllers.lastObject setTitle:@"Transformer Rating"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Configure"];
    }else {
        _config = YES;
        [UICKeyChainStore setString:@"YES" forKey:@"FormulaConfiguration"];
        [_defaultBtn setTitle:@"Set Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addFuseBtn setHidden:NO];
        [_addFuseBtn setEnabled:YES];
        [self.navigationController.viewControllers.lastObject setTitle:@"Transformer Rating Configuration"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Done"];
    }
    [_fuseTV deselectRowAtIndexPath:[_fuseTV indexPathForSelectedRow] animated:YES];
    [_fuseTV reloadData];
}

- (IBAction)addFuseAction:(id)sender {
    [_fuseTV endEditing:YES];
    id temp;
    switch (_typeSmc.selectedSegmentIndex) {
        case 0:
            //UG
            temp  = [[TFCUG alloc]init];
            [_transformerFuseCalcV addTFCUG:temp];
            break;
        case 1:
            //OH
            temp  = [[TFCOH alloc]init];
            [_transformerFuseCalcV addTFCOHs:temp];
            break;
        case 2:
            //SUBD
            temp  = [[TFCSUBD alloc]init];
            [_transformerFuseCalcV addTFCSUBD:temp];
            break;
    }
    [_fuseTV reloadData];
    [_addFuseBtn setEnabled:NO];
}

- (IBAction)resetDefaults:(id)sender {
    
    if (_config) {
        
        NSData* myDataArrayUG = [NSKeyedArchiver archivedDataWithRootObject:[_transformerFuseCalcV ugs]];;
        NSData* myDataArrayOH = [NSKeyedArchiver archivedDataWithRootObject:[_transformerFuseCalcV ohs]];
        NSData* myDataArraySUBD = [NSKeyedArchiver archivedDataWithRootObject:[_transformerFuseCalcV subds]];
        
        [UICKeyChainStore setData:myDataArrayUG forKey:@"SystemDefaultsArrayUG"];
        [UICKeyChainStore setData:myDataArrayOH forKey:@"SystemDefaultsArrayOH"];
        [UICKeyChainStore setData:myDataArraySUBD forKey:@"SystemDefaultsArraySUBD"];
        
        [TSMessage showNotificationInViewController:self.navigationController.viewControllers.lastObject title:@"Transformer Fuse" subtitle:@"Defaults has been save." type:TSMessageNotificationTypeSuccess duration:1.5];
        
        [_addFuseBtn setHidden:_config];
        [_addFuseBtn setEnabled:!_config];
        
    }else {
        NSData* myDataArrayUG = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayUG"];
        NSData* myDataArrayOH = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayOH"];
        NSData* myDataArraySUBD = [UICKeyChainStore dataForKey:@"SystemDefaultsArraySUBD"];
        NSMutableArray* defaultUG = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayUG];
        NSMutableArray* defaultOH = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayOH];
        NSMutableArray* defaultSUBD = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArraySUBD];
        
        [_transformerFuseCalcV setDefaultsTFCOH:defaultOH];
        [_transformerFuseCalcV setDefaultsTFCUG:defaultUG];
        [_transformerFuseCalcV setDefaultsTFCSUBD:defaultSUBD];
        
        [_fuseTV setDataSource:self];
        [_fuseTV setDelegate:self];
        
        [_fuseTV deselectRowAtIndexPath:[_fuseTV indexPathForSelectedRow] animated:YES];
        
        [_addFuseBtn setHidden:_config];
        [_addFuseBtn setEnabled:!_config];
        
        [_addFuseBtn setHidden:YES];
        [_addFuseBtn setEnabled:NO];
        
        [_title1Lbl setText:@""];
        [_title2Lbl setText:@""];
        [_title3Lbl setText:@""];
        [_title4Lbl setText:@""];
        [_attribute1Lbl setText:@""];
        [_attribute2Lbl setText:@""];
        [_attribute3Lbl setText:@""];
        [_attribute4Lbl setText:@""];
        
        [TSMessage showNotificationInViewController:self.navigationController.viewControllers.lastObject title:@"TransformerCalcFormula" subtitle:@"Defaults has been set." type:TSMessageNotificationTypeSuccess duration:1.5];
        
    }
    
    [_fuseTV reloadData];
}

#pragma mark -  TransformerRatingEditImpedanceCellDelegate

-(void)updateTransformerFuse:(id)fuse andIndexPath:(int)row{
    switch (_typeSmc.selectedSegmentIndex) {
        case 0:
            [_transformerFuseCalcV updateTFCUGs:fuse andIndex:row];
            break;
        case 1:
             [_transformerFuseCalcV updateTFCOH:fuse andIndex:row];
            break;
        case 2:
            [_transformerFuseCalcV updateTFCSUBD:fuse andIndex:row];
            break;
    }
}

-(void)canAddAnotherFuse:(BOOL)check{
        [_addFuseBtn setEnabled:check];
}

#pragma mark - Private Methods

-(void)initView{
    if (_transformerFuseCalcV == nil) {
        
        NSData *ug =[UICKeyChainStore dataForKey:@"SystemDefaultsArrayUG"];
        NSData *oh =[UICKeyChainStore dataForKey:@"SystemDefaultsArrayOH"];
        NSData *subd =[UICKeyChainStore dataForKey:@"SystemDefaultsArraySUBD"];
        
        _transformerFuseCalcV = [[ TransformerFuseCalcVariables alloc ]init];
        
        [_fuseTV setDataSource:self];
        [_fuseTV setDelegate:self];
        
        if (ug.length == 0 || oh.length == 0 || subd.length == 0){
            [self addUGs];
            [self addOHs];
            [self addSUBDs];
            [UICKeyChainStore setString:@"NO" forKey:@"FormulaConfiguration"];
        } else{
            NSData* myDataArrayUG = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayUG"];
            NSData* myDataArrayOH = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayOH"];
            NSData* myDataArraySUBD = [UICKeyChainStore dataForKey:@"SystemDefaultsArraySUBD"];
            NSMutableArray* defaultUG = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayUG];
            NSMutableArray* defaultOH = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayOH];
            NSMutableArray* defaultSUBD = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArraySUBD];
            
            [_transformerFuseCalcV setUgs:defaultUG];
            [_transformerFuseCalcV setOhs:defaultOH];
            [_transformerFuseCalcV setSubds:defaultSUBD];
            
            [_fuseTV setDataSource:self];
            [_fuseTV setDelegate:self];
            
            [_fuseTV deselectRowAtIndexPath:[_fuseTV indexPathForSelectedRow] animated:YES];
            [_typeSmc setSelectedSegmentIndex:0];
        }
        
    }
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
        UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        tapper.cancelsTouchesInView = NO;
        [self.view addGestureRecognizer:tapper];
    }
    [_typeSmc addTarget:self
                 action:@selector(typeChanged:)
       forControlEvents:UIControlEventValueChanged];
    
    [_typeLbl setText:@""];
    [_title1Lbl setText:@""];
    [_title2Lbl setText:@""];
    [_title3Lbl setText:@""];
    [_title4Lbl setText:@""];
    [_attribute1Lbl setText:@""];
    [_attribute2Lbl setText:@""];
    [_attribute3Lbl setText:@""];
    [_attribute4Lbl setText:@""];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

- (void)typeChanged:(id)sender{
    
    switch (_typeSmc.selectedSegmentIndex) {
        case 0:
            [_typeLbl setText:@"UG"];
            break;
        case 1:
            [_typeLbl setText:@"OH"];
            break;
        case 2:
            [_typeLbl setText:@"SUBD"];
            break;
    }
    [_title1Lbl setText:@""];
    [_title2Lbl setText:@""];
    [_title3Lbl setText:@""];
    [_title4Lbl setText:@""];
    [_attribute1Lbl setText:@""];
    [_attribute2Lbl setText:@""];
    [_attribute3Lbl setText:@""];
    [_attribute4Lbl setText:@""];
    
    [_fuseTV reloadData];
}

-(void)calulateTotal:(id)fuse{
    
    if ([fuse isKindOfClass:[TFCUG class]]) {
        TFCUG *temp = [[TFCUG alloc]init];
        temp = fuse;
        [_title2Lbl setText:@"BAYONET"];
        [_title3Lbl setText:@"NX"];
        [_title4Lbl setText:@"S&C SM"];
        [_title1Lbl setText:@"KVA"];
        [_attribute2Lbl setText:[self roundingUp:temp.Bayonet andDecimalPlace:2]];
        [_attribute3Lbl setText:[NSString stringWithFormat:@"%@",temp.NX]];
        [_attribute4Lbl setText:[NSString stringWithFormat:@"%@",temp.SnCSM]];
        [_attribute1Lbl setText:temp.KVA];
    }
    if ([fuse isKindOfClass:[TFCOH class]]) {
        TFCOH *temp = [[TFCOH alloc]init];
        temp = fuse;
        [_title1Lbl setText:@"KVA"];
        [_title2Lbl setText:@"NX Comp II"];
        [_title3Lbl setText:@"S&C"];
        [_title4Lbl setText:@"S&C Mult."];
        [_attribute1Lbl setText:[self roundingUp:temp.KVA andDecimalPlace:2]];
        [_attribute2Lbl setText:[NSString stringWithFormat:@"%@",temp.NXCompII]];
        [_attribute3Lbl setText:[self roundingUp:temp.SnC andDecimalPlace:2]];
        [_attribute4Lbl setText:[self roundingUp:temp.MultSnC andDecimalPlace:2]];
    }
    if ([fuse isKindOfClass:[TFCSUBD class]]) {
        TFCSUBD *temp = [[TFCSUBD alloc]init];
        temp = fuse;
        [_title1Lbl setText:@"KVA/Phase"];
        [_title2Lbl setText:@"S&C STD"];
        [_title3Lbl setText:@""];
        [_title4Lbl setText:@""];
        [_attribute1Lbl setText:[NSString stringWithFormat:@"%@",temp.CKVAnPhase]];
        [_attribute2Lbl setText:[self roundingUp:temp.SnCSTD andDecimalPlace:2]];
        [_attribute3Lbl setText:@""];
        [_attribute4Lbl setText:@""];
    }
    
}

-(NSString *)roundingUp:(float)num andDecimalPlace:(int)place{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:place];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    
    return [formatter stringFromNumber:[NSNumber numberWithFloat:num]];
}

-(void)addUGs{

    NSMutableArray *defaultugs = [[NSMutableArray alloc]init];
    
    TFCUG * ug = [[TFCUG alloc]init];
    [ug setKVA :@"25"];
    [ug setBayonet:8];
    [ug setNX:@""];
    [ug setSnCSM:@""];
    [_transformerFuseCalcV addTFCUG:ug];
    [defaultugs addObject:ug];
    
    TFCUG * ug1 = [[TFCUG alloc]init];
    [ug1 setKVA :@"50"];
    [ug1 setBayonet:15];
    [ug1 setNX:@""];
    [ug1 setSnCSM:@""];
    [_transformerFuseCalcV addTFCUG:ug1];
    [defaultugs addObject:ug1];
    
    TFCUG * ug2 = [[TFCUG alloc]init];
    [ug2 setKVA :@"75"];
    [ug2 setBayonet:25];
    [ug2 setNX:@""];
    [ug2 setSnCSM:@""];
    [_transformerFuseCalcV addTFCUG:ug2];
    [defaultugs addObject:ug2];
    
    TFCUG * ug3 = [[TFCUG alloc]init];
    [ug3 setKVA :@"100"];
    [ug3 setBayonet:25];
    [ug3 setNX:@""];
    [ug3 setSnCSM:@""];
    [_transformerFuseCalcV addTFCUG:ug3];
    [defaultugs addObject:ug3];
    
    TFCUG * ug4 = [[TFCUG alloc]init];
    [ug4 setKVA :@"167"];
    [ug4 setBayonet:50];
    [ug4 setNX:@""];
    [ug4 setSnCSM:@""];
    [_transformerFuseCalcV addTFCUG:ug4];
    [defaultugs addObject:ug4];
    
    TFCUG * ug5 = [[TFCUG alloc]init];
    [ug5 setKVA :@"150"];
    [ug5 setBayonet:15];
    [ug5 setNX:@""];
    [ug5 setSnCSM:@""];
    [_transformerFuseCalcV addTFCUG:ug5];
    [defaultugs addObject:ug5];
    
    TFCUG * ug6 = [[TFCUG alloc]init];
    [ug6 setKVA :@"300"];
    [ug6 setBayonet:25];
    [ug6 setNX:@""];
    [ug6 setSnCSM:@"30E"];
    [_transformerFuseCalcV addTFCUG:ug6];
    [defaultugs addObject:ug6];
    
    TFCUG * ug7 = [[TFCUG alloc]init];
    [ug7 setKVA :@"500"];
    [ug7 setBayonet:50];
    [ug7 setNX:@""];
    [ug7 setSnCSM:@"50E"];
    [_transformerFuseCalcV addTFCUG:ug7];
    [defaultugs addObject:ug7];
    
    TFCUG * ug8 = [[TFCUG alloc]init];
    [ug8 setKVA :@"750"];
    [ug8 setBayonet:65];
    [ug8 setNX:@""];
    [ug8 setSnCSM:@"80E"];
    [_transformerFuseCalcV addTFCUG:ug8];
    [defaultugs addObject:ug8];
    
    TFCUG * ug9 = [[TFCUG alloc]init];
    [ug9 setKVA :@"1000"];
    [ug9 setBayonet:65];
    [ug9 setNX:@"100A"];
    [ug9 setSnCSM:@"100E"];
    [_transformerFuseCalcV addTFCUG:ug9];
    [defaultugs addObject:ug9];
    
    TFCUG * ug10 = [[TFCUG alloc]init];
    [ug10 setKVA :@"1500"];
    [ug10 setBayonet:140];
    [ug10 setNX:@"2-65A"];
    [ug10 setSnCSM:@"150E"];
    [_transformerFuseCalcV addTFCUG:ug10];
    [defaultugs addObject:ug10];
    
    TFCUG * ug11 = [[TFCUG alloc]init];
    [ug11 setKVA :@"2000"];
    [ug11 setBayonet:0];
    [ug11 setNX:@"2-100A"];
    [ug11 setSnCSM:@"200E"];
    [_transformerFuseCalcV addTFCUG:ug11];
    [defaultugs addObject:ug11];
    
    TFCUG * ug12 = [[TFCUG alloc]init];
    [ug12 setKVA :@"2500"];
    [ug12 setBayonet:0];
    [ug12 setNX:@"2-100A"];
    [ug12 setSnCSM:@"250E"];
    [_transformerFuseCalcV addTFCUG:ug12];
    [defaultugs addObject:ug12];
    
    TFCUG * ug13 = [[TFCUG alloc]init];
    [ug13 setKVA :@"2-1500"];
    [ug13 setBayonet:0];
    [ug13 setNX:@"2-100A"];
    [ug13 setSnCSM:@"250E"];
    [_transformerFuseCalcV addTFCUG:ug13];
    [defaultugs addObject:ug13];
    
    TFCUG * ug14 = [[TFCUG alloc]init];
    [ug14 setKVA :@"2-2000"];
    [ug14 setBayonet:0];
    [ug14 setNX:@"2-100A"];
    [ug14 setSnCSM:@"300E"];
    [_transformerFuseCalcV addTFCUG:ug14];
    [defaultugs addObject:ug14];
    
    TFCUG * ug15 = [[TFCUG alloc]init];
    [ug15 setKVA :@"2-2500"];
     [ug15 setBayonet:0];
     [ug15 setNX:@"2-100A"];
     [ug15 setSnCSM:@"400E"];
     [_transformerFuseCalcV addTFCUG:ug15];
     [defaultugs addObject:ug15];
    
    
    NSData* myDataArrayPhase = [NSKeyedArchiver archivedDataWithRootObject:defaultugs];
    [UICKeyChainStore setData:myDataArrayPhase forKey:@"SystemDefaultsArrayUG"];
}

-(void)addOHs{
    
    NSMutableArray *defaultohs = [[NSMutableArray alloc]init];
    
    TFCOH * oh0 = [[TFCOH alloc]init];
    [oh0 setKVA :5];
    [oh0 setNXCompII:@"12k"];
    [oh0 setSnC:5];
    [oh0 setMultSnC:5];
    [_transformerFuseCalcV addTFCOHs:oh0];
    [defaultohs addObject:oh0];
    
    
    TFCOH * oh1 = [[TFCOH alloc]init];
    [oh1 setKVA :10];
    [oh1 setNXCompII:@"12k"];
    [oh1 setSnC:5];
    [oh1 setMultSnC:5];
    [_transformerFuseCalcV addTFCOHs:oh1];
    [defaultohs addObject:oh1];
    
    TFCOH * oh2 = [[TFCOH alloc]init];
    [oh2 setKVA :15];
    [oh2 setNXCompII:@"12k"];
    [oh2 setSnC:5];
    [oh2 setMultSnC:5];
    [_transformerFuseCalcV addTFCOHs:oh2];
    [defaultohs addObject:oh2];
    
    TFCOH * oh3 = [[TFCOH alloc]init];
    [oh3 setKVA :25];
    [oh3 setNXCompII:@"12k"];
    [oh3 setSnC:7];
    [oh3 setMultSnC:7];
    [_transformerFuseCalcV addTFCOHs:oh3];
    [defaultohs addObject:oh3];
    
    TFCOH * oh4 = [[TFCOH alloc]init];
    [oh4 setKVA :37.5];
    [oh4 setNXCompII:@"12k"];
    [oh4 setSnC:10];
    [oh4 setMultSnC:10];
    [_transformerFuseCalcV addTFCOHs:oh4];
    [defaultohs addObject:oh4];
    
    TFCOH * oh5 = [[TFCOH alloc]init];
    [oh5 setKVA :50];
    [oh5 setNXCompII:@"25k"];
    [oh5 setSnC:10];
    [oh5 setMultSnC:10];
    [_transformerFuseCalcV addTFCOHs:oh5];
    [defaultohs addObject:oh5];
    
    TFCOH * oh6 = [[TFCOH alloc]init];
    [oh6 setKVA :75];
    [oh6 setNXCompII:@"25k"];
    [oh6 setSnC:15];
    [oh6 setMultSnC:15];
    [_transformerFuseCalcV addTFCOHs:oh6];
    [defaultohs addObject:oh6];
    
    TFCOH * oh7 = [[TFCOH alloc]init];
    [oh7 setKVA :100];
    [oh7 setNXCompII:@"40k"];
    [oh7 setSnC:20];
    [oh7 setMultSnC:15];
    [_transformerFuseCalcV addTFCOHs:oh7];
    [defaultohs addObject:oh7];
    
    TFCOH * oh8 = [[TFCOH alloc]init];
    [oh8 setKVA :125];
    [oh8 setNXCompII:@""];
    [oh8 setSnC:0];
    [oh8 setMultSnC:20];
    [_transformerFuseCalcV addTFCOHs:oh8];
    [defaultohs addObject:oh8];
    
    TFCOH * oh9 = [[TFCOH alloc]init];
    [oh9 setKVA :150];
    [oh9 setNXCompII:@""];
    [oh9 setSnC:0];
    [oh9 setMultSnC:25];
    [_transformerFuseCalcV addTFCOHs:oh9];
    [defaultohs addObject:oh9];
    
    TFCOH * oh10 = [[TFCOH alloc]init];
    [oh10 setKVA :175];
    [oh10 setNXCompII:@""];
    [oh10 setSnC:0];
    [oh10 setMultSnC:30];
    [_transformerFuseCalcV addTFCOHs:oh10];
    [defaultohs addObject:oh10];
    
    TFCOH * oh11 = [[TFCOH alloc]init];
    [oh11 setKVA :200];
    [oh11 setNXCompII:@""];
    [oh11 setSnC:0];
    [oh11 setMultSnC:30];
    [_transformerFuseCalcV addTFCOHs:oh11];
    [defaultohs addObject:oh11];
    
    TFCOH * oh12 = [[TFCOH alloc]init];
    [oh12 setKVA :225];
    [oh12 setNXCompII:@""];
    [oh12 setSnC:0];
    [oh12 setMultSnC:40];
    [_transformerFuseCalcV addTFCOHs:oh12];
    [defaultohs addObject:oh12];
    
    TFCOH * oh13 = [[TFCOH alloc]init];
    [oh13 setKVA :250];
    [oh13 setNXCompII:@""];
    [oh13 setSnC:0];
    [oh13 setMultSnC:40];
    [_transformerFuseCalcV addTFCOHs:oh13];
    [defaultohs addObject:oh13];
    
    TFCOH * oh14 = [[TFCOH alloc]init];
    [oh14 setKVA :275];
    [oh14 setNXCompII:@""];
    [oh14 setSnC:0];
    [oh14 setMultSnC:50];
    [_transformerFuseCalcV addTFCOHs:oh14];
    [defaultohs addObject:oh14];
    
    TFCOH * oh15 = [[TFCOH alloc]init];
    [oh15 setKVA :300];
    [oh15 setNXCompII:@""];
    [oh15 setSnC:0];
    [oh15 setMultSnC:50];
    [_transformerFuseCalcV addTFCOHs:oh15];
    [defaultohs addObject:oh15];
    
    NSData* myDataArrayPhase = [NSKeyedArchiver archivedDataWithRootObject:defaultohs];
    [UICKeyChainStore setData:myDataArrayPhase forKey:@"SystemDefaultsArrayOH"];
}

-(void)addSUBDs{

    
    NSMutableArray *defaultsubds = [[NSMutableArray alloc]init];
    
    TFCSUBD * subd1 = [[TFCSUBD alloc]init];
    [subd1 setCKVAnPhase:@"<150"];
    [subd1 setSnCSTD:20];
    [_transformerFuseCalcV addTFCSUBD:subd1];
    [defaultsubds addObject:subd1];
    
    TFCSUBD * subd2 = [[TFCSUBD alloc]init];
    [subd2 setCKVAnPhase:@"<200"];
    [subd2 setSnCSTD:30];
    [_transformerFuseCalcV addTFCSUBD:subd2];
    [defaultsubds addObject:subd2];
    
    TFCSUBD * subd3 = [[TFCSUBD alloc]init];
    [subd3 setCKVAnPhase:@"<275"];
    [subd3 setSnCSTD:40];
    [_transformerFuseCalcV addTFCSUBD:subd3];
    [defaultsubds addObject:subd3];
    
    TFCSUBD * subd4 = [[TFCSUBD alloc]init];
    [subd4 setCKVAnPhase:@"<350"];
    [subd4 setSnCSTD:50];
    [_transformerFuseCalcV addTFCSUBD:subd4];
    [defaultsubds addObject:subd4];
    
    TFCSUBD * subd5 = [[TFCSUBD alloc]init];
    [subd5 setCKVAnPhase:@"<450"];
    [subd5 setSnCSTD:65];
    [_transformerFuseCalcV addTFCSUBD:subd5];
    [defaultsubds addObject:subd5];
    
    TFCSUBD * subd6 = [[TFCSUBD alloc]init];
    [subd6 setCKVAnPhase:@"<573"];
    [subd6 setSnCSTD:80];
    [_transformerFuseCalcV addTFCSUBD:subd6];
    [defaultsubds addObject:subd6];
    
    NSData* myDataArrayPhase = [NSKeyedArchiver archivedDataWithRootObject:defaultsubds];
    [UICKeyChainStore setData:myDataArrayPhase forKey:@"SystemDefaultsArraySUBD"];
    
}

@end

#pragma mark - TransformerRatingImpedanceCell

@implementation TransformerFuseLabelCell

@end

#pragma mark - TransformerRatingEditImpedanceCell

@implementation TransformerFuseEditCell
- (void)textFieldDidEndEditing:(UITextField *)textField{
    TransformerFuseCalcFormula *trans = (TransformerFuseCalcFormula *)self.delegate;
    
    switch (trans.typeSmc.selectedSegmentIndex) {
        case 0:
            [self updateUG:textField];
            break;
        case 1:
            [self updateOH:textField];
            break;
        case 2:
            [self updateSUBD:textField];
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    TransformerFuseCalcFormula *trans = (TransformerFuseCalcFormula *)self.delegate;
    NSRegularExpression *regex;
    switch (trans.typeSmc.selectedSegmentIndex) {
        case 0:
            regex = [self editUG:textField];
            break;
        case 1:
            regex = [self editOH:textField];
            break;
        case 2:
            regex = [self editSUBD:textField];
            break;
    }
    
    NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
    BOOL x = (match != nil);
    [[self delegate]canAddAnotherFuse:(x && s.length>0)];
    return x;
}

-(void)OneAtATime{
    [[self delegate]canAddAnotherFuse:NO];
}

-(void)updateUG:(UITextField *)textField{
    TFCUG * fuse = [[ TFCUG alloc]init];
    if (textField == self.attribute1Txt)
        [fuse setKVA:textField.text];
    else
        [fuse setKVA:self.attribute1Txt.text];
    
    if (textField == self.attribute2Txt)
        [fuse setBayonet:[textField.text floatValue]];
    else
        [fuse setBayonet:[self.attribute2Txt.text floatValue]];
    if (textField == self.attribute3Txt)
        [fuse setNX:textField.text];
    else
        [fuse setNX:self.attribute3Txt.text];
    if (textField == self.attribute4Txt)
        [fuse setSnCSM:textField.text];
    else
        [fuse setSnCSM:self.attribute4Txt.text];
    
    [[self delegate] updateTransformerFuse:fuse andIndexPath:self.tag];
    
}

-(void)updateOH:(UITextField *)textField{
    TFCOH * fuse = [[ TFCOH alloc]init];
    if (textField == self.attribute1Txt)
        [fuse setKVA:[textField.text floatValue]];
    else
        [fuse setKVA:[self.attribute1Txt.text floatValue]];
    
    if (textField == self.attribute2Txt)
        [fuse setNXCompII:textField.text];
    else
        [fuse setNXCompII:self.attribute2Txt.text];
    if (textField == self.attribute3Txt)
        [fuse setSnC:[textField.text floatValue]];
    else
        [fuse setSnC:[self.attribute3Txt.text floatValue]];
    if (textField == self.attribute4Txt)
        [fuse setMultSnC:[textField.text floatValue]];
    else
        [fuse setMultSnC:[self.attribute4Txt.text floatValue]];
    
    [[self delegate] updateTransformerFuse:fuse andIndexPath:self.tag];
}

-(void)updateSUBD:(UITextField *)textField{
    TFCSUBD * fuse = [[ TFCSUBD alloc]init];
    if (textField == self.attribute2Txt)
        [fuse setSnCSTD:[textField.text floatValue]];
    else
        [fuse setSnCSTD:[self.attribute2Txt.text floatValue]];
    
    if (textField == self.attribute1Txt)
        [fuse setCKVAnPhase:textField.text];
    else
        [fuse setCKVAnPhase:self.attribute1Txt.text];
    
    [[self delegate] updateTransformerFuse:fuse andIndexPath:self.tag];
}


-(NSRegularExpression *)editUG:(UITextField *)textField{
    if (textField == self.attribute1Txt)//floatValue
        return [NSRegularExpression regularExpressionWithPattern:@"^(\\d{0,1})?(\\-)?\\d{0,9}$" options:0 error:nil];
    if (textField == self.attribute2Txt)//floatValue
        return [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
    if (textField == self.attribute3Txt)
        return [NSRegularExpression regularExpressionWithPattern:@"^(\\d{0,1})?(\\-)?\\d{0,9}(\\A)?(\\a)?$" options:0 error:nil];
    if (textField == self.attribute4Txt)
        return [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}(\\E)?(\\e)?$" options:0 error:nil];
    return [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
}

-(NSRegularExpression *)editOH:(UITextField *)textField{
    if (textField == self.attribute1Txt)//floatValue
        return [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
    if (textField == self.attribute2Txt)
        return [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}(\\A)?$" options:0 error:nil];
    if (textField == self.attribute3Txt)//floatValue
        return [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
    if (textField == self.attribute4Txt)//floatValue
        return [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
    return [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
}

-(NSRegularExpression *)editSUBD:(UITextField *)textField{
    if (textField == self.attribute2Txt)//floatValue
        return [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
    if (textField == self.attribute1Txt)
        return [NSRegularExpression regularExpressionWithPattern:@"^(\\<)?\\d{0,9}$" options:0 error:nil];
    return [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
}
@end