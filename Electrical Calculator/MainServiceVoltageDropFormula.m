//
//  AluminumACVoltDropFormula.m
//  Electrical Calculator
//
//  Created by Paul Marney on 2/10/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "MainServiceVoltageDropFormula.h"
#import "InformationViewController.h"

@interface MainServiceVoltageDropFormula (){
    BOOL _config;
    InformationViewController *_informationVC;
    NSString *_info;
}

@end

@implementation MainServiceVoltageDropFormula


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
    
    UIBarButtonItem * configure = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(pressedConfig:)];
    [[self.navigationController.viewControllers.lastObject navigationItem] setRightBarButtonItem:configure];
    
    UIBarButtonItem * back = [[UIBarButtonItem alloc]initWithTitle:@"Info" style:UIBarButtonItemStylePlain target:self action:@selector(pressedInfo:)];
    [[self.navigationController.viewControllers.lastObject navigationItem] setLeftBarButtonItem:back];
    
    [self configureMode:0];
    
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
            MainServiceVoltageDropLabelCell *cell = (MainServiceVoltageDropLabelCell *)[_wireTV dequeueReusableCellWithIdentifier:simpleTableIdentifier];
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
                MainServiceVoltageDropEditCell *cell = (MainServiceVoltageDropEditCell *)[_wireTV dequeueReusableCellWithIdentifier:simpleTableIdentifier];
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
                MainServiceVoltageDropLabelCell *cell = (MainServiceVoltageDropLabelCell *)[_wireTV dequeueReusableCellWithIdentifier:simpleTableIdentifier];
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
            if (temp.wireSize.length == 0 && temp.circ == 0)
                [self canAddAnotherWire:YES];
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
    if (textField == _wireResistivityTxt){
        
        [_aluminumACVoltDropV setResistivity:[NSNumber numberWithFloat:[textField.text floatValue]]];
    }
    [self calulateTotal];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d*(\\.)?(\\d*)?$" options:0 error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
    BOOL x = (match != nil);
    if (textField == _cirtCurrentTxt)
        [_aluminumACVoltDropV setCurrent:[NSNumber numberWithFloat:[s floatValue]]];
    if (textField == _cirtVoltTxt)
        [_aluminumACVoltDropV setCirtVoltage:[NSNumber numberWithFloat:[s floatValue]]];
    if (textField == _lengthTxt)
        [_aluminumACVoltDropV setOneWayLength:[NSNumber numberWithFloat:[s floatValue]]];
    if (textField == _wireResistivityTxt)
        [_aluminumACVoltDropV setResistivity:[NSNumber numberWithFloat:[s floatValue]]];
    [self calulateTotal];
    return x;
}

#pragma  mark - PopoverControllerDelegate
-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    return YES;
}

#pragma mark - IBActions

- (IBAction)pressedInfo:(id)sender {
    
    [self setInfo];
    _informationVC = [[InformationViewController alloc]init];
    [_informationVC setInfoTitle:@"Main Service Voltage Drop Information"];
    [_informationVC setInformation:_info];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_informationVC];
    
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)pressedConfig:(id)sender {
    
    [UIView transitionWithView:self.view
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{ }
                    completion:NULL];
    
    [self configureMode:1];
    [self.view endEditing:YES];
    
    [_wireTV deselectRowAtIndexPath:[_wireTV indexPathForSelectedRow] animated:YES];
    [_wireTV reloadData];
    
    [_phaseTV deselectRowAtIndexPath:[_phaseTV indexPathForSelectedRow] animated:YES];
    [_phaseTV reloadData];
    
    [_attribute2Lbl setText:@""];
    [_attributeLbl setText:@""];
    [_lengthTxt setText:@""];
    [_cirtCurrentTxt setText:@""];
    [_cirtVoltTxt setText:@""];
    
    [_aluminumACVoltDropV removeValues];
}

- (IBAction)addImpedanceAction:(id)sender {
    [_wireTV endEditing:YES];
    WSVDWire *temp = [[WSVDWire alloc]init];
    [_aluminumACVoltDropV addWSVDWire:temp];
    [_wireTV reloadData];
    [_addFuseBtn setEnabled:NO];
}

