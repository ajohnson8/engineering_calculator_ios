//
//  AluminumACVoltDropFormula.m
//  Electrical Calculator
//
//  Created by Paul Marney on 2/10/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "AluminumACVoltDropFormula.h"

@interface AluminumACVoltDropFormula (){
    BOOL _config;
}

@end

@implementation AluminumACVoltDropFormula


#pragma mark - Life Cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [_lengthTxt setDelegate:self];
    [_cirtCurrentTxt setDelegate:self];
    [_cirtVoltTxt setDelegate:self];
    [_wireResistivityTxt setDelegate:self];
    
    UIBarButtonItem * configure = [[UIBarButtonItem alloc]initWithTitle:@"Configure" style:UIBarButtonItemStylePlain target:self action:@selector(pressedConfig:)];
    
    BOOL boolValue = [[UICKeyChainStore stringForKey:@"FormulaConfiguration"] boolValue];
    if (!boolValue) {
        _config = NO;
        [_defaultBtn setTitle:@"Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addFuseBtn setHidden:YES];
        [_addFuseBtn setEnabled:NO];
        [_wireResistivityTxt setEnabled:_config];
        [configure setTitle:@"Configure"];
        [[self.navigationController.viewControllers.lastObject navigationItem] setRightBarButtonItem:configure];
        [self.navigationController.viewControllers.lastObject setTitle:@"Aluminum AC Volt Drop"];
    }else {
        _config = YES;
        [_defaultBtn setTitle:@"Set Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addFuseBtn setHidden:NO];
        [_addFuseBtn setEnabled:YES];
        [_wireResistivityTxt setEnabled:_config];
        [configure setTitle:@"Done"];
        [[self.navigationController.viewControllers.lastObject navigationItem] setRightBarButtonItem:configure];
        [self.navigationController.viewControllers.lastObject setTitle:@"Aluminum AC Volt Drop Configuration"];
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == _phaseTV)
        return @"Phase Table";
    else if (tableView == _wireTV)
        return @"Wires";
    return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _phaseTV)
        return 2;
    else if (tableView == _wireTV)
        return _aluminumACVoltDropV.wires.count+1;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _phaseTV){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        if (indexPath.row == 0)
            [cell.textLabel setText:@"Phase 1"];
        else
            [cell.textLabel setText:@"Phase 3"];
        
        return cell;
    }
    else if (tableView == _wireTV){
        if (indexPath.row==0) {
            static NSString *simpleTableIdentifier = @"Cell";
            AluminumACVoltageDropLabelCell *cell = (AluminumACVoltageDropLabelCell *)[_wireTV dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            
            [cell.wireSizeLbl setText:@"WireSizes"];
            [cell.wireSizeLbl setAdjustsFontSizeToFitWidth:YES];
            [cell.conductorSectionLbl setText:@"CM"];
            [cell.conductorSectionLbl setAdjustsFontSizeToFitWidth:YES];
            [cell setTag:indexPath.row];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }else{
            if (_config) {
                static NSString *simpleTableIdentifier = @"CellEdit";
                AluminumACVoltageDropEditCell *cell = (AluminumACVoltageDropEditCell *)[_wireTV dequeueReusableCellWithIdentifier:simpleTableIdentifier];
                if (cell == nil)
                {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CellEdit" owner:self options:nil];
                    cell = [nib objectAtIndex:0];
                }
                
                WSVDWire *temp = _aluminumACVoltDropV.wires[indexPath.row-1];
                
                [cell.wireSizeTxt setText:temp.wireSize];
                [cell.ampacityTxt setText:[self roundingUp:temp.circ andDecimalPlace:0]];
                [cell.ampacityTxt setAdjustsFontSizeToFitWidth:YES];
                
                [cell.wireSizeTxt setDelegate:cell];
                [cell.ampacityTxt setDelegate:cell];
                [cell setDelegate:self];
                
                [cell setTag:indexPath.row-1];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;

            }else{
                static NSString *simpleTableIdentifier = @"Cell";
                AluminumACVoltageDropLabelCell *cell = (AluminumACVoltageDropLabelCell *)[_wireTV dequeueReusableCellWithIdentifier:simpleTableIdentifier];
                if (cell == nil)
                {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
                    cell = [nib objectAtIndex:0];
                }
                
                WSVDWire *temp = _aluminumACVoltDropV.wires[indexPath.row-1];
                
                [cell.wireSizeLbl setText:temp.wireSize];
                [cell.conductorSectionLbl setText:[self roundingUp:temp.circ andDecimalPlace:0]];
                [cell.conductorSectionLbl setAdjustsFontSizeToFitWidth:YES];
                [cell setTag:indexPath.row];
                [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
                return cell;
            }
        }
        
    }
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
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
    if (tableView ==_wireTV)
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            WSVDWire *temp = _aluminumACVoltDropV.wires[indexPath.row-1];
            [_aluminumACVoltDropV deleteWSVDWire:temp];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationLeft];
        }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView ==_wireTV && indexPath.row != 0)
        [_aluminumACVoltDropV setSelectWire:_aluminumACVoltDropV.wires[indexPath.row-1]];
    if (tableView ==_phaseTV)
        [_aluminumACVoltDropV setSelectPhase:_aluminumACVoltDropV.phases[indexPath.row]];
    [self calulateTotal];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _cirtCurrentTxt)
        [_aluminumACVoltDropV setCurrent:[NSNumber numberWithFloat:[textField.text floatValue]]];
    if (textField == _cirtVoltTxt)
       [_aluminumACVoltDropV setCirtVoltage:[NSNumber numberWithFloat:[textField.text floatValue]]];
    if (textField == _lengthTxt)
        [_aluminumACVoltDropV setOneWayLength:[NSNumber numberWithFloat:[textField.text floatValue]]];
    if (textField == _wireResistivityTxt)
        [_aluminumACVoltDropV setResistivity:[NSNumber numberWithFloat:[textField.text floatValue]]];
    [self calulateTotal];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}(\\.)?(\\d{0,9})?$" options:0 error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
    BOOL x = (match != nil);
    if (textField == _cirtCurrentTxt)
        [_aluminumACVoltDropV setCurrent:[NSNumber numberWithFloat:[textField.text floatValue]]];
    if (textField == _cirtVoltTxt)
        [_aluminumACVoltDropV setCirtVoltage:[NSNumber numberWithFloat:[textField.text floatValue]]];
    if (textField == _lengthTxt)
        [_aluminumACVoltDropV setOneWayLength:[NSNumber numberWithFloat:[textField.text floatValue]]];
    if (textField == _wireResistivityTxt)
        [_aluminumACVoltDropV setResistivity:[NSNumber numberWithFloat:[textField.text floatValue]]];
    [self calulateTotal];
    return x;
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
        [_wireResistivityTxt setEnabled:_config];
        [self.navigationController.viewControllers.lastObject setTitle:@"Transformer Rating"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Configure"];
    }else {
        _config = YES;
        [UICKeyChainStore setString:@"YES" forKey:@"FormulaConfiguration"];
        [_defaultBtn setTitle:@"Set Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addFuseBtn setHidden:NO];
        [_addFuseBtn setEnabled:YES];
        [_wireResistivityTxt setEnabled:_config];
        [self.navigationController.viewControllers.lastObject setTitle:@"Transformer Rating Configuration"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Done"];
    }
    [_wireTV deselectRowAtIndexPath:[_wireTV indexPathForSelectedRow] animated:YES];
    [_wireTV reloadData];
    
    [_phaseTV deselectRowAtIndexPath:[_phaseTV indexPathForSelectedRow] animated:YES];
    [_phaseTV reloadData];
}

- (IBAction)addImpedanceAction:(id)sender {
    [_wireTV endEditing:YES];
    WSVDWire *temp = [[WSVDWire alloc]init];
    [_aluminumACVoltDropV addWSVDWire:temp];
    [_wireTV reloadData];
    [_addFuseBtn setEnabled:NO];
}

- (IBAction)resetDefaults:(id)sender {
    
    if (_config) {
        
        NSData* myDataArrayImpedance = [NSKeyedArchiver archivedDataWithRootObject:[_aluminumACVoltDropV wires]];
        
        [UICKeyChainStore setData:myDataArrayImpedance forKey:@"SystemDefaultsArrayWire"];
        
        [TSMessage showNotificationInViewController:self.navigationController.viewControllers.lastObject title:@"AluminumACVoltDropFormula" subtitle:@"Defaults has been save." type:TSMessageNotificationTypeSuccess duration:1.5];
        
        [_addFuseBtn setHidden:_config];
        [_addFuseBtn setEnabled:!_config];
        [_wireResistivityTxt setEnabled:_config];
        
    }else {
        NSData* myDataArrayWire = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayWire"];
        NSMutableArray* defaultWires = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayWire];
        NSData* myDataArrayPhase = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayPhase"];
        NSMutableArray* defaultPhase = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayPhase];
        
        [_aluminumACVoltDropV setDefaultsWSVDWire:defaultWires];
        [_aluminumACVoltDropV setDefaultsAVDPhases:defaultPhase];
        
        [_wireTV setDataSource:self];
        [_wireTV setDelegate:self];
        [_phaseTV setDataSource:self];
        [_phaseTV setDelegate:self];
        
        [_wireTV deselectRowAtIndexPath:[_wireTV indexPathForSelectedRow] animated:YES];
        [_phaseTV deselectRowAtIndexPath:[_phaseTV indexPathForSelectedRow] animated:YES];
        
        [_addFuseBtn setHidden:_config];
        [_addFuseBtn setEnabled:!_config];
        [_wireResistivityTxt setEnabled:_config];
        
        [_typeLbl setText:@""];
        [_attributeLbl setText:@""];
        
        [TSMessage showNotificationInViewController:self.navigationController.viewControllers.lastObject title:@"TransformerCalcFormula" subtitle:@"Defaults has been set." type:TSMessageNotificationTypeSuccess duration:1.5];
        
    }
    
    [_wireTV reloadData];
    [_phaseTV reloadData];
}

