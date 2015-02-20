//
//  TransformerCalcVariablesFormula.m
//  Electrical Calculator
//
//  Created by Paul Marney on 1/26/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "TransformerLoadFormula.h"
#import "InformationViewController.h"

@interface TransformerLoadFormula (){
    BOOL _config;
    TCPhase *_selectedPhase;
    TCLLSec *_selectedLLSec;
    InformationViewController *_informationVC;
    NSString *_info;
}

@end

@implementation TransformerLoadFormula

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_kilaVoltAmpsTxt setDelegate:self];
    [_ampsTxt setDelegate:self];
    
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

#pragma mark - IBActions

- (IBAction)pressedInfo:(id)sender {
    
    [self setInfo];
    _informationVC = [[InformationViewController alloc]init];
    [_informationVC setInfoTitle:@"Transformer Load Information"];
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
    
    [_FLAPLlb setText:@""];
    [_FLASLlb setText:@""];
    [_AFCPLlb setText:@""];
    [_AFCSLlb setText:@""];
    [_kilaVoltAmpsTxt setText:@""];
    [_ampsTxt setText:@""];
    [_transformerCalcV removeValues];
}

- (IBAction)addLLVoltAction:(id)sender {
    [_secLLVoltTV endEditing:YES];
    TCLLSec *temp = [[TCLLSec alloc]init];
    [_transformerCalcV addTCLLSec:temp];
    [_secLLVoltTV reloadData];
    [_addLLVoltsBtn setEnabled:NO];
}