- (IBAction)pressedClear:(id)sender {
    [_wireTV deselectRowAtIndexPath:[_wireTV indexPathForSelectedRow] animated:YES];
    [_phaseTV deselectRowAtIndexPath:[_phaseTV indexPathForSelectedRow] animated:YES];
    
    [_typeLbl setText:@""];
    [_attributeLbl setText:@""];
    [_type2Lbl setText:@""];
    [_attribute2Lbl setText:@""];
    [_lengthTxt setText:@""];
    [_cirtCurrentTxt setText:@""];
    [_cirtVoltTxt setText:@""];
    
    [_aluminumACVoltDropV setCurrent:[NSNumber numberWithFloat:0]];
    [_aluminumACVoltDropV setCirtVoltage:[NSNumber numberWithFloat:0]];
    [_aluminumACVoltDropV setOneWayLength:[NSNumber numberWithFloat:0]];
    [_aluminumACVoltDropV setResistivity:[NSNumber numberWithFloat:0]];
}

- (IBAction)resetDefaults:(id)sender {
    
    if (_config) {
        
        NSData* myDataArrayImpedance = [NSKeyedArchiver archivedDataWithRootObject:[_aluminumACVoltDropV wires]];
        [UICKeyChainStore setData:myDataArrayImpedance forKey:@"SystemDefaultsArrayWire"];
        
        NSData* wireResist = [NSKeyedArchiver archivedDataWithRootObject:[_aluminumACVoltDropV resistivity]];
        [UICKeyChainStore setData:wireResist forKey:@"SystemDefaultsWireResist"];
        
        [TSMessage showNotificationInViewController:self.navigationController.viewControllers.lastObject title:@"MainServiceVoltageDropFormula" subtitle:@"Defaults has been save." type:TSMessageNotificationTypeSuccess duration:1.5];
        
        
        
    }else {
        NSData* myDataArrayWire = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayWire"];
        NSMutableArray* defaultWires = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayWire];
        NSData* myDataArrayPhase = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayPhase"];
        NSMutableArray* defaultPhase = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayPhase];
        NSData* wireResist = [UICKeyChainStore dataForKey:@"SystemDefaultsWireResist"];
        NSNumber* defaultWireResist = [NSKeyedUnarchiver unarchiveObjectWithData:wireResist];
        
        [_aluminumACVoltDropV setResistivity:defaultWireResist];
        [_aluminumACVoltDropV setDefaultsWSVDWire:defaultWires];
        [_aluminumACVoltDropV setDefaultsAVDPhases:defaultPhase];
        [_wireResistivityTxt setText:[self roundingUp:[defaultWireResist floatValue] andDecimalPlace:2]];
        
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

#pragma mark -  WireResistivityTypeLabelDelegate
-(void)updateResistivity:(float)resistivity{
    [_wireResistivityTxt setText:[self roundingUp:resistivity andDecimalPlace:2]];
    [_aluminumACVoltDropV setResistivity:[NSNumber numberWithFloat:resistivity]];
    if (resistivity == 0) {
        [_wireResistivityTxt setTextColor:[UIColor blackColor]];
        _wireResistivityTxt.layer.borderColor=[[UIColor blackColor]CGColor];
        _wireResistivityTxt.layer.borderWidth=1.0;
        [_wireResistivityTxt setEnabled:_config];
    }else{
        [_wireResistivityTxt setTextColor:[UIColor grayColor]];
        _wireResistivityTxt.layer.borderColor=[[UIColor clearColor]CGColor];
        _wireResistivityTxt.layer.borderWidth=1.0;
        [_wireResistivityTxt setEnabled:NO];
    }
    [_quantityPickerPopover dismissPopoverAnimated:NO];
    [self calulateTotal];
}

#pragma mark - Private Methods

-(void)initView{
    if (_aluminumACVoltDropV == nil) {
        _aluminumACVoltDropV = [[MainServiceVoltageDropVariables alloc]init];
        
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
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
        tapper.cancelsTouchesInView = NO;
        [self.view addGestureRecognizer:tapper];
    }
    [_wireResieLbl setTag:789];
    [_wireResieLbl addGestureRecognizer:tapper];
    [_wireResieLbl setUserInteractionEnabled:YES];
    [_typeLbl setText:@""];
    [_attributeLbl setText:@""];
    [_wireResistivityTxt setDelegate:self];
    [_cirtVoltTxt setDelegate:self];
    [_cirtCurrentTxt setDelegate:self];
    [_lengthTxt setDelegate:self];
}

