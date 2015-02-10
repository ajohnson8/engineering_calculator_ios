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

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_kilaVoltAmpsTxt setDelegate:self];
    [_ampsTxt setDelegate:self];
    
    UIBarButtonItem * configure = [[UIBarButtonItem alloc]initWithTitle:@"Configure" style:UIBarButtonItemStylePlain target:self action:@selector(pressedConfig:)];
    
    BOOL boolValue = [[UICKeyChainStore stringForKey:@"FormulaConfiguration"] boolValue];
    if (!boolValue) {
        _config = NO;
        [_defaultBtn setTitle:@"Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addLLVoltsBtn setHidden:YES];
        [_addLLVoltsBtn setEnabled:NO];
        [self.navigationController.viewControllers.lastObject setTitle:@"Transformer"];
        [configure setTitle:@"Configure"];
        [[self.navigationController.viewControllers.lastObject navigationItem] setRightBarButtonItem:configure];
    }else {
        _config = YES;
        [_defaultBtn setTitle:@"Set Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addLLVoltsBtn setHidden:NO];
        [_addLLVoltsBtn setEnabled:YES];
        [self.navigationController.viewControllers.lastObject setTitle:@"Transformer Configuration"];
        [configure setTitle:@"Done"];
        [[self.navigationController.viewControllers.lastObject navigationItem] setRightBarButtonItem:configure];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [_addLLVoltsBtn setHidden:YES];
        [_addLLVoltsBtn setEnabled:NO];
        [self.navigationController.viewControllers.lastObject setTitle:@"Transformer"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Configure"];
    }else {
        _config = YES;
        [UICKeyChainStore setString:@"YES" forKey:@"FormulaConfiguration"];
        [_defaultBtn setTitle:@"Set Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addLLVoltsBtn setHidden:NO];
        [_addLLVoltsBtn setEnabled:YES];
        [self.navigationController.viewControllers.lastObject setTitle:@"Transformer Configuration"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Done"];
    }
    
    [_phaseTV deselectRowAtIndexPath:[_phaseTV indexPathForSelectedRow] animated:YES];
    [_secLLVoltTV deselectRowAtIndexPath:[_secLLVoltTV indexPathForSelectedRow] animated:YES];
    [_secLLVoltTV reloadData];
    [_phaseTV reloadData];
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
        
        [TSMessage showNotificationInViewController:self.navigationController.viewControllers.lastObject title:@"TransformerCalcFormula" subtitle:@"Defaults has been save." type:TSMessageNotificationTypeSuccess duration:1.5];
        
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
        
        [TSMessage showNotificationInViewController:self.navigationController.viewControllers.lastObject title:@"TransformerCalcFormula" subtitle:@"Defaults has been set." type:TSMessageNotificationTypeSuccess duration:1.5];
        
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
        if (indexPath.row == 0) {
            return NO;
        }
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
        
        NSData *t =[UICKeyChainStore dataForKey:@"SystemDefaultsArrayLLSec"];
        NSData *t2 =[UICKeyChainStore dataForKey:@"SystemDefaultsArrayPhase"];
        
        _transformerCalcV = [[ TransformerCalcVariables alloc ]init];
        
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
            
            [_transformerCalcV setDefaultsTCLLSec:defaultLLSec];
            [_transformerCalcV setDefaultsTCPhase:defaultPhase];
            [_transformerCalcV setDefaultskilovolt_amps:750];
            [_transformerCalcV setDefaultsAmpsPer:5.67];
            [_kilaVoltAmpsTxt setText:[NSString stringWithFormat:@"%i",750]];
            [_ampsTxt setText:[NSString stringWithFormat:@"%f",5.67]];
            
            [_phaseTV setDataSource:self];
            [_phaseTV setDelegate:self];
            [_secLLVoltTV setDataSource:self];
            [_secLLVoltTV setDelegate:self];
            
            NSData* myDataArrayPhase = [NSKeyedArchiver archivedDataWithRootObject:defaultPhase];
            [UICKeyChainStore setData:myDataArrayPhase forKey:@"SystemDefaultsArrayPhase"];
            
            NSData* myDataArrayLLSec = [NSKeyedArchiver archivedDataWithRootObject:defaultLLSec];
            [UICKeyChainStore setData:myDataArrayLLSec forKey:@"SystemDefaultsArrayLLSec"];
            
            [UICKeyChainStore setString:@"NO" forKey:@"FormulaConfiguration"];
            
        }else{
            NSData* myDataArrayPhase = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayPhase"];
            NSMutableArray* defaultPhases = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayPhase];
            
            NSData* myDataArrayLLSec = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayLLSec"];
            NSMutableArray* defaultLLSecs = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayLLSec];
            
            [_transformerCalcV setDefaultsTCLLSec:defaultLLSecs];
            [_transformerCalcV setDefaultsTCPhase:defaultPhases];
            
            [_phaseTV setDataSource:self];
            [_phaseTV setDelegate:self];
            [_secLLVoltTV setDataSource:self];
            [_secLLVoltTV setDelegate:self];
            
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
            
        }
        
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