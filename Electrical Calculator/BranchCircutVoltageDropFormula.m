//
//  WireSizeVoltageDropFormula.m
//  Electrical Calculator
//
//  Created by Paul Marney on 2/11/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "BranchCircutVoltageDropFormula.h"
#import "InformationViewController.h"

@interface BranchCircutVoltageDropFormula (){
    BOOL _config;
    InformationViewController *_informationVC;
    NSString *_info;
}

@end

@implementation BranchCircutVoltageDropFormula


#pragma mark - Life Cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [_lengthTxt setDelegate:self];
    [_cirtCurrentTxt setDelegate:self];
    
    UIBarButtonItem * configure = [[UIBarButtonItem alloc]initWithTitle:@"Configure" style:UIBarButtonItemStylePlain target:self action:@selector(pressedConfig:)];
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _wireSizeVoltageDropV.wires.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        static NSString *simpleTableIdentifier = @"Cell";
        BranchCircutVoltageDropLabelCell *cell = (BranchCircutVoltageDropLabelCell *)[_wireTV dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        
        [cell.wireSize setText:@"WireSizes"];
        [cell.wireSize setAdjustsFontSizeToFitWidth:YES];
        [cell.ampacity setText:@"Ampacity"];
        [cell.ampacity setAdjustsFontSizeToFitWidth:YES];
        [cell.ohms setText:@"Ohms"];
        [cell.ohms setAdjustsFontSizeToFitWidth:YES];
        [cell setTag:indexPath.row];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else{
        if (_config) {
            static NSString *simpleTableIdentifier = @"CellEdit";
            BranchCircutVoltageDropEditCell *cell = (BranchCircutVoltageDropEditCell *)[_wireTV dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CellEdit" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            WSVDWire *temp = _wireSizeVoltageDropV.wires[indexPath.row-1];
            
            [cell.wireSize setText:temp.wireSize];
            [cell.ampacity setText:[self roundingUp:temp.ampacity andDecimalPlace:2]];
            [cell.ampacity setAdjustsFontSizeToFitWidth:YES];
            [cell.ohms setText:[NSString stringWithFormat:@"%f",temp.ohms]];
            [cell.ohms setAdjustsFontSizeToFitWidth:YES];
            
            [cell.wireSize setDelegate:cell];
            [cell.ampacity setDelegate:cell];
            [cell.ohms setDelegate:cell];
            [cell setDelegate:self];
            
            [cell setTag:indexPath.row-1];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }else{
            static NSString *simpleTableIdentifier = @"Cell";
            BranchCircutVoltageDropLabelCell *cell = (BranchCircutVoltageDropLabelCell *)[_wireTV dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            
            WSVDWire *temp = _wireSizeVoltageDropV.wires[indexPath.row-1];
            
            [cell.wireSize setText:temp.wireSize];
            [cell.ampacity setText:[self roundingUp:temp.ampacity andDecimalPlace:2]];
            [cell.ampacity setAdjustsFontSizeToFitWidth:YES];
            [cell.ohms setText:[NSString stringWithFormat:@"%f",temp.ohms]];
            [cell.ohms setAdjustsFontSizeToFitWidth:YES];
            
            [cell setTag:indexPath.row-1];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            
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
        WSVDWire *temp = _wireSizeVoltageDropV.wires[indexPath.row-1];
        [_wireSizeVoltageDropV deleteWSVDWire:temp];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationLeft];
        if (temp.wireSize.length == 0 && temp.ampacity == 0 && temp.ohms == 0)
            [self canAddAnotherWire:YES];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 0)
        [_wireSizeVoltageDropV setSelectWire:_wireSizeVoltageDropV.wires[indexPath.row-1]];
    [self calulateTotal];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _cirtCurrentTxt)
        [_wireSizeVoltageDropV setCurrent:[NSNumber numberWithFloat:[textField.text floatValue]]];
    if (textField == _lengthTxt)
        [_wireSizeVoltageDropV setOneWayLength:[NSNumber numberWithFloat:[textField.text floatValue]]];
    [self calulateTotal];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}(\\.)?(\\d{0,9})?$" options:0 error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
    BOOL x = (match != nil);
    if (textField == _cirtCurrentTxt)
        [_wireSizeVoltageDropV setCurrent:[NSNumber numberWithFloat:[s floatValue]]];
    if (textField == _lengthTxt)
        [_wireSizeVoltageDropV setOneWayLength:[NSNumber numberWithFloat:[s floatValue]]];
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
    [_informationVC setInfoTitle:@"Branch Circut Voltage Drop Information"];
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
    
    [_attribute1Lbl setText:@""];
    [_attribute2Lbl setText:@""];
    [_attribute3Lbl setText:@""];
    [_attribute4Lbl setText:@""];
    [_attribute5Lbl setText:@""];
    [_attribute6Lbl setText:@""];
    [_attribute7Lbl setText:@""];
    [_attribute8Lbl setText:@""];
    [_voltSizeLbl setText:@"<- Select Voltage"];

    [_lengthTxt setText:@""];
    [_cirtCurrentTxt setText:@""];
    
    [_wireSizeVoltageDropV removeValues];
    
}
- (IBAction)changeVoltage:(id)sender {
    [self createVoltPopoverListWith];
}