#pragma mark -  TransformerRatingEditImpedanceCellDelegate

-(void)updateWire:(WSVDWire *)wire andIndexPath:(int)row{
    [_aluminumACVoltDropV updateWSVDWire:wire andIndex:row];
    [_wireTV reloadData];
}
-(void)canAddAnotherWire:(BOOL)check{
    [_addFuseBtn setEnabled:check];
}

#pragma mark - Private Methods

-(void)initView{
    if (_aluminumACVoltDropV == nil) {
        
        NSData *t =[UICKeyChainStore dataForKey:@"SystemDefaultsArrayWire"];
        NSData *y =[UICKeyChainStore dataForKey:@"SystemDefaultsArrayPhase"];
        _aluminumACVoltDropV = [[ AluminumACVoltDropVariables alloc ]init];
        
        if (t.length == 0 || y.length == 0) {
            [self addWires];
            [self addPhase];
            [_wireTV setDataSource:self];
            [_wireTV setDelegate:self];
            [_phaseTV setDataSource:self];
            [_phaseTV setDelegate:self];
            [UICKeyChainStore setString:@"NO" forKey:@"FormulaConfiguration"];
            [_wireResistivityTxt setText:@"21.2"];
            [_aluminumACVoltDropV setResistivity:[NSNumber numberWithFloat:21.2]];
            
        }else{
            NSData* myDataArrayWire = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayWire"];
            NSMutableArray* defaultWires = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayWire];
            
            NSData* myDataArrayPhase = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayPhase"];
            NSMutableArray* defaultPhase = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayPhase];
            
            if (_aluminumACVoltDropV.resistivity ==0){
                [_wireResistivityTxt setText:@"21.2"];
                [_aluminumACVoltDropV setResistivity:[NSNumber numberWithFloat:21.2]];
            }
            else
                [_wireResistivityTxt setText:[self roundingUp:[_aluminumACVoltDropV.resistivity floatValue] andDecimalPlace:2]];
            

            [_aluminumACVoltDropV setDefaultsWSVDWire:defaultWires];
            [_aluminumACVoltDropV setDefaultsAVDPhases:defaultPhase];
            
            [_phaseTV setDataSource:self];
            [_phaseTV setDelegate:self];
            
            [_wireTV setDataSource:self];
            [_wireTV setDelegate:self];
            
            [_wireTV deselectRowAtIndexPath: [_wireTV indexPathForSelectedRow] animated:YES];
            [_phaseTV deselectRowAtIndexPath:[_phaseTV indexPathForSelectedRow] animated:YES];
        }
        
    }
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
        UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        tapper.cancelsTouchesInView = NO;
        [self.view addGestureRecognizer:tapper];
    }
    
    [_typeLbl setText:@""];
    [_attributeLbl setText:@""];
    [_wireResistivityTxt setDelegate:self];
    [_cirtVoltTxt setDelegate:self];
    [_cirtCurrentTxt setDelegate:self];
    [_lengthTxt setDelegate:self];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

