//
//  SubdivisionLoadFormula.m
//  Electrical Calculator
//
//  Created by Paul Marney on 1/21/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "SubdivisionLoadFormula.h"

@interface SubdivisionLoadFormula () {
    
    BOOL _config;
}

@end

@implementation SubdivisionLoadFormula
@synthesize subDivLoadVar;

#pragma mark - Life cycle

-(void)initView{
    
    if (subDivLoadVar == nil) {
        
        if ([UICKeyChainStore dataForKey:@"SystemDefaultsXFRMR"] &&
            [UICKeyChainStore dataForKey:@"SystemDefaultsVolts"] &&
            [UICKeyChainStore dataForKey:@"SystemDefaultsKilovolt_Amps"]) {
            
            
            subDivLoadVar = [[ SubdivisionLoadVariables alloc ]init];
            
            NSData* myDataXFRMR = [UICKeyChainStore dataForKey:@"SystemDefaultsXFRMR"];
            NSMutableArray* defaultSize = [NSKeyedUnarchiver unarchiveObjectWithData:myDataXFRMR];
            
            NSData* myDataVolts = [UICKeyChainStore dataForKey:@"SystemDefaultsVolts"];
            NSNumber* volts = [NSKeyedUnarchiver unarchiveObjectWithData:myDataVolts];
            
            NSData* myDataKilovolt_Amps = [UICKeyChainStore dataForKey:@"SystemDefaultsKilovolt_Amps"];
            NSNumber* kilovolt_Amps = [NSKeyedUnarchiver unarchiveObjectWithData:myDataKilovolt_Amps];
            
            [subDivLoadVar setDefaultVolts:volts];
            [subDivLoadVar setDefaultKilovolt_Amps:kilovolt_Amps];
            [subDivLoadVar setDefaultXFRMR:defaultSize];
            
            [_xfrmrTVC setDataSource:self];
            [_xfrmrTVC setDelegate:self];
            
            
        } else {
            subDivLoadVar = [[ SubdivisionLoadVariables alloc ]init];
            NSMutableArray *defaultSize = [[NSMutableArray alloc]init];
            [defaultSize addObject:[NSNumber numberWithInt:5]];
            [defaultSize addObject:[NSNumber numberWithInt:10]];
            [defaultSize addObject:[NSNumber numberWithInt:15]];
            [defaultSize addObject:[NSNumber numberWithInt:25]];
            [defaultSize addObject:[NSNumber numberWithInt:75]];
            [defaultSize addObject:[NSNumber numberWithInt:100]];
            
            [subDivLoadVar setDefaultVolts:[NSNumber numberWithInt:7200]];
            [subDivLoadVar setDefaultKilovolt_Amps:[NSNumber numberWithInt:1000]];
            [subDivLoadVar setDefaultXFRMR:defaultSize];
            
            [_xfrmrTVC setDataSource:self];
            [_xfrmrTVC setDelegate:self];
            
            NSData* myDataXFRMR = [NSKeyedArchiver archivedDataWithRootObject:defaultSize];
            [UICKeyChainStore setData:myDataXFRMR forKey:@"SystemDefaultsXFRMR"];
            
            NSData* myDataVolts = [NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:7200]];
            [UICKeyChainStore setData:myDataVolts forKey:@"SystemDefaultsVolts"];
            
            NSData* myDataKilovolt_Amps = [NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:1000]];
            [UICKeyChainStore setData:myDataKilovolt_Amps forKey:@"SystemDefaultsKilovolt_Amps"];
        }
    }
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_xfrmrTVC reloadData];
    
    [_kilaVoltAmpsTxt setText:[NSString stringWithFormat:@"%@",subDivLoadVar.kilovolt_amps]];
    [_kilaVoltAmpsTxt setTag:0];
    [_voltTxt setText:[NSString stringWithFormat:@"%@",subDivLoadVar.volts]];
    [_voltTxt setTag:1];
    
    [_kilaVoltAmpsTxt setDelegate:self];
    [_voltTxt setDelegate:self];
    
    BOOL boolValue = [[UICKeyChainStore stringForKey:@"SubdivisionLoadFormulaConfig"] boolValue];
    if (!boolValue) {
        _config = NO;
        [_kilaVoltAmpsTxt setEnabled:NO];
        [_voltTxt setEnabled:NO];
        [_defaultBtn setTitle:@"Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addSizeBtn setHidden:YES];
    }else {
        _config = YES;
        [_kilaVoltAmpsTxt setEnabled:YES];
        [_voltTxt setEnabled:YES];
        [_defaultBtn setTitle:@"Set Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addSizeBtn setHidden:NO];
    }
}

#pragma mark - IBActions

- (IBAction)pressedConfig:(id)sender {
    BOOL boolValue = [[UICKeyChainStore stringForKey:@"SubdivisionLoadFormulaConfig"] boolValue];
    [self resignFirstResponder];
    if (boolValue) {
        _config = NO;
        [_kilaVoltAmpsTxt setEnabled:NO];
        [_voltTxt setEnabled:NO];
        [_defaultBtn setTitle:@"Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [UICKeyChainStore setString:@"NO" forKey:@"SubdivisionLoadFormulaConfig"];
        [_addSizeBtn setHidden:YES];
    }else {
        _config = YES;
        [_kilaVoltAmpsTxt setEnabled:YES];
        [_voltTxt setEnabled:YES];
        [_defaultBtn setTitle:@"Set Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [UICKeyChainStore setString:@"YES" forKey:@"SubdivisionLoadFormulaConfig"];
        [_addSizeBtn setHidden:NO];
    }
    [_calulationTotal setText:[NSString stringWithFormat:@"Full Load is : %i",0]];
    [_xfrmrTVC reloadData];
}

- (IBAction)addSizeAction:(id)sender {
    XFRMR *temp = [[XFRMR alloc]init];
    [subDivLoadVar addXFRMR:temp];
    [_xfrmrTVC reloadData];
}

- (IBAction)resetDefaults:(id)sender {
    
    if (_config) {
        
        NSData* myDataXFRMR = [NSKeyedArchiver archivedDataWithRootObject:[subDivLoadVar xfrmr]];
        [UICKeyChainStore setData:myDataXFRMR forKey:@"SystemDefaultsXFRMR"];
        
        NSData* myDataVolts = [NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:[_voltTxt.text integerValue]]];
        [UICKeyChainStore setData:myDataVolts forKey:@"SystemDefaultsVolts"];
        
        NSData* myDataKilovolt_Amps = [NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:[_kilaVoltAmpsTxt.text integerValue]]];
        [UICKeyChainStore setData:myDataKilovolt_Amps forKey:@"SystemDefaultsKilovolt_Amps"];
        
        [TSMessage showNotificationInViewController:self title:@"SubdivisionLoadFormula" subtitle:@"Defaults has been set." type:TSMessageNotificationTypeSuccess duration:1.5];
        
        
    }else {
        NSData* myDataXFRMR = [UICKeyChainStore dataForKey:@"SystemDefaultsXFRMR"];
        NSMutableArray* defaultSize = [NSKeyedUnarchiver unarchiveObjectWithData:myDataXFRMR];
        
        NSData* myDataVolts = [UICKeyChainStore dataForKey:@"SystemDefaultsVolts"];
        NSNumber* volts = [NSKeyedUnarchiver unarchiveObjectWithData:myDataVolts];
        
        NSData* myDataKilovolt_Amps = [UICKeyChainStore dataForKey:@"SystemDefaultsKilovolt_Amps"];
        NSNumber* kilovolt_Amps = [NSKeyedUnarchiver unarchiveObjectWithData:myDataKilovolt_Amps];
        
        [subDivLoadVar setDefaultVolts:volts];
        [subDivLoadVar setDefaultKilovolt_Amps:kilovolt_Amps];
        [subDivLoadVar setDefaultXFRMR:defaultSize];
        
        [_kilaVoltAmpsTxt setText:[NSString stringWithFormat:@"%@",subDivLoadVar.kilovolt_amps]];
        [_voltTxt setText:[NSString stringWithFormat:@"%@",subDivLoadVar.volts]];
        [_xfrmrTVC reloadData];
        
        [TSMessage showNotificationInViewController:self title:@"SubdivisionLoadFormula" subtitle:@"Defaults has been set." type:TSMessageNotificationTypeSuccess duration:1.5];
    }
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    
    [self.view endEditing:YES];
}

#pragma  mark - TableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return subDivLoadVar.xfrmr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_config) {
        static NSString *simpleTableIdentifier = @"SetQuantity";
        XFRMRQtylCell *cell = (XFRMRQtylCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SetQuantity" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NumberPadDoneBtn *doneNumBtn = [[NumberPadDoneBtn alloc]initWithFrame:CGRectMake(0,0,1,1)];
        
        XFRMR *temp = subDivLoadVar.xfrmr[indexPath.row];
        [cell.quantityTxt setDelegate:cell];
        [cell.sizeLbl setText:[NSString stringWithFormat:@"%i",(int)temp.size]];
        [cell.quantityTxt setText:@""];
         if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
        cell.quantityTxt.inputAccessoryView = doneNumBtn;
         }
        
        [cell setDelegate:self];
        return cell;
    } else {
        static NSString *simpleTableIdentifier = @"SetSize";
        XFRMRSizeCell *cell = (XFRMRSizeCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SetSize" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        XFRMR *temp = subDivLoadVar.xfrmr[indexPath.row];
        NumberPadDoneBtn *doneNumBtn = [[NumberPadDoneBtn alloc]initWithFrame:CGRectMake(0,0,1,1)];
        
        if (temp.size != 0 ){
            [cell.SizeTxt setText:[NSString stringWithFormat:@"%i",(int)temp.size]];}
        else {
            [cell.SizeTxt setText:@""];
            [cell OneAtATime];
        }
        [cell.SizeTxt setDelegate:cell];
         if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
             [cell.SizeTxt setInputAccessoryView:doneNumBtn];
         }
        [cell setDelegate:self];
        [cell setTag:indexPath.row];
        
        return cell;
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return _config;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        XFRMR *temp = subDivLoadVar.xfrmr[indexPath.row];
        [self deleteXFRMR:temp];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationLeft];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 0) {
        [subDivLoadVar setDefaultKilovolt_Amps:[NSNumber numberWithInt:[textField.text integerValue]]];
    }else {
        [subDivLoadVar setDefaultVolts:[NSNumber numberWithInt:[textField.text integerValue]]];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
    
    return (match != nil);
}