- (IBAction)addImpedanceAction:(id)sender {
    [_wireTV endEditing:YES];
    WSVDWire *temp = [[WSVDWire alloc]init];
    [temp setWireSize:@"0/"];
    [_wireSizeVoltageDropV addWSVDWire:temp];
    [_wireTV reloadData];
    [_addFuseBtn setEnabled:NO];
}

- (IBAction)pressedClear:(id)sender {
    [_wireSizeLbl  setText:@"Wire Size"];
    [_attribute1Lbl setText:@""];
    [_attribute2Lbl setText:@""];
    [_attribute3Lbl setText:@""];
    [_attribute4Lbl setText:@""];
    [_attribute5Lbl setText:@""];
    [_attribute6Lbl setText:@""];
    [_attribute7Lbl setText:@""];
    [_attribute8Lbl setText:@""];
    [_voltSizeLbl setText:@"<- Select Voltage"];
    
    [_lengthTxt setText:@""];
    [_cirtCurrentTxt setText:@""];
    
    [_wireSizeVoltageDropV removeValues];
}

- (IBAction)resetDefaults:(id)sender {
    
    if (_config) {
        
        NSData* myDataArrayImpedance = [NSKeyedArchiver archivedDataWithRootObject:[_wireSizeVoltageDropV wires]];
        
        [UICKeyChainStore setData:myDataArrayImpedance forKey:@"SystemDefaultsArrayWire"];
        
        [TSMessage showNotificationInViewController:self.navigationController.viewControllers.lastObject title:@"AluminumACVoltDropFormula" subtitle:@"Defaults has been save." type:TSMessageNotificationTypeSuccess duration:1.5];
        
        [_addFuseBtn setHidden:_config];
        [_addFuseBtn setEnabled:!_config];
        
    }else {
        NSData* myDataArrayWire = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayWire"];
        NSMutableArray* defaultWires = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayWire];
        
        [_wireSizeVoltageDropV setDefaultsWSVDWire:defaultWires];
        
        [_wireTV setDataSource:self];
        [_wireTV setDelegate:self];
        
        [_wireTV deselectRowAtIndexPath:[_wireTV indexPathForSelectedRow] animated:YES];
        
        [_addFuseBtn setHidden:_config];
        [_addFuseBtn setEnabled:!_config];
        
        [TSMessage showNotificationInViewController:self.navigationController.viewControllers.lastObject title:@"TransformerCalcFormula" subtitle:@"Defaults has been set." type:TSMessageNotificationTypeSuccess duration:1.5];
        
    }
    
    [_wireTV reloadData];
}
#pragma mark -  TransformerRatingEditImpedanceCellDelegate
-(void)updateVoltage:(int)volts{
    [_quantityPickerPopover dismissPopoverAnimated:YES];
    [_voltSizeLbl setText:[NSString stringWithFormat:@"%i",volts]];
    [self calulateTotal];
}
#pragma mark -  TransformerRatingEditImpedanceCellDelegate