- (IBAction)resetDefaults:(id)sender {
    
    if (_config) {
        
        NSData* myDataArrayPhase = [NSKeyedArchiver archivedDataWithRootObject:[_transformerCalcV phases]];
        NSData* myDataArrayLLSec = [NSKeyedArchiver archivedDataWithRootObject:[_transformerCalcV llSecs]];
        
        [UICKeyChainStore setData:myDataArrayLLSec forKey:@"SystemDefaultsArrayLLSec"];
        [UICKeyChainStore setData:myDataArrayPhase forKey:@"SystemDefaultsArrayPhase"];
        
        [TSMessage showNotificationInViewController:self.navigationController.viewControllers.lastObject title:@"TransformerLoadFormula" subtitle:@"Defaults has been save." type:TSMessageNotificationTypeSuccess duration:1.5];
        
    }else {
        NSData* myDataArrayPhase = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayPhase"];
        NSMutableArray* defaultPhases = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayPhase];
        
        NSData* myDataArrayLLSec = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayLLSec"];
        NSMutableArray* defaultLLSecs = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayLLSec];
        
        [_transformerCalcV setDefaultsTCLLSec:defaultLLSecs];
        [_transformerCalcV setDefaultsTCPhase:defaultPhases];
        [_secLLVoltTV reloadData];
        [_phaseTV reloadData];
        
        _selectedPhase = nil;
        _selectedLLSec = nil;
        [_phaseTV deselectRowAtIndexPath:[_phaseTV indexPathForSelectedRow] animated:YES];
        [_secLLVoltTV deselectRowAtIndexPath:[_secLLVoltTV indexPathForSelectedRow] animated:YES];
        
        [_kilaVoltAmpsTxt setText:@""];
        [_ampsTxt setText:@""];
        
        [_transformerCalcV setDefaultskilovolt_amps:0];
        [_transformerCalcV setDefaultsAmpsPer:0];
        
        [_AFCPLlb setText:[self roundingUp:0.00]];
        [_AFCSLlb setText:[self roundingUp:0.00]];
        [_FLAPLlb setText:[self roundingUp:0.00]];
        [_FLASLlb setText:[self roundingUp:0.00]];
        
        [TSMessage showNotificationInViewController:self.navigationController.viewControllers.lastObject title:@"TransformerLoadFormula" subtitle:@"Defaults has been set." type:TSMessageNotificationTypeSuccess duration:1.5];
        
    }
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_config) {
        if (tableView == _secLLVoltTV) {
            return 44;
        }else {
            return 130;
        }
    } else {
        return 50;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == _secLLVoltTV) {
        return @"Sec. L-L Volts";
    }else {
        return @"Phase (1 or 3)";
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _secLLVoltTV) {
        return _transformerCalcV.llSecs.count;
    }else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    if (_config) {
        if (tableView == _secLLVoltTV) {
            static NSString *simpleTableIdentifier = @"EditLLVolts";
            TransformerLLCell *cell = (TransformerLLCell *)[_secLLVoltTV dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditLLVolts" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            TCLLSec *temp = _transformerCalcV.llSecs[indexPath.row];
            
            if (temp.llSecVaule != 0 ){
                [cell.LLSecVauleTxt setText:[NSString stringWithFormat:@"%i",(int)temp.llSecVaule]];}
            else {
                [cell.LLSecVauleTxt setText:@""];
                [cell.LLSecVauleTxt setPlaceholder:@"LLN/LL"];
                [cell OneAtATime];
            }
            [cell setTag:indexPath.row];
            
            [cell setDelegate:self];
            [cell.LLSecVauleTxt setDelegate:cell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            
        }else {
            static NSString *simpleTableIdentifier = @"EditPhase";
            TransformerPhaseCell *cell = (TransformerPhaseCell *)[_phaseTV dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditPhase" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            TCPhase *temp = _transformerCalcV.phases[indexPath.row];
            
            [cell.phaseIDTxt setText:[NSString stringWithFormat:@"%i",(int)temp.phaseID]];
            [cell.phaseLLTxt setText:[NSString stringWithFormat:@"%i",(int)temp.phaseLL]];
            [cell.phaseVauleTxt setText:[NSString stringWithFormat:@"%f",temp.phasevalue]];
            
            [cell setTag:indexPath.row];
            
            [cell setDelegate:self];
            [cell.phaseVauleTxt setDelegate:cell];
            [cell.phaseLLTxt setDelegate:cell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            
        }
    } else {
        if (tableView == _secLLVoltTV) {
            static NSString *simpleTableIdentifier = @"Cell";
            UITableViewCell *cell = (UITableViewCell *)[_secLLVoltTV dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            TCLLSec *temp = _transformerCalcV.llSecs[indexPath.row];
            
            if (temp.llSecVaule != 0 ){
                [cell.textLabel setText:[NSString stringWithFormat:@"%i",(int)temp.llSecVaule]];}
            else {
                [cell.textLabel setText:@""];
            }
            [cell setTag:indexPath.row];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            return cell;
            
        }else {
            static NSString *simpleTableIdentifier = @"Cell";
            UITableViewCell *cell = (UITableViewCell *)[_phaseTV dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            TCPhase *temp = _transformerCalcV.phases[indexPath.row];
            
            [cell.textLabel setText:[NSString stringWithFormat:@"%i",(int)temp.phaseID]];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%i",(int)temp.phaseLL]];
            
            [cell setTag:indexPath.row];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            return cell;
            
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!_config){
        if (tableView == _secLLVoltTV) {
            _selectedLLSec = [[TCLLSec alloc]init];
            _selectedLLSec = _transformerCalcV.llSecs[indexPath.row];
        }else{
            _selectedPhase = [[TCPhase alloc]init];
            _selectedPhase = _transformerCalcV.phases[indexPath.row];
        }
    }
    if (_selectedLLSec && _selectedPhase) {
        [self calulateTotal];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _secLLVoltTV) {
        return _config;
    }else {
        return NO;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _secLLVoltTV) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            TCLLSec *temp = _transformerCalcV.llSecs[indexPath.row];
            [_transformerCalcV deleteTCLLSec:temp];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSRegularExpression *regex;
    if (textField.tag == 0) {
        regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
    }else{
        regex = [NSRegularExpression regularExpressionWithPattern:@"^(0*100{1,1}\\.?((?<=\\.)0*)?%?$)|(^0*\\d{0,2}\\.?((?<=\\.)\\d*)?%?)$" options:0 error:nil];
    }
    
    NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
    
    if (match != nil) {
        if (textField == _ampsTxt) {
            [_transformerCalcV setDefaultsAmpsPer:[s floatValue]];
        }else {
            [_transformerCalcV setDefaultskilovolt_amps:[s floatValue]];
        }
        [self calulateTotal];
    }
    return (match != nil);
}
#pragma mark - TransformerPhaseCellDelegate

-(void)updateTransformerPhase:(TCPhase *)phase andIndexPath:(int)row{
    [_transformerCalcV updateTCPhase:phase andIndex:row];
    [_phaseTV reloadData];
}

#pragma mark - TransformerLLCellDelegate

-(void)updateTransformerLL:(TCLLSec *)LLSec andIndexPath:(int)row{
    if (LLSec.llSecVaule == 0) {
        [_transformerCalcV deleteTCLLSec:LLSec];
        [self canAddAnotherLLSec:YES];
    } else
        [_transformerCalcV updateTCLLSec:LLSec andIndex:row];
    
    [_secLLVoltTV reloadData];
}

-(void)canAddAnotherLLSec:(BOOL)check{
    [_addLLVoltsBtn setEnabled:check];
}

#pragma mark - Private Methods

-(void)initView{
    
    if (_transformerCalcV == nil) {
        _selectedPhase = nil;
        _selectedLLSec = nil;
        
        _transformerCalcV = [[ TransformerCalcVariables alloc ]init];
        
        NSData* myDataArrayPhase = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayPhase"];
        NSMutableArray* defaultPhases = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayPhase];
        
        NSData* myDataArrayLLSec = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayLLSec"];
        NSMutableArray* defaultLLSecs = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayLLSec];
        
        [_transformerCalcV setDefaultsTCLLSec:defaultLLSecs];
        [_transformerCalcV setDefaultsTCPhase:defaultPhases];
        
        [_phaseTV setDataSource:self];
        [_phaseTV setDelegate:self];
        [_phaseTV deselectRowAtIndexPath:[_phaseTV indexPathForSelectedRow] animated:YES];

        [_secLLVoltTV setDataSource:self];
        [_secLLVoltTV setDelegate:self];
        [_secLLVoltTV deselectRowAtIndexPath:[_secLLVoltTV indexPathForSelectedRow] animated:YES];
        
        [_kilaVoltAmpsTxt setText:@""];
        [_ampsTxt setText:@""];
        
        [_transformerCalcV setDefaultskilovolt_amps:0];
        [_transformerCalcV setDefaultsAmpsPer:0];
    }
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
        UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        tapper.cancelsTouchesInView = NO;
        [self.view addGestureRecognizer:tapper];
    }
    
    [_AFCPLlb setText:[self roundingUp:0.00]];
    [_AFCSLlb setText:[self roundingUp:0.00]];
    [_FLAPLlb setText:[self roundingUp:0.00]];
    [_FLASLlb setText:[self roundingUp:0.00]];
}

-(void)calulateTotal{
    [_FLAPLlb setText:[self roundingUp:[_transformerCalcV calulateFullLoadAmpsOnPri:_selectedPhase]]];
    [_FLASLlb setText:[self roundingUp:[_transformerCalcV calulateFullLoadAmpsOnSec:_selectedPhase andLLSec:_selectedLLSec]]];
    [_AFCPLlb setText:[self roundingUp:[_transformerCalcV calulateAvailablFaultCurrentPri:_selectedPhase]]];
    [_AFCSLlb setText:[self roundingUp:[_transformerCalcV calulateAvailablFaultCurrentSec:_selectedPhase andLLSec:_selectedLLSec]]];
    
}

-(NSString *)roundingUp:(float)num{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    
    return [formatter stringFromNumber:[NSNumber numberWithFloat:num]];
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
        [self.navigationController.viewControllers.lastObject setTitle:@"Transformer Load"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Configure"];
        _ampsTxt.layer.borderColor=[[UIColor blackColor]CGColor];
        _ampsTxt.layer.borderWidth=1.0;
        _kilaVoltAmpsTxt.layer.borderColor=[[UIColor blackColor]CGColor];
        _kilaVoltAmpsTxt.layer.borderWidth=1.0;
    }else {
        _config = YES;
        [UICKeyChainStore setString:@"YES" forKey:@"FormulaConfiguration"];
        [_defaultBtn setTitle:@"Set Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [self.navigationController.viewControllers.lastObject setTitle:@"Transformer Load Configuration"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Done"];
        _ampsTxt.layer.borderColor=[[UIColor clearColor]CGColor];
        _ampsTxt.layer.borderWidth=1.0;
        _kilaVoltAmpsTxt.layer.borderColor=[[UIColor clearColor]CGColor];
        _kilaVoltAmpsTxt.layer.borderWidth=1.0;
    }
    [_addLLVoltsBtn setHidden:!_config];
    [_addLLVoltsBtn setEnabled:_config];
    [_ampsTxt setEnabled:!_config];
    [_kilaVoltAmpsTxt setEnabled:!_config];
    
    
    [_phaseTV deselectRowAtIndexPath:[_phaseTV indexPathForSelectedRow] animated:YES];
    [_phaseTV reloadData];
    
    [_secLLVoltTV deselectRowAtIndexPath:[_secLLVoltTV indexPathForSelectedRow] animated:YES];
    [_secLLVoltTV reloadData];
}
-(void)getEmail{
    
    NSString *emailBody = [[NSString alloc]initWithFormat:@"<table><tr><td style=\"border-right:1px solid black%@ border-bottom:1px solid black \">Phase</td><td style=\"border-right:1px solid black%@ border-bottom:1px solid black \">Sec L-L</td><td style=\"border-right:1px solid black%@ border-bottom:1px solid black \">kVA</td><td style=\"border-bottom:1px solid black \">Impedance%@</td></tr><tr><td style=\"border-right:1px solid black\">%i</td><td style=\"border-right:1px solid black\">%f</td><td style=\"border-right:1px solid black\">%@</td><td>%@</td></tr></table>",@";",@";",@";",@"%",_selectedPhase.phaseID,_selectedLLSec.llSecVaule,_kilaVoltAmpsTxt.text,_ampsTxt.text];
    
    NSString *emailAnw =[[NSString alloc]initWithFormat:@"</br><table><tr><td>Full Load Amps on Pri</td><td>%@</td></tr><tr><td>Full Load Amps on Sec</td><td>%@</td></tr><tr><td>Available Fault Current Pri</td><td>%@</td></tr><tr><td>Available Fault Current Sec</td><td>%@</td></tr></table>",_FLAPLlb.text,_FLASLlb.text,_AFCPLlb.text,_AFCSLlb.text];
    
    emailBody = [ emailBody stringByAppendingString:emailAnw];

    [[self delegate]giveFormlaDetails:emailBody];
    [[self delegate]giveFormlaInformation:@"Transformer Load calculates the available full load amps and fault current on the primary and secondary sides of a transformer by entering the nameplate data."];
    [[self delegate]giveFormlaTitle:@"Transformer Load"];
}

-(void)setInfo{
    _info = @"Transformer Load calculates the available full load amps and fault current on the primary and secondary sides of a transformer by entering the nameplate data.\n\nSelect whether the transformer is a single or three phase  unit.  “Phase (1 or 3)”\nSelect the secondary voltage rating on the transformer.  “SEC. L-L VOLTS”\nEnter the transformer nameplate size in kVA.\nEnter the transformer nameplate % impedance value.\n\nFull load amps and available fault current on the primary and secondary of transformer will be calculated.\n\nTo modify the Phase Value constants, Phase Voltages, or Secondary Voltages select the “Configure” button.  To negate the modifications select the “Default” button.\n\nTo share the results select the “email” button.";
}
@end



@implementation TransformerPhaseCell
@synthesize phaseIDTxt,phaseVauleTxt,phaseLLTxt,delegate;
#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    TCPhase * updated = [TCPhase new];
    [updated setPhaseID:(int)[phaseIDTxt.text integerValue]];
    [updated setPhaseLL:[phaseLLTxt.text floatValue]];
    [updated setPhasevalue:[phaseVauleTxt.text floatValue]];
    
    [[self delegate]updateTransformerPhase:updated andIndexPath:(int)self.tag];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(\\d{0,9})?(\\.\\d{0,9})?$" options:0 error:nil];
    
    NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
    
    return (match != nil);
}

@end


@implementation TransformerLLCell
@synthesize LLSecVauleTxt,delegate;

- (void)textFieldDidEndEditing:(UITextField *)textField{
    TCLLSec * updated = [[ TCLLSec alloc]init];
    [updated setLlSecVaule:[textField.text floatValue]];
    [[self delegate]updateTransformerLL:updated andIndexPath:(int)self.tag];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
    BOOL x = (match != nil);
    [[self delegate]canAddAnotherLLSec:(x && s.length>0)];
    return x;
}
-(void)OneAtATime{
    [[self delegate]canAddAnotherLLSec:NO];
}

@end