#pragma  mark - Calulations and Editting
-(void)calulateXFRMRFULLLOAD{
    
    float FULLLOAD = 0.00;
    for (XFRMR *temp in subDivLoadVar.xfrmr) {
        float x = ((temp.size * [subDivLoadVar.kilovolt_amps floatValue])/[subDivLoadVar.volts floatValue])*temp.qtyl;
        FULLLOAD+=x;
    }
    NSLog(@"Full Load is : %f",FULLLOAD);
    [_calulationTotal setText:[NSString stringWithFormat:@"Full Load is : %f",FULLLOAD]];
    
}

#pragma  mark - XFRMRQtylCellDelegate

-(void)updateXFRMRQuantity:(XFRMR *)xfrmr{
    for (int x = 0; x < subDivLoadVar.xfrmr.count; x++) {
        XFRMR *temp = subDivLoadVar.xfrmr[x];
        if (temp.size == xfrmr.size){
            subDivLoadVar.xfrmr[x] = xfrmr;
        }
    }
    [self calulateXFRMRFULLLOAD];
}

-(void)updateXFRMR:(XFRMR *)xfrmr andIndexPath:(int)row{
    if (xfrmr.size == 0) {
        [self deleteXFRMR:xfrmr];
        [self canAddAnother:YES];
    } else
        [subDivLoadVar updateXFRMRSize:xfrmr andIndex:row];
    [_xfrmrTVC reloadData];
}