- (void)handleSingleTap:(id) sender{
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    if (!_config && [tapRecognizer.view tag] == 789) {
        [self createQuantityPopoverList];
    }
    [self.view endEditing:YES];
}

-(void)calulateTotal{
    int x = (int)[_phaseTV indexPathForSelectedRow].row;
    [_type2Lbl setText:@"Volt Drop %"];
    [_attribute2Lbl setText:[NSString stringWithFormat:@"%@ %@",[self roundingUp:[_aluminumACVoltDropV calulateWirePercent:_aluminumACVoltDropV.phases[x]]*100 andDecimalPlace:2],@"%"]];
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

-(void)configureMode:(int)mode{
    BOOL boolValue = [[UICKeyChainStore stringForKey:@"FormulaConfiguration"] boolValue];
    if (mode == 0)
        boolValue = !boolValue;
    if (boolValue) {
        _config = NO;
        [UICKeyChainStore setString:@"NO" forKey:@"FormulaConfiguration"];
        [_defaultBtn setTitle:@"Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [self.navigationController.viewControllers.lastObject setTitle:@"Main Service Voltage Drop"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Configure"];
        [_wireResieLbl setTextColor:[UIColor blueColor]];
        _lengthTxt.layer.borderColor=[[UIColor blackColor]CGColor];
        _lengthTxt.layer.borderWidth=1.0;
        _cirtCurrentTxt.layer.borderColor=[[UIColor blackColor]CGColor];
        _cirtCurrentTxt.layer.borderWidth=1.0;
        _cirtVoltTxt.layer.borderColor=[[UIColor blackColor]CGColor];
        _cirtVoltTxt.layer.borderWidth=1.0;
        
    }else{
        _config = YES;
        [UICKeyChainStore setString:@"YES" forKey:@"FormulaConfiguration"];
        [_defaultBtn setTitle:@"Set Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [self.navigationController.viewControllers.lastObject setTitle:@"Main Service Voltage Drop Configuration"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Done"];
        [_wireResieLbl setTextColor:[UIColor blackColor]];
        _lengthTxt.layer.borderColor=[[UIColor clearColor]CGColor];
        _lengthTxt.layer.borderWidth=1.0;
        _cirtCurrentTxt.layer.borderColor=[[UIColor clearColor]CGColor];
        _cirtCurrentTxt.layer.borderWidth=1.0;
        _cirtVoltTxt.layer.borderColor=[[UIColor clearColor]CGColor];
        _cirtVoltTxt.layer.borderWidth=1.0;
    }
    [_phaseTV setUserInteractionEnabled:!_config];
    [_addFuseBtn setHidden:!_config];
    [_addFuseBtn setEnabled:_config];
    [_lengthTxt setEnabled:!_config];
    [_cirtCurrentTxt setEnabled:!_config];
    [_cirtVoltTxt setEnabled:!_config];
    [_wireResistivityTxt setTextColor:[UIColor grayColor]];
    _wireResistivityTxt.layer.borderColor=[[UIColor clearColor]CGColor];
    _wireResistivityTxt.layer.borderWidth=1.0;
    [_wireResistivityTxt setEnabled:NO];
    
    
}
-(void)getEmail{
    
    NSString *emailBody = [[NSString alloc]initWithFormat:@"<table><tr><td style=\"border-right:1px solid black\">Phase</td><td>%i</td><td style=\"border-right:1px solid black\">Length of Conductors in Feet</td><td>%@</td></tr><tr><td style=\"border-right:1px solid black\">Wire Size</td><td>%@</td><td style=\"border-right:1px solid black\">Full Load Circuit Current</td><td>%@</td></tr><tr><td style=\"border-right:1px solid black\">Resistivity</td><td>%@</td><td style=\"border-right:1px solid black\">Circuit Voltage</td><td>%@</td></tr><tr><td style=\"border-right:1px solid black\">Circular-mil-area</td><td>%@</td></tr></table>",_aluminumACVoltDropV.selectPhase.phaseID,[self roundingUp:[_aluminumACVoltDropV.oneWayLength floatValue] andDecimalPlace:0],_aluminumACVoltDropV.selectWire.wireSize,[self roundingUp:[_aluminumACVoltDropV.current floatValue] andDecimalPlace:0],[self roundingUp:[_aluminumACVoltDropV.resistivity floatValue] andDecimalPlace:2],[self roundingUp:[_aluminumACVoltDropV.cirtVoltage floatValue] andDecimalPlace:0],[self roundingUp:_aluminumACVoltDropV.selectWire.circ andDecimalPlace:6]];
    
    NSString *emailAnw =[[NSString alloc]initWithFormat:@"</br><table><tr><td style=\"border-right:1px solid black\">%@</td><td>%@</td></tr><tr><td style=\"border-right:1px solid black\">Volt Drop%@</td><td>%@</td></tr></table>",_typeLbl.text,_attributeLbl.text,@"%",_attribute2Lbl.text];
    
    emailBody = [ emailBody stringByAppendingString:emailAnw];
    
    [[self delegate]giveFormlaDetails:emailBody];
    [[self delegate]giveFormlaInformation:@"Main Service Voltage Drop calculates the voltage drop and percentage of voltage drop by selecting aluminum or copper conductor, the phasing and wire size, plus entering the length of conductor, full load current, and circuit voltage."];
    [[self delegate]giveFormlaTitle:@"Main Service Voltage Drop"];
}

-(void)setInfo{
    _info = @"Main Service Voltage Drop calculates the voltage drop and percentage of voltage drop by selecting aluminum or copper conductor, the phasing and wire size, plus entering the length of conductor, full load current, and circuit voltage.\n\nSelect the conductor type “Copper” or “Aluminum”.\nSelect a single “Phase 1” or three phase “Phase 3” circuit from the phase table.\nSelect the appropriate conductor size from the Wire Size table.\nEnter the one way total length of the conductor in feet.\nEnter the actual or estimated full load circuit current.\nEnter the circuit voltage.\nThe voltage drop in volts and percentage of voltage drop will be calculated.\n\nTo modify the Wire Size constants, select the “Configure” button.  To negate the modifications select the “Default” button.\n\nTo share the results select the “email” button.";
}

-(void)createQuantityPopoverList{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        UIViewController *popoverContent=[[UIViewController alloc] init];
        
        UITableView *tableView2=[[UITableView alloc] initWithFrame:CGRectMake(150, 100, 0, 0) style:UITableViewStyleGrouped];
        [tableView2 setBounces:NO];
        popoverContent.preferredContentSize=CGSizeMake(150, 100);
        popoverContent.view=tableView2; //Adding tableView to popover
        tableView2.delegate = _wireResieLbl;
        tableView2.dataSource = _wireResieLbl;
        [_wireResieLbl setDelegate:self];
        _quantityPickerPopover = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        [_quantityPickerPopover setDelegate:self];
        _quantityPickerPopover.contentViewController.preferredContentSize = CGSizeMake(150, 155);
        [_quantityPickerPopover presentPopoverFromRect:CGRectMake(_wireResieLbl.frame.size.width, _wireResieLbl.frame.size.height/2, 0, 0) inView:_wireResieLbl
                              permittedArrowDirections:UIPopoverArrowDirectionUp
                                              animated:NO];
        
    }else {
        UITableViewController *tableView = [[UITableViewController alloc]init];
        tableView.tableView.delegate = _wireResieLbl;
        tableView.tableView.dataSource = _wireResieLbl;
        
        [self.navigationController pushViewController:tableView animated:YES];
    }
    
}
@end


@implementation MainServiceVoltageDropLabelCell
@end

@implementation MainServiceVoltageDropEditCell
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

#pragma mark - Implementation WireResistivityTypeLabel
@interface WireResistivityTypeLabel(){
    NSMutableArray *types;
}
@end
@implementation WireResistivityTypeLabel

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    types = [[NSMutableArray alloc]initWithObjects:@"Copper",@"Aluminum",@"Other", nil];
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",types[indexPath.row]]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float temp = 0;
    switch (indexPath.row) {
        case 0:
            temp = 12.9;
            break;
        case 1:
            temp = 21.2;
            break;
        case 2:
            temp = 0;
            break;
    }
    [[self delegate] updateResistivity:temp];
}

@end