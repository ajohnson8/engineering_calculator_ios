//
//  TransformerRatingCalcFormula.m
//  Electrical Calculator
//
//  Created by Paul Marney on 2/3/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "TransformerRatingCalcFormula.h"
#import "InformationViewController.h"

@interface TransformerRatingCalcFormula () {
    BOOL _config;
    InformationViewController *_informationVC;
    TFCUG *_calugMax;
    TFCUG *_calugMin;
    NSString *_info;
}

@end

#pragma mark - TransformerRatingCalcFormula

@implementation TransformerRatingCalcFormula
@synthesize impedanceTV = _impedanceTV;


#pragma mark - Life Cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [_secVoltTxt setDelegate:self];
    [_priVoltTxt setDelegate:self];
    [_kilaVoltAmpsTxt setDelegate:self];
    
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
    
    return @"Impedances Table";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_transformerRateCalcV.impedances.count  > 0)
        return _transformerRateCalcV.impedances.count+1;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        static NSString *simpleTableIdentifier = @"ImpedanceCell";
        TransformerRatingImpedanceCell *cell = (TransformerRatingImpedanceCell *)[_impedanceTV dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ImpedanceCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [cell.KVALbl setText:@"kVA"];
        [cell.V208Lbl setText:@"208v"];
        [cell.V480Lbl setText:@"480v"];
        
        return cell;
    }else {
        if (_config) {
            static NSString *simpleTableIdentifier = @"ImpedanceEditCell";
            TransformerRatingEditImpedanceCell *cell = (TransformerRatingEditImpedanceCell *)[_impedanceTV dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ImpedanceEditCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            TRCImpedance *temp = _transformerRateCalcV.impedances[indexPath.row-1];
            [cell.KVATxt setText:[self roundingUp:temp.KVA andDecimalPlace:2]];
            [cell.V208Txt setText:[self roundingUp:temp.V208 andDecimalPlace:2]];
            [cell.V480Txt setText:[self roundingUp:temp.V480 andDecimalPlace:2]];
            
            [cell setTag:indexPath.row-1];
            
            [cell setDelegate:self];
            [cell.KVATxt setDelegate:cell];
            [cell.V208Txt setDelegate:cell];
            [cell.V480Txt setDelegate:cell];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            
            
        } else {
            static NSString *simpleTableIdentifier = @"ImpedanceCell";
            TransformerRatingImpedanceCell *cell = (TransformerRatingImpedanceCell *)[_impedanceTV dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ImpedanceCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            TRCImpedance *temp = _transformerRateCalcV.impedances[indexPath.row-1];
            [cell.KVALbl setText:[self roundingUp:temp.KVA andDecimalPlace:2]];
            [cell.V208Lbl setText:[self roundingUp:temp.V208 andDecimalPlace:2]];
            [cell.V480Lbl setText:[self roundingUp:temp.V480 andDecimalPlace:2]];
            
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
        TRCImpedance *temp = _transformerRateCalcV.impedances[indexPath.row-1];
        [_transformerRateCalcV deleteTRCImpedances:temp];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationLeft];
        if (temp.KVA == 0 && temp.V208 == 0 && temp.V480 == 0)
            [self canAddAnotherImpedance:YES];
    }

}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSRegularExpression *regex;
    regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
    
    NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
    
    if (match != nil) {
        if (textField == _priVoltTxt) {
            [_transformerRateCalcV setDefaultsPriVolts:[s floatValue]];
        }else if (_kilaVoltAmpsTxt == textField) {
            [_transformerRateCalcV setDefaultskilovolt_amps:[s floatValue]];
        }
        else {
            [_transformerRateCalcV setDefaultsSecVolts:[s floatValue]];
        }
        [self calulateTotal];
    }
    return (match != nil);
}


