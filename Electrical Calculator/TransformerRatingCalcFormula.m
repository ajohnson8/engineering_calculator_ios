//
//  TransformerRatingCalcFormula.m
//  Electrical Calculator
//
//  Created by Paul Marney on 2/3/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "TransformerRatingCalcFormula.h"

@interface TransformerRatingCalcFormula () {
    BOOL _config;
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
    
    UIBarButtonItem * configure = [[UIBarButtonItem alloc]initWithTitle:@"Configure" style:UIBarButtonItemStylePlain target:self action:@selector(pressedConfig:)];
    
    BOOL boolValue = [[UICKeyChainStore stringForKey:@"FormulaConfiguration"] boolValue];
    if (!boolValue) {
        _config = NO;
        [_defaultBtn setTitle:@"Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addImpedanceBtn setHidden:YES];
        [_addImpedanceBtn setEnabled:NO];
        [configure setTitle:@"Configure"];
        [[self.navigationController.viewControllers.lastObject navigationItem] setRightBarButtonItem:configure];
        [self.navigationController.viewControllers.lastObject setTitle:@"Transformer Rating"];
    }else {
        _config = YES;
        [_defaultBtn setTitle:@"Set Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addImpedanceBtn setHidden:NO];
        [_addImpedanceBtn setEnabled:YES];
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
        [_addImpedanceBtn setHidden:YES];
        [_addImpedanceBtn setEnabled:NO];
        [self.navigationController.viewControllers.lastObject setTitle:@"Transformer Rating"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Configure"];
    }else {
        _config = YES;
        [UICKeyChainStore setString:@"YES" forKey:@"FormulaConfiguration"];
        [_defaultBtn setTitle:@"Set Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addImpedanceBtn setHidden:NO];
        [_addImpedanceBtn setEnabled:YES];
        [self.navigationController.viewControllers.lastObject setTitle:@"Transformer Rating Configuration"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Done"];
    }
    [_impedanceTV deselectRowAtIndexPath:[_impedanceTV indexPathForSelectedRow] animated:YES];
    [_impedanceTV reloadData];
}

- (IBAction)addImpedanceAction:(id)sender {
    [_impedanceTV endEditing:YES];
    TRCImpedance *temp = [[TRCImpedance alloc]init];
    [_transformerRateCalcV addTRCImpedances:temp];
    [_impedanceTV reloadData];
    [_addImpedanceBtn setEnabled:NO];
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
    
}

-(NSString *)roundingUp:(float)num andDecimalPlace:(int)place{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:place];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    
    return [formatter stringFromNumber:[NSNumber numberWithFloat:num]];
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
