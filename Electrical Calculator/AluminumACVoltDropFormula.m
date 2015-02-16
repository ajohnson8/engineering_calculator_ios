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
    
    [self configureMode];
    
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
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d*(\\.)?(\\d*)?$" options:0 error:nil];
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
    
    [self configureMode];
    [self.view endEditing:YES];
    
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
        _aluminumACVoltDropV = [[AluminumACVoltDropVariables alloc]init];
        
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
        [_wireTV reloadData];
        
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

-(void)configureMode{
    [_addFuseBtn setHidden:_config];
    [_addFuseBtn setEnabled:!_config];
    [_wireResistivityTxt setEnabled:_config];
    if (_config) {
        _config = NO;
        [_wireResistivityTxt setTextColor:[UIColor grayColor]];
        [UICKeyChainStore setString:@"NO" forKey:@"FormulaConfiguration"];
        [_defaultBtn setTitle:@"Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addFuseBtn setHidden:YES];
        [_addFuseBtn setEnabled:NO];
        [_wireResistivityTxt setEnabled:_config];
        [self.navigationController.viewControllers.lastObject setTitle:@"Transformer Rating"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Configure"];
        [_wireResistivityTxt setTextColor:[UIColor grayColor]];
    }else{
        _config = YES;
        [UICKeyChainStore setString:@"YES" forKey:@"FormulaConfiguration"];
        [_defaultBtn setTitle:@"Set Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addFuseBtn setHidden:NO];
        [_addFuseBtn setEnabled:YES];
        [_wireResistivityTxt setEnabled:_config];
        [self.navigationController.viewControllers.lastObject setTitle:@"Transformer Rating Configuration"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Done"];
        [_wireResistivityTxt setTextColor:[UIColor blackColor]];
    }
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
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}[/]?\\d{0,9}$" options:0 error:nil];
        NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
        BOOL x = (match != nil);
        [[self delegate]canAddAnotherWire:(x && s.length>0)];
        return x;
    }else {
        s = [s stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d*$"  options:0 error:nil];
        NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
        BOOL x = (match != nil);
        
        if (x) {
            [[self delegate]canAddAnotherWire:(s.length>0)];
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[s floatValue]]];
            [textField setText:formattedNumberString];
            return NO;
        }
        return x;
    }
}

-(void)OneAtATime{
    [[self delegate]canAddAnotherWire:NO];
}
@end