-(void)updateWire:(WSVDWire *)wire andIndexPath:(int)row{
    [_wireSizeVoltageDropV updateWSVDWire:wire andIndex:row];
    [_wireTV reloadData];
}
-(void)canAddAnotherWire:(BOOL)check{
    [_addFuseBtn setEnabled:check];
}

#pragma mark - Private Methods

-(void)initView{
    if (_wireSizeVoltageDropV == nil) {
        
        _wireSizeVoltageDropV = [[ BranchCircutVoltageDropVariables alloc ]init];
        
        NSData* myDataArrayWire = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayWire"];
        NSMutableArray* defaultWires = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayWire];
        
        [_wireSizeVoltageDropV setDefaultsWSVDWire:defaultWires];
        
        [_wireTV setDataSource:self];
        [_wireTV setDelegate:self];
        
        [_wireTV deselectRowAtIndexPath: [_wireTV indexPathForSelectedRow] animated:YES];
        
    }
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
        UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        tapper.cancelsTouchesInView = NO;
        [self.view addGestureRecognizer:tapper];
    }
    
    [_cirtCurrentTxt setDelegate:self];
    [_lengthTxt setDelegate:self];
    [_voltage setDelegate:self];
}


-(void)configureMode:(int)mode{
    [self.view endEditing:YES];
    BOOL boolValue = [[UICKeyChainStore stringForKey:@"FormulaConfiguration"] boolValue];
    if (mode == 0)
        boolValue = !boolValue;
    if (boolValue) {
        _config = NO;
        [UICKeyChainStore setString:@"NO" forKey:@"FormulaConfiguration"];
        [_defaultBtn setTitle:@"Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [self.navigationController.viewControllers.lastObject setTitle:@"Branch Circut Voltage Drop"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Configure"];
        _cirtCurrentTxt.layer.borderColor=[[UIColor blackColor]CGColor];
        _cirtCurrentTxt.layer.borderWidth=1.0;
        _lengthTxt.layer.borderColor=[[UIColor blackColor]CGColor];
        _lengthTxt.layer.borderWidth=1.0;
    }else {
        _config = YES;
        [UICKeyChainStore setString:@"YES" forKey:@"FormulaConfiguration"];
        [_defaultBtn setTitle:@"Set Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [self.navigationController.viewControllers.lastObject setTitle:@"Branch Circut Voltage Drop Configuration"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Done"];
        _cirtCurrentTxt.layer.borderColor=[[UIColor clearColor]CGColor];
        _cirtCurrentTxt.layer.borderWidth=1.0;
        _lengthTxt.layer.borderColor=[[UIColor clearColor]CGColor];
        _lengthTxt.layer.borderWidth=1.0;
        
    }
    [_addFuseBtn setHidden:!_config];
    [_addFuseBtn setEnabled:_config];
    [_lengthTxt setEnabled:!_config];
    [_cirtCurrentTxt setEnabled:!_config];
    [_voltage setEnabled:!_config];
    
    [_wireTV deselectRowAtIndexPath:[_wireTV indexPathForSelectedRow] animated:YES];
    [_wireTV reloadData];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

-(void)calulateTotal{
    [_wireSizeLbl setText:[NSString stringWithFormat:@"Wire Size, %@",_wireSizeVoltageDropV.selectWire.wireSize]];
    [_attribute1Lbl setText:[self roundingUp:[_wireSizeVoltageDropV calulate1NECAmpacity] andDecimalPlace:2]];
    [_attribute2Lbl setText:[self roundingUp:[_wireSizeVoltageDropV calulate2Insulation] andDecimalPlace:2]];
    [_attribute3Lbl setText:[self roundingUp:[_wireSizeVoltageDropV calulate3FullLoadRate] andDecimalPlace:2]];
    [_attribute4Lbl setText:[self roundingUp:[_wireSizeVoltageDropV calulate4NeutralCounted] andDecimalPlace:2]];
    
    if ([_voltSizeLbl.text isEqualToString:@"120"]){
        [_attribute5Lbl setText:[self roundingUp:[_wireSizeVoltageDropV calulate5Resistance:v120] andDecimalPlace:6]];
        [_attribute6Lbl setText:[self roundingUp:[_wireSizeVoltageDropV calulate6VoltageDrop:v120] andDecimalPlace:6]];
        [_attribute7Lbl setText:[self roundingUp:[_wireSizeVoltageDropV calulate7PercentDrop:v120]*100 andDecimalPlace:3]];
        [_attribute8Lbl setText:[self roundingUp:[_wireSizeVoltageDropV calulate8PercentDrop:v120] andDecimalPlace:2]];
    }
    if ([_voltSizeLbl.text isEqualToString:@"240"]){
        [_attribute5Lbl setText:[self roundingUp:[_wireSizeVoltageDropV calulate5Resistance:v240] andDecimalPlace:6]];
        [_attribute6Lbl setText:[self roundingUp:[_wireSizeVoltageDropV calulate6VoltageDrop:v240] andDecimalPlace:6]];
        [_attribute7Lbl setText:[self roundingUp:[_wireSizeVoltageDropV calulate7PercentDrop:v240]*100 andDecimalPlace:3]];
        [_attribute8Lbl setText:[self roundingUp:[_wireSizeVoltageDropV calulate8PercentDrop:v240] andDecimalPlace:2]];
    }
    
    
}

-(NSString *)roundingUp:(float)num andDecimalPlace:(int)place{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:place];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    
    return [formatter stringFromNumber:[NSNumber numberWithFloat:num]];
}

