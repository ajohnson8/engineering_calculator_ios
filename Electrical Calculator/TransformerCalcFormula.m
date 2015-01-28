//
//  TransformerCalcVariablesFormula.m
//  Electrical Calculator
//
//  Created by Paul Marney on 1/26/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "TransformerCalcFormula.h"

@interface TransformerCalcFormula (){
    BOOL _config;
    TCPhase *_selectedPhase;
    TCLLSec *_selectedLLSec;
}

@end

@implementation TransformerCalcFormula
@synthesize kilaVoltTxt = _kilaVoltTxt,ampsTxt = _ampsTxt,tcPhaseTVC = _tcPhaseTVC,tcLLSecTVC = _tcLLSecTVC,tcFLAPLlb = _tcFLAPLlb,tcFLASLlb = _tcFLASLlb,tcAFCPLlb = _tcAFCPLlb,tcAFCSLlb = _tcAFCSLlb,addLLVoltsBtn = _addLLVoltsBtn,defaultBtn=_defaultBtn,transformerCalcV;

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_kilaVoltTxt setDelegate:self];
    [_ampsTxt setDelegate:self];
    
    BOOL boolValue = [[UICKeyChainStore stringForKey:@"SubdivisionLoadFormulaConfig"] boolValue];
    if (!boolValue) {
        _config = NO;
        [_defaultBtn setTitle:@"Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addLLVoltsBtn setHidden:YES];
        [_addLLVoltsBtn setEnabled:NO];
    }else {
        _config = YES;
        [_defaultBtn setTitle:@"Set Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addLLVoltsBtn setHidden:NO];
        [_addLLVoltsBtn setEnabled:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)pressedConfig:(id)sender {
    BOOL boolValue = [[UICKeyChainStore stringForKey:@"SubdivisionLoadFormulaConfig"] boolValue];
    [self.view endEditing:YES];
    
    if (boolValue) {
        _config = NO;
        [UICKeyChainStore setString:@"NO" forKey:@"SubdivisionLoadFormulaConfig"];
        [_defaultBtn setTitle:@"Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addLLVoltsBtn setHidden:YES];
        [_addLLVoltsBtn setEnabled:NO];
    }else {
        _config = YES;
        [UICKeyChainStore setString:@"YES" forKey:@"SubdivisionLoadFormulaConfig"];
        [_defaultBtn setTitle:@"Set Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addLLVoltsBtn setHidden:NO];
        [_addLLVoltsBtn setEnabled:YES];
    }
    
    [_tcPhaseTVC deselectRowAtIndexPath:[_tcPhaseTVC indexPathForSelectedRow] animated:YES];
    [_tcLLSecTVC deselectRowAtIndexPath:[_tcLLSecTVC indexPathForSelectedRow] animated:YES];
    [_tcLLSecTVC reloadData];
    [_tcPhaseTVC reloadData];
}

- (IBAction)addLLVoltAction:(id)sender {
    [_tcLLSecTVC endEditing:YES];
    TCLLSec *temp = [[TCLLSec alloc]init];
    [transformerCalcV addTCLLSec:temp];
    [_tcLLSecTVC reloadData];
    [_addLLVoltsBtn setEnabled:NO];
}

- (IBAction)resetDefaults:(id)sender {
    
    if (_config) {
        
        NSData* myDataArrayPhase = [NSKeyedArchiver archivedDataWithRootObject:[transformerCalcV phases]];
        NSData* myDataArrayLLSec = [NSKeyedArchiver archivedDataWithRootObject:[transformerCalcV llSecs]];
        
        [UICKeyChainStore setData:myDataArrayLLSec forKey:@"SystemDefaultsArrayLLSec"];
        [UICKeyChainStore setData:myDataArrayPhase forKey:@"SystemDefaultsArrayPhase"];
        
    }else {
        NSData* myDataArrayPhase = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayPhase"];
        NSMutableArray* defaultPhases = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayPhase];
        
        NSData* myDataArrayLLSec = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayLLSec"];
        NSMutableArray* defaultLLSecs = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayLLSec];
        
        [transformerCalcV setDefaultsTCLLSec:defaultLLSecs];
        [transformerCalcV setDefaultsTCPhase:defaultPhases];
        [_tcLLSecTVC reloadData];
        [_tcPhaseTVC reloadData];
        
        _selectedPhase = nil;
        _selectedLLSec = nil;
        [_tcPhaseTVC deselectRowAtIndexPath:[_tcPhaseTVC indexPathForSelectedRow] animated:YES];
        [_tcLLSecTVC deselectRowAtIndexPath:[_tcLLSecTVC indexPathForSelectedRow] animated:YES];
        
        [_kilaVoltTxt setText:@""];
        [_ampsTxt setText:@""];
        
        [transformerCalcV setDefaultskilovolt_amps:0];
        [transformerCalcV setDefaultsAmpsPer:0];
        
        [_tcAFCPLlb setText:[self roundingUp:0.00]];
        [_tcAFCSLlb setText:[self roundingUp:0.00]];
        [_tcFLAPLlb setText:[self roundingUp:0.00]];
        [_tcFLASLlb setText:[self roundingUp:0.00]];

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
        if (tableView == _tcLLSecTVC) {
            return 44;
        }else {
            return 130;
        }
    } else {
        return 50;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == _tcLLSecTVC) {
        return @"Sec. L-L Volts";
    }else {
        return @"Phase (1 or 3)";
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tcLLSecTVC) {
        return transformerCalcV.llSecs.count;
    }else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    if (_config) {
        if (tableView == _tcLLSecTVC) {
            static NSString *simpleTableIdentifier = @"EditLLVolts";
            TransformerLLCell *cell = (TransformerLLCell *)[_tcLLSecTVC dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditLLVolts" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            TCLLSec *temp = transformerCalcV.llSecs[indexPath.row];
            
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
            TransformerPhaseCell *cell = (TransformerPhaseCell *)[_tcPhaseTVC dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditPhase" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            TCPhase *temp = transformerCalcV.phases[indexPath.row];
            
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
        if (tableView == _tcLLSecTVC) {
            static NSString *simpleTableIdentifier = @"Cell";
            UITableViewCell *cell = (UITableViewCell *)[_tcLLSecTVC dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            TCLLSec *temp = transformerCalcV.llSecs[indexPath.row];
            
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
            UITableViewCell *cell = (UITableViewCell *)[_tcPhaseTVC dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            TCPhase *temp = transformerCalcV.phases[indexPath.row];
            
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
        if (tableView == _tcLLSecTVC) {
            _selectedLLSec = [[TCLLSec alloc]init];
            _selectedLLSec = transformerCalcV.llSecs[indexPath.row];
        }else{
            _selectedPhase = [[TCPhase alloc]init];
            _selectedPhase = transformerCalcV.phases[indexPath.row];
        }
    }
    if (_selectedLLSec && _selectedPhase) {
        [self calulateTotal];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tcLLSecTVC) {
        return _config;
    }else {
        return NO;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tcLLSecTVC) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            TCLLSec *temp = transformerCalcV.llSecs[indexPath.row];
            [transformerCalcV deleteTCLLSec:temp];
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
            [transformerCalcV setDefaultsAmpsPer:[s floatValue]];
        }else {
            [transformerCalcV setDefaultskilovolt_amps:[s floatValue]];
        }
        [self calulateTotal];
    }
    return (match != nil);
}
#pragma mark - TransformerPhaseCellDelegate

-(void)updateTransformerPhase:(TCPhase *)phase andIndexPath:(int)row{
    [transformerCalcV updateTCPhase:phase andIndex:row];
    [_tcPhaseTVC reloadData];
}

#pragma mark - TransformerLLCellDelegate

-(void)updateTransformerLL:(TCLLSec *)LLSec andIndexPath:(int)row{
    if (LLSec.llSecVaule == 0) {
        [transformerCalcV deleteTCLLSec:LLSec];
        [self canAddAnotherLLSec:YES];
    } else
        [transformerCalcV updateTCLLSec:LLSec andIndex:row];
    
    [_tcLLSecTVC reloadData];
}

-(void)canAddAnotherLLSec:(BOOL)check{
    [_addLLVoltsBtn setEnabled:check];
}

#pragma mark - Private Methods

-(void)initView{
    
    if (transformerCalcV == nil) {
        
        NSData *t =[UICKeyChainStore dataForKey:@"SystemDefaultsArrayLLSec"];
        NSData *t2 =[UICKeyChainStore dataForKey:@"SystemDefaultsArrayPhase"];
        
        transformerCalcV = [[ TransformerCalcVariables alloc ]init];
        
        if (t.length == 0  || t2.length == 0) {

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
            
            NSMutableArray *defaultLLSec = [[NSMutableArray alloc]init];
            [defaultLLSec addObject:[NSNumber numberWithInt:208]];
            [defaultLLSec addObject:[NSNumber numberWithInt:240]];
            [defaultLLSec addObject:[NSNumber numberWithInt:480]];
            [defaultLLSec addObject:[NSNumber numberWithInt:577]];
            
            [transformerCalcV setDefaultsTCLLSec:defaultLLSec];
            [transformerCalcV setDefaultsTCPhase:defaultPhase];
            [transformerCalcV setDefaultskilovolt_amps:750];
            [transformerCalcV setDefaultsAmpsPer:5.67];
            [_kilaVoltTxt setText:[NSString stringWithFormat:@"%i",750]];
            [_ampsTxt setText:[NSString stringWithFormat:@"%f",5.67]];
            
            [_tcPhaseTVC setDataSource:self];
            [_tcPhaseTVC setDelegate:self];
            [_tcLLSecTVC setDataSource:self];
            [_tcLLSecTVC setDelegate:self];
            
            NSData* myDataArrayPhase = [NSKeyedArchiver archivedDataWithRootObject:defaultPhase];
            [UICKeyChainStore setData:myDataArrayPhase forKey:@"SystemDefaultsArrayPhase"];
            
            NSData* myDataArrayLLSec = [NSKeyedArchiver archivedDataWithRootObject:defaultLLSec];
            [UICKeyChainStore setData:myDataArrayLLSec forKey:@"SystemDefaultsArrayLLSec"];
            
            [UICKeyChainStore setString:@"NO" forKey:@"SubdivisionLoadFormulaConfig"];
            
        }else{
            NSData* myDataArrayPhase = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayPhase"];
            NSMutableArray* defaultPhases = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayPhase];
            
            NSData* myDataArrayLLSec = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayLLSec"];
            NSMutableArray* defaultLLSecs = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayLLSec];
            
            [transformerCalcV setDefaultsTCLLSec:defaultLLSecs];
            [transformerCalcV setDefaultsTCPhase:defaultPhases];
            
            [_tcPhaseTVC setDataSource:self];
            [_tcPhaseTVC setDelegate:self];
            [_tcLLSecTVC setDataSource:self];
            [_tcLLSecTVC setDelegate:self];
            
            _selectedPhase = nil;
            _selectedLLSec = nil;
            [_tcPhaseTVC deselectRowAtIndexPath:[_tcPhaseTVC indexPathForSelectedRow] animated:YES];
            [_tcLLSecTVC deselectRowAtIndexPath:[_tcLLSecTVC indexPathForSelectedRow] animated:YES];
            
            [_kilaVoltTxt setText:@""];
            [_ampsTxt setText:@""];
            
            [transformerCalcV setDefaultskilovolt_amps:0];
            [transformerCalcV setDefaultsAmpsPer:0];
            
            [_tcAFCPLlb setText:[self roundingUp:0.00]];
            [_tcAFCSLlb setText:[self roundingUp:0.00]];
            [_tcFLAPLlb setText:[self roundingUp:0.00]];
            [_tcFLASLlb setText:[self roundingUp:0.00]];

        }
        
    }
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
        UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        tapper.cancelsTouchesInView = NO;
        [self.view addGestureRecognizer:tapper];
    }
    
    [_tcAFCPLlb setText:[self roundingUp:0.00]];
    [_tcAFCSLlb setText:[self roundingUp:0.00]];
    [_tcFLAPLlb setText:[self roundingUp:0.00]];
    [_tcFLASLlb setText:[self roundingUp:0.00]];
}

-(void)calulateTotal{
    [_tcFLAPLlb setText:[self roundingUp:[transformerCalcV calulateFullLoadAmpsOnPri:_selectedPhase]]];
    [_tcFLASLlb setText:[self roundingUp:[transformerCalcV calulateFullLoadAmpsOnSec:_selectedPhase andLLSec:_selectedLLSec]]];
    [_tcAFCPLlb setText:[self roundingUp:[transformerCalcV calulateAvailablFaultCurrentPri:_selectedPhase]]];
    [_tcAFCSLlb setText:[self roundingUp:[transformerCalcV calulateAvailablFaultCurrentSec:_selectedPhase andLLSec:_selectedLLSec]]];
    
}

-(NSString *)roundingUp:(float)num{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    
    return [formatter stringFromNumber:[NSNumber numberWithFloat:num]];
}

@end



@implementation TransformerPhaseCell
@synthesize phaseIDTxt,phaseVauleTxt,phaseLLTxt,delegate;
#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    TCPhase * updated = [TCPhase new];
    [updated setPhaseID:[phaseIDTxt.text integerValue]];
    [updated setPhaseLL:[phaseLLTxt.text floatValue]];
    [updated setPhasevalue:[phaseVauleTxt.text floatValue]];
    
    [[self delegate]updateTransformerPhase:updated andIndexPath:self.tag];
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
    [[self delegate]updateTransformerLL:updated andIndexPath:self.tag];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
    BOOL x = (match != nil);
    [[self delegate]canAddAnotherLLSec:(x && string.length>0)];
    return x;
}
-(void)OneAtATime{
    [[self delegate]canAddAnotherLLSec:NO];
}

@end