#pragma mark - IBActions
- (IBAction)pressedInfo:(id)sender {
    
    [self setInfo];
    _informationVC = [[InformationViewController alloc]init];
    [_informationVC setInfoTitle:@"Transformer Rating Information"];
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
    [_impedancePerLbl setText:@""];
    [_priFLALbl setText:@""];
    [_secFLALbl setText:@""];
    [_priMaxLbl setText:@""];
    [_priMinLbl setText:@""];
    [_secBreakerLbl setText:@""];
    [_faultPriLbl setText:@""];
    [_faultSecLbl setText:@""];
    [_secVoltTxt setText:@""];
    [_priVoltTxt setText:@""];
    [_kilaVoltAmpsTxt setText:@""];
    [_transformerRateCalcV removeValues];
}

- (IBAction)addImpedanceAction:(id)sender {
    [_impedanceTV endEditing:YES];
    TRCImpedance *temp = [[TRCImpedance alloc]init];
    [_transformerRateCalcV addTRCImpedances:temp];
    [_impedanceTV reloadData];
    [_addImpedanceBtn setEnabled:NO];
}

- (IBAction)pressedClear:(id)sender {
    [_impedancePerLbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
    [_priFLALbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
    [_secFLALbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
    [_priMaxLbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
    [_priMinLbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
    [_secBreakerLbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
    [_faultPriLbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
    [_faultSecLbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
    [_secVoltTxt  setText:@""];
    [_priVoltTxt setText:@""];
    [_kilaVoltAmpsTxt setText:@""];
    [_maxRecommendedFuse setText:@""];
    [_minRecommendedFuse setText:@""];
    [_transformerRateCalcV setDefaultsPriVolts:0];
    [_transformerRateCalcV setDefaultskilovolt_amps:0];
    [_transformerRateCalcV setDefaultsSecVolts:0];
    
}

- (IBAction)resetDefaults:(id)sender {
    
    if (_config) {
        
        NSData* myDataArrayImpedance = [NSKeyedArchiver archivedDataWithRootObject:[_transformerRateCalcV impedances]];
        
        [UICKeyChainStore setData:myDataArrayImpedance forKey:@"SystemDefaultsArrayImpedance"];
        
        [TSMessage showNotificationInViewController:self.navigationController.viewControllers.lastObject title:@"TransformerCalcFormula" subtitle:@"Defaults has been save." type:TSMessageNotificationTypeSuccess duration:1.5];
        
        [_addImpedanceBtn setHidden:_config];
        [_addImpedanceBtn setEnabled:!_config];
        
    }else {
        NSData* myDataArrayImpedance = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayImpedance"];
        NSMutableArray* defaultImpedance = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayImpedance];
        
        [_transformerRateCalcV setDefaultsTRCImpedances:defaultImpedance];
        
        [_impedanceTV setDataSource:self];
        [_impedanceTV setDelegate:self];
        
        [_impedanceTV deselectRowAtIndexPath:[_impedanceTV indexPathForSelectedRow] animated:YES];
        
        [_addImpedanceBtn setHidden:_config];
        [_addImpedanceBtn setEnabled:!_config];
        
        [_addImpedanceBtn setHidden:YES];
        [_addImpedanceBtn setEnabled:NO];
        
        [_impedancePerLbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
        [_priFLALbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
        [_secFLALbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
        [_priMaxLbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
        [_priMinLbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
        [_secBreakerLbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
        [_faultPriLbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
        [_faultSecLbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
        
        [TSMessage showNotificationInViewController:self.navigationController.viewControllers.lastObject title:@"TransformerCalcFormula" subtitle:@"Defaults has been set." type:TSMessageNotificationTypeSuccess duration:1.5];
        
    }
    
    [_impedanceTV reloadData];
}

#pragma mark -  TransformerRatingEditImpedanceCellDelegate

-(void)updateTransformerImpedance:(TRCImpedance *)impedance andIndexPath:(int)row{
    [_transformerRateCalcV updateTRCImpedances:impedance andIndex:row];
    [_impedanceTV reloadData];
}
-(void)canAddAnotherImpedance:(BOOL)check{
    [_addImpedanceBtn setEnabled:check];
}

#pragma mark - Private Methods

-(void)initView{
    // [self addImpedances];
    if (_transformerRateCalcV == nil) {
        
        _transformerRateCalcV = [[ TransformerRatingCalcVariables alloc ]init];
        
            NSData* myDataArrayImpedance = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayImpedance"];
            NSMutableArray* defaultImpedance = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayImpedance];
            
            [_transformerRateCalcV setDefaultsTRCImpedances:defaultImpedance];
            
            [_impedanceTV setDataSource:self];
            [_impedanceTV setDelegate:self];
            [_impedanceTV deselectRowAtIndexPath:[_impedanceTV indexPathForSelectedRow] animated:YES];
        
    }
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
        UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        tapper.cancelsTouchesInView = NO;
        [self.view addGestureRecognizer:tapper];
    }
    
    [_secVoltTxt setText:@""];
    [_priVoltTxt setText:@""];
    [_impedancePerLbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
    [_priFLALbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
    [_secFLALbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
    [_priMaxLbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
    [_priMinLbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
    [_secBreakerLbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
    [_faultPriLbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
    [_faultSecLbl setText:[self roundingUp:0.00 andDecimalPlace:0]];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

-(void)calulateTotal{
    [_impedancePerLbl setText:[self roundingUp:[_transformerRateCalcV calulateSNLSImpedance] andDecimalPlace:2]];
    [_priFLALbl setText:[self roundingUp:[_transformerRateCalcV calulatePriCurFLA] andDecimalPlace:0]];
    [_secFLALbl setText:[self roundingUp:[_transformerRateCalcV calulateSecCurFLA]andDecimalPlace:0]];
    [_priMaxLbl setText:[self roundingUp:[_transformerRateCalcV calulatePriFuseMax]andDecimalPlace:0]];
    [_priMinLbl setText:[self roundingUp:[_transformerRateCalcV calulatePriFuseMin]andDecimalPlace:0]];
    [_secBreakerLbl setText:[self roundingUp:[_transformerRateCalcV calulateSecBreaker]andDecimalPlace:0]];
    [_faultPriLbl setText:[self roundingUp:[_transformerRateCalcV calulateFaultDutyPri]andDecimalPlace:0]];
    [_faultSecLbl setText:[self roundingUp:[_transformerRateCalcV calulateFaultDutySec]andDecimalPlace:0]];
    
    _calugMax = [[TFCUG alloc]init];
    _calugMin = [[TFCUG alloc]init];
    
    [_calugMax setKVA:[NSString stringWithFormat:@"%f",[_transformerRateCalcV calulatePriFuseMax]]];
    [_calugMin setKVA:[NSString stringWithFormat:@"%f",[_transformerRateCalcV calulatePriFuseMin]]];
    
     id maxTemp = [FuseWizardFormula sreachForFuseByTempFuseType:_calugMax];
     id minTemp = [FuseWizardFormula sreachForFuseByTempFuseType:_calugMin];
    
    if ([maxTemp isKindOfClass:[NSString class]])
        [_maxRecommendedFuse setText:maxTemp];
    else if ([maxTemp isKindOfClass:[TFCUG class]] && [_transformerRateCalcV calulatePriFuseMax] != 0){
        _calugMax = maxTemp;
        [_maxRecommendedFuse setText:[NSString stringWithFormat:@"UG Max\nkVA %@\nBayonet %@\nNX %@\nS&C SM%@",_calugMax.KVA,[self roundingUp:_calugMax.Bayonet andDecimalPlace:0],_calugMax.NX,_calugMax.SnCSM]];
    } else {
        [_maxRecommendedFuse setText:@""];
    }
    
    if ([minTemp isKindOfClass:[NSString class]])
        [_minRecommendedFuse setText:maxTemp];
    else if ([minTemp isKindOfClass:[TFCUG class]] && [_transformerRateCalcV calulatePriFuseMin] != 0){
        _calugMin = minTemp;
        [_minRecommendedFuse setText:[NSString stringWithFormat:@"UG Min\nkVA %@\nBayonet %@\nNX %@\nS&C SM%@",_calugMin.KVA,[self roundingUp:_calugMin.Bayonet andDecimalPlace:0],_calugMin.NX,_calugMin.SnCSM]];
    } else {
        [_minRecommendedFuse setText:@""];
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
    [self.view endEditing:YES];
    BOOL boolValue = [[UICKeyChainStore stringForKey:@"FormulaConfiguration"] boolValue];
    if (mode == 0)
        boolValue = !boolValue;
    if (boolValue) {
        _config = NO;
        [UICKeyChainStore setString:@"NO" forKey:@"FormulaConfiguration"];
        [_defaultBtn setTitle:@"Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [self.navigationController.viewControllers.lastObject setTitle:@"Transformer Rating"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Configure"];
        _secVoltTxt.layer.borderColor=[[UIColor blackColor]CGColor];
        _secVoltTxt.layer.borderWidth=1.0;
        _priVoltTxt.layer.borderColor=[[UIColor blackColor]CGColor];
        _priVoltTxt.layer.borderWidth=1.0;
        _kilaVoltAmpsTxt.layer.borderColor=[[UIColor blackColor]CGColor];
        _kilaVoltAmpsTxt.layer.borderWidth=1.0;
    }else {
        _config = YES;
        [UICKeyChainStore setString:@"YES" forKey:@"FormulaConfiguration"];
        [_defaultBtn setTitle:@"Set Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [self.navigationController.viewControllers.lastObject setTitle:@"Transformer Rating Configuration"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Done"];
        _secVoltTxt.layer.borderColor=[[UIColor clearColor]CGColor];
        _secVoltTxt.layer.borderWidth=1.0;
        _priVoltTxt.layer.borderColor=[[UIColor clearColor]CGColor];
        _priVoltTxt.layer.borderWidth=1.0;
        _kilaVoltAmpsTxt.layer.borderColor=[[UIColor clearColor]CGColor];
        _kilaVoltAmpsTxt.layer.borderWidth=1.0;
    }
    [_addImpedanceBtn setHidden:!_config];
    [_addImpedanceBtn setEnabled:_config];
    [_secVoltTxt setEnabled:!_config];
    [_priVoltTxt setEnabled:!_config];
    [_kilaVoltAmpsTxt setEnabled:!_config];

    
    [_impedanceTV deselectRowAtIndexPath:[_impedanceTV indexPathForSelectedRow] animated:YES];
    [_impedanceTV reloadData];
}

-(void)getEmail{
    NSString *emailBody = [[NSString alloc]initWithFormat:@"<table><tr><td style=\"border-right:1px solid black%@ border-bottom:1px solid black \">Full-Load Rating,kVA</td><td style=\"border-right:1px solid black%@ border-bottom:1px solid black \">Line-to-Line Pri voltage</td><td style=\"border-bottom:1px solid black \">Line-to-Line Sec voltage</td></tr><tr><td style=\"border-right:1px solid black\">%@</td><td style=\"border-right:1px solid black\">%@</td><td>%@</td></tr></table>",@";",@";",_kilaVoltAmpsTxt.text,_priVoltTxt.text,_secVoltTxt.text];

    
    NSString *emailAnw =[[NSString alloc]initWithFormat:@"</br><table><tr><td>SNL Standard Impedance, </td><td>%@</td></tr><tr><td>Primary current, FLA:</td><td>%@</td></tr><tr><td>Secondary current, FLA:</td><td>%@</td></tr><tr><td>Primary fuse, max of 300</td><td>%@</td></tr><tr><td>Primary fuse, min of 125</td><td>%@</td></tr><tr><td>Secondary breaker, 125</td><td>%@</td></tr><tr><td>Fault duty, primary</td><td>%@</td></tr><tr><td>Fault duty, secondary</td><td>%@</td></tr></table>",_impedancePerLbl.text,_priFLALbl.text,_secFLALbl.text,_priMaxLbl.text,_priMinLbl.text,_secBreakerLbl.text,_faultPriLbl.text,_faultSecLbl.text];
    
    NSString *fuses  =[[NSString alloc]initWithFormat:@"</br><table><tr><td colspan=\"2\">Max Fuse</td><td colspan=\"2\">Min Fuse</td></tr><tr><td>kVA</td><td>%@</td><td>kVA</td><td>%@</td></tr><tr><td>Bayonet</td><td>%@</td><td>Bayonet</td><td>%@</td></tr><tr><td>NX</td><td>%@</td><td>NX</td><td>%@</td></tr><tr><td>S&C SM</td><td>%@</td><td>S&C SM</td><td>%@</td></tr></table>",_calugMax.KVA,_calugMin.KVA,[self roundingUp:_calugMax.Bayonet andDecimalPlace:0],[self roundingUp:_calugMin.Bayonet andDecimalPlace:0],_calugMax.NX,_calugMin.NX,_calugMax.SnCSM,_calugMax.SnCSM];
    
    emailBody = [ emailBody stringByAppendingString:emailAnw];
    emailBody = [ emailBody stringByAppendingString:fuses];
    
    [[self delegate]giveFormlaDetails:emailBody];
    [[self delegate]giveFormlaInformation:@"Transformer Rating calculates the available full load amps and fault current on the primary and secondary sides of a transformer by entering kVA, phase to phase primary voltage and phase to phase secondary voltage.  It also estimates appropriate fuse and breaker amperages."];
    [[self delegate]giveFormlaTitle:@"Transformer Rating"];
}

-(void)setInfo{
    _info = @"Transformer Rating calculates the available full load amps and fault current on the primary and secondary sides of a transformer by entering kVA, phase to phase primary voltage and phase to phase secondary voltage.  It also estimates appropriate fuse and breaker amperages.\n\nEnter the transformer full load rating in kVA.\nEnter the phase to phase primary voltage.\nEnter the phase to phase secondary voltage.\n\nFull load amps and available fault current on the primary and secondary of transformer will be calculated, along with maximum (300%) protective primary fuse, minimum (125%) primary protective fuse, and maximum secondary breaker (125%) size.\n\nTo modify the Impedance Table kVA sizes and Impedances, select the “Configure” button.  To negate the modifications select the “Default” button.\n\nTo share the results select the “email” button.";
}
@end

#pragma mark - TransformerRatingImpedanceCell

@implementation TransformerRatingImpedanceCell


@end

#pragma mark - TransformerRatingEditImpedanceCell

@implementation TransformerRatingEditImpedanceCell

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    TRCImpedance * updated = [[ TRCImpedance alloc]init];
    if (textField == self.KVATxt)
        [updated setKVA:[textField.text floatValue]];
    else
        [updated setKVA:[self.KVATxt.text floatValue]];
    
    if (textField == self.V208Txt)
        [updated setV208:[textField.text floatValue]];
    else
        [updated setV208:[self.V208Txt.text floatValue]];
    if (textField == self.V480Txt)
        [updated setV480:[textField.text floatValue]];
    else
        [updated setV480:[self.V480Txt.text floatValue]];
    
    [[self delegate]updateTransformerImpedance:updated andIndexPath:(int)self.tag];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.V480Txt || textField == self.V208Txt ){
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(\\d{0,9})?(\\.\\d{0,9})?$" options:0 error:nil];
        NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
        BOOL x = (match != nil);
        [[self delegate]canAddAnotherImpedance:(x && s.length>0)];
        return x;
    }else {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
        NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
        BOOL x = (match != nil);
        [[self delegate]canAddAnotherImpedance:(x && s.length>0)];
        return x;
    }
}
-(void)OneAtATime{
    [[self delegate]canAddAnotherImpedance:NO];
}

@end