-(void)createVoltPopoverListWith{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        UIViewController *popoverContent=[[UIViewController alloc] init];
        
        UITableView *tableView2=[[UITableView alloc] initWithFrame:CGRectMake(265, 680, 0, 0) style:UITableViewStyleGrouped];
        popoverContent.preferredContentSize=CGSizeMake(200, 210);
        popoverContent.view=tableView2; //Adding tableView to popover
        tableView2.delegate = _voltage;
        tableView2.dataSource = _voltage;
        
        _quantityPickerPopover = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        [_quantityPickerPopover setDelegate:self];
        _quantityPickerPopover.contentViewController.preferredContentSize = CGSizeMake(150, 155);
        [_quantityPickerPopover presentPopoverFromRect:CGRectMake(_voltage.frame.size.width, _voltage.frame.size.height/2, 0, 0) inView:_voltage
                              permittedArrowDirections:UIPopoverArrowDirectionLeft
                                              animated:YES];
        
    }else {
        UITableViewController *tableView = [[UITableViewController alloc]init];
        tableView.tableView.delegate = _voltage;
        tableView.tableView.dataSource = _voltage;
        
        [self.navigationController pushViewController:tableView animated:YES];
    }
    
}

-(void)getEmail{
    NSString *emailWire = [[NSString alloc]initWithFormat:@"<table><tr><td style=\"border-right:1px solid black\">Wire Size</td><td>%@</td><td style=\"border-right:1px solid black\">Length of Conductors in Feet</td><td>%@</td></tr><tr><td style=\"border-right:1px solid black\">Ampacity</td><td>%@</td><td style=\"border-right:1px solid black\">Full Load Circuit Current</td><td>%@</td></tr><tr><td style=\"border-right:1px solid black\">Ohms</td><td>%@</td></tr></table>",_wireSizeVoltageDropV.selectWire.wireSize,[self roundingUp:[_wireSizeVoltageDropV.oneWayLength floatValue] andDecimalPlace:0],[self roundingUp:_wireSizeVoltageDropV.selectWire.ampacity andDecimalPlace:0],[self roundingUp:[_wireSizeVoltageDropV.current floatValue] andDecimalPlace:0],[self roundingUp:_wireSizeVoltageDropV.selectWire.ohms andDecimalPlace:6]];
    
    NSString *emailBody = [[NSString alloc]initWithFormat:@"</br><table><tr><td style=\"border-right:1px solid black%@ border-bottom:1px solid black\">%@</td><td >%@</td></tr><tr><td style=\"border-right:1px solid black\">%@</td><td >%@</td></tr><tr><td style=\"border-right:1px solid black\">%@</td><td >%@</td></tr><tr><td style=\"border-right:1px solid black\">%@</td><td >%@</td></tr><tr><td style=\"border-right:1px solid black\">%@</td><td >%@</td></tr><tr><td style=\"border-right:1px solid black%@ border-bottom:1px solid black\">%@</td><td >%@</td></tr><tr><td style=\"border-right:1px solid black\">%@</td><td >%@</td></tr><tr><td style=\"border-right:1px solid black\">%@</td><td >%@</td></tr><tr><td style=\"border-right:1px solid black\">%@</td><td >%@</td></tr><tr><td style=\"border-right:1px solid black\">%@</td><td >%@</td></tr></table>",@";",@"Wire Size",_wireSizeVoltageDropV.selectWire.wireSize,@"NEC Ampacity @",_attribute1Lbl.text,@"75 deg. C Insulation",_attribute2Lbl.text,@"80% Full Loadrate",_attribute3Lbl.text,@"(no neutral counted )" ,_attribute4Lbl.text,@";",@"Volts",_voltSizeLbl.text,@"Resistance of Run",_attribute5Lbl.text,@"Voltage Drop",_attribute6Lbl.text,@"Percent Drop",_attribute7Lbl.text,@"Resultant voltage",_attribute8Lbl.text];
    
    emailWire = [ emailWire stringByAppendingString:emailBody];
    
    [[self delegate]giveFormlaDetails:emailWire];
    [[self delegate]giveFormlaInformation:@"Branch Circuit Voltage Drop calculates the resistance of run, voltage drop, percentage of voltage drop, and resultant voltage by selecting a copper conductor wire size, plus entering the length of conductor, full load current, and then selecting the circuit voltage of either 120 or 240 volts."];
    [[self delegate]giveFormlaTitle:@"Branch Circut Voltage Drop"];
}