-(void)calulateTotal{
    int x = (int)[_phaseTV indexPathForSelectedRow].row;
    if (x == 0) {
        [_typeLbl setText:@"Single Phase Two-Wire Circuits"];
        [_attributeLbl setText:[NSString stringWithFormat:@"%f",[_aluminumACVoltDropV calulate2PhaseOne]]];
    }else {
        
        [_typeLbl setText:@"Three Phase Three-Wire Circuits"];
        [_attributeLbl setText:[NSString stringWithFormat:@"%f",[_aluminumACVoltDropV calulate1PhaseThree]]];
    }
}

-(NSString *)roundingUp:(float)num andDecimalPlace:(int)place{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:place];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    
    return [formatter stringFromNumber:[NSNumber numberWithFloat:num]];
}
-(void)addPhase{
    
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
    
    [_aluminumACVoltDropV setDefaultsAVDPhases:defaultPhase];
    
    NSData* myDataArrayPhase = [NSKeyedArchiver archivedDataWithRootObject:defaultPhase];
    
    [UICKeyChainStore setData:myDataArrayPhase forKey:@"SystemDefaultsArrayPhase"];
}
-(void)addWires{
    NSMutableArray *defaultWires = [[NSMutableArray alloc]init];
    
    WSVDWire * wire1 = [[WSVDWire alloc]init];
    [wire1 setWireSize:@"18/"];
    [wire1 setAmpacity:6];
    [wire1 setOhms:0.006385];
    [wire1 setCirc:1620];
    [_aluminumACVoltDropV addWSVDWire:wire1];
    [defaultWires addObject:wire1];
    
    WSVDWire * wire2 = [[WSVDWire alloc]init];
    [wire2 setWireSize:@"16/"];
    [wire2 setAmpacity:10.0];
    [wire2 setOhms:0.004016];
    [wire2 setCirc:2580];
    [_aluminumACVoltDropV addWSVDWire:wire2];
    [defaultWires addObject:wire2];
    
    WSVDWire * wire3 = [[WSVDWire alloc]init];
    [wire3 setWireSize:@"14"];
    [wire3 setOhms:0.002525];
    [wire3 setAmpacity:15.00];
    [wire3 setCirc:4110];
    [_aluminumACVoltDropV addWSVDWire:wire3];
    [defaultWires addObject:wire3];
    
    WSVDWire * wire4 = [[WSVDWire alloc]init];
    [wire4 setWireSize:@"12"];
    [wire4 setOhms:0.001588];
    [wire4 setAmpacity:20];
    [wire4 setCirc:6530];
    [_aluminumACVoltDropV addWSVDWire:wire4];
    [defaultWires addObject:wire4];
    
    WSVDWire * wire5 = [[WSVDWire alloc]init];
    [wire5 setWireSize:@"10"];
    [wire5 setOhms:0.000999];
    [wire5 setAmpacity:30];
    [wire5 setCirc:10380];
    [_aluminumACVoltDropV addWSVDWire:wire5];
    [defaultWires addObject:wire5];
    
    WSVDWire * wire6 = [[WSVDWire alloc]init];
    [wire6 setWireSize:@"8"];
    [wire6 setOhms:0.000628];
    [wire6 setAmpacity:50];
    [wire6 setCirc:16510];
    [_aluminumACVoltDropV addWSVDWire:wire6];
    [defaultWires addObject:wire6];
    
    WSVDWire * wire7 = [[WSVDWire alloc]init];
    [wire7 setWireSize:@"6"];
    [wire7 setOhms:0.000395];
    [wire7 setAmpacity:65];
    [wire7 setCirc:26240.00];
    [_aluminumACVoltDropV addWSVDWire:wire7];
    [defaultWires addObject:wire7];
    
    WSVDWire * wire8 = [[WSVDWire alloc]init];
    [wire8 setWireSize:@"4"];
    [wire8 setOhms:0.000249];
    [wire8 setAmpacity:85];
    [wire8 setCirc:41740.00];
    [_aluminumACVoltDropV addWSVDWire:wire8];
    [defaultWires addObject:wire8];
    
    WSVDWire * wire9 = [[WSVDWire alloc]init];
    [wire9 setWireSize:@"3"];
    [wire9 setOhms:0.000197];
    [wire9 setAmpacity:100];
    [wire9 setCirc:52620.00];
    [_aluminumACVoltDropV addWSVDWire:wire9];
    [defaultWires addObject:wire9];
    
    WSVDWire * wire10 = [[WSVDWire alloc]init];
    [wire10 setWireSize:@"2"];
    [wire10 setOhms:0.000156];
    [wire10 setAmpacity:115];
    [wire10 setCirc:66360.00];
    [_aluminumACVoltDropV addWSVDWire:wire10];
    [defaultWires addObject:wire10];
    
    WSVDWire * wire11 = [[WSVDWire alloc]init];
    [wire11 setWireSize:@"1"];
    [wire11 setOhms:0.0001239];
    [wire11 setAmpacity:130];
    [wire11 setCirc:83690.00];
    [_aluminumACVoltDropV addWSVDWire:wire11];
    [defaultWires addObject:wire11];
    
    WSVDWire * wire12 = [[WSVDWire alloc]init];
    [wire12 setWireSize:@"0"];
    [wire12 setOhms:0.000098];
    [wire12 setAmpacity:150];
    [wire12 setCirc:105600.00];
    [_aluminumACVoltDropV addWSVDWire:wire12];
    [defaultWires addObject:wire12];
    
    WSVDWire * wire13 = [[WSVDWire alloc]init];
    [wire13 setWireSize:@"00"];
    [wire13 setOhms:0.000078];
    [wire13 setAmpacity:175];
    [wire13 setCirc:133100.00];
    [_aluminumACVoltDropV addWSVDWire:wire13];
    [defaultWires addObject:wire13];
    
    WSVDWire * wire14 = [[WSVDWire alloc]init];
    [wire14 setWireSize:@"000"];
    [wire14 setOhms:0.000062];
    [wire14 setAmpacity:200];
    [wire14 setCirc:167800.00];
    [_aluminumACVoltDropV addWSVDWire:wire14];
    [defaultWires addObject:wire14];
    
    WSVDWire * wire15 = [[WSVDWire alloc]init];
    [wire15 setWireSize:@"0000"];
    [wire15 setOhms:0.000049];
    [wire15 setAmpacity:230];
    [wire15 setCirc:211600.00];
    [_aluminumACVoltDropV addWSVDWire:wire15];
    [defaultWires addObject:wire15];
    
    WSVDWire * wire16 = [[WSVDWire alloc]init];
    [wire16 setWireSize:@"250"];
    [wire16 setAmpacity:0.0];
    [wire16 setOhms:0.0];
    [wire16 setCirc:250000.00];
    [_aluminumACVoltDropV addWSVDWire:wire16];
    [defaultWires addObject:wire16];
    
    WSVDWire * wire17 = [[WSVDWire alloc]init];
    [wire17 setWireSize:@"350"];
    [wire17 setAmpacity:0.0];
    [wire17 setOhms:0.0];
    [wire17 setCirc:350000.00];
    [_aluminumACVoltDropV addWSVDWire:wire17];
    [defaultWires addObject:wire17];
    
    WSVDWire * wire18 = [[WSVDWire alloc]init];
    [wire18 setWireSize:@"500"];
    [wire18 setAmpacity:0.0];
    [wire18 setOhms:0.0];
    [wire18 setCirc:500000.00];
    [_aluminumACVoltDropV addWSVDWire:wire18];
    [defaultWires addObject:wire18];
    
    WSVDWire * wire19 = [[WSVDWire alloc]init];
    [wire19 setWireSize:@"750"];
    [wire19 setAmpacity:0.0];
    [wire19 setOhms:0.0];
    [wire19 setCirc:750000.00];
    [_aluminumACVoltDropV addWSVDWire:wire19];
    [defaultWires addObject:wire19];
    
    [_aluminumACVoltDropV setDefaultsWSVDWire:defaultWires];
    
    NSData* myDataArrayPhase = [NSKeyedArchiver archivedDataWithRootObject:defaultWires];
    
    [UICKeyChainStore setData:myDataArrayPhase forKey:@"SystemDefaultsArrayWire"];
}
@end


@implementation AluminumACVoltageDropLabelCell
@end

@implementation AluminumACVoltageDropEditCell
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    WSVDWire * updated = [[ WSVDWire alloc]init];
    if (textField == self.wireSizeTxt)
        [updated setWireSize:textField.text ];
    else
        [updated setWireSize:self.wireSizeTxt.text ];
    
    if (textField == self.ampacityTxt)
        [updated setCirc:[[textField.text stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue]];
    else
        [updated setCirc:[[self.ampacityTxt.text stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue]];

    [[self delegate]updateWire:updated andIndexPath:(int)self.tag];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.wireSizeTxt ){
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}(\\/)?(\\d{0,9})?" options:0 error:nil];
        NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
        BOOL x = (match != nil);
        [[self delegate]canAddAnotherWire:(x && s.length>0)];
        return x;
    }else {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
        NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
        BOOL x = (match != nil);
        [[self delegate]canAddAnotherWire:(x && s.length>0)];
        return x;
    }
}
-(void)OneAtATime{
    [[self delegate]canAddAnotherWire:NO];
}
@end