-(void)canAddAnother:(BOOL)check{
    [_addSizeBtn setEnabled:check];
}

#pragma  mark - XFRMRVaules

-(void)addXFRMRQuantity:(XFRMR *)xfrmr{
    [subDivLoadVar addXFRMR:xfrmr];
}

-(void)deleteXFRMR:(XFRMR *)xfrmr{
    for (int x = 0; x < subDivLoadVar.xfrmr.count; x++) {
        XFRMR *temp = subDivLoadVar.xfrmr[x];
        if (temp.size == xfrmr.size){
            [subDivLoadVar.xfrmr removeObjectAtIndex: x];
        }
    }
}

@end

@implementation XFRMRSizeCell
@synthesize SizeTxt;

- (void)textFieldDidEndEditing:(UITextField *)textField{
    XFRMR * updated = [[ XFRMR alloc]init];
    [updated setQtyl:0];
    [updated setSize:[textField.text floatValue]];
    [[self delegate]updateXFRMR:updated andIndexPath:self.tag];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
    BOOL x = (match != nil);
    [[self delegate]canAddAnother:(x && string.length>0)];
    return x;
}
-(void)OneAtATime{
    [[self delegate]canAddAnother:NO];
}

@end

@implementation XFRMRQtylCell
@synthesize quantityTxt;

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    XFRMR * updated = [[ XFRMR alloc]init];
    [updated setSize:[_sizeLbl.text floatValue]];
    [updated setQtyl:[textField.text integerValue]];
    [[self delegate] updateXFRMRQuantity:updated];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
    
    if ((match != nil)) {
        XFRMR * updated = [[ XFRMR alloc]init];
        [updated setSize:[_sizeLbl.text floatValue]];
        [updated setQtyl:[s integerValue]];
        [[self delegate] updateXFRMRQuantity:updated];
    }
    return (match != nil);
}


@end