-(void)setInfo{
    _info = @"Branch Circuit Voltage Drop calculates the resistance of run, voltage drop, percentage of voltage drop, and resultant voltage by selecting a copper conductor wire size, plus entering the length of conductor, full load current, and then selecting the circuit voltage of either 120 or 240 volts.  It also lists the NEC rated ampacity of the selected conductor with de-rating factors.\n\nSelect the appropriate conductor size from the Wire Size table.\nEnter the one way total length of the conductor in feet.\nEnter the actual or estimated full load circuit current.\nSelect the circuit voltage of either 120 or 240 volts.\n\nThe voltage drop in volts and percentage of voltage drop will be calculated.  The NEC ampacity and derating amperages will be given.\n\nTo modify the Wire Size constants, select the “Configure” button.  To negate the modifications select the “Default” button.\n\nTo share the results select the “email” button.";
}
@end

@implementation BranchCircutVoltageDropEditCell
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    WSVDWire * updated = [[ WSVDWire alloc]init];
    if (textField == self.wireSize)
        [updated setWireSize:textField.text ];
    else
        [updated setWireSize:self.wireSize.text ];
    
    if (textField == self.ampacity)
        [updated setAmpacity:[[textField.text stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue]];
    else
        [updated setAmpacity:[[self.ampacity.text stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue]];
    
    if (textField == self.ohms)
        [updated setOhms:[[textField.text stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue]];
    else
        [updated setOhms:[[self.ohms.text stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue]];
    
    [[self delegate]updateWire:updated andIndexPath:(int)self.tag];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.wireSize ){
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}[/]?\\d{0,9}$" options:0 error:nil];
        NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
        BOOL x = (match != nil);
        [[self delegate]canAddAnotherWire:(x && s.length>0)];
        return x;
    }else {
        s = [s stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d*[.]?\\d*$"  options:0 error:nil];
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

@end

@implementation BranchCircutVoltageDropLabelCell

@end

@implementation BranchCircutVoltageDropButton

#pragma mark - UITableView Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    if (indexPath.row == 0) {
        [cell.textLabel setText:[NSString stringWithFormat:@"%i",120]];
    }else{
        [cell.textLabel setText:[NSString stringWithFormat:@"%i",240]];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [[self delegate] updateVoltage:[cell.textLabel.text integerValue]];
}


@end