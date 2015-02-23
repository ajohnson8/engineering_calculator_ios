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
    InformationViewController *_informationVC;
    NSString *_info;
    TFCSUBD *_calSubd;

}

@end

@implementation SubdivisionLoadFormula
@synthesize subDivLoadVar,quantityPickerPopover = _quantityPickerPopover;

#pragma mark - Life cycle



-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [_quantityPickerPopover dismissPopoverAnimated:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_xfrmrTVC reloadData];
    
    [_voltAmpsTxt setText:[NSString stringWithFormat:@"%@",subDivLoadVar.voltAmps]];
    [_voltAmpsTxt setTag:0];
    [_voltTxt setText:[NSString stringWithFormat:@"%@",subDivLoadVar.volts]];
    [_voltTxt setTag:1];
    
    [_voltAmpsTxt setDelegate:self];
    [_voltTxt setDelegate:self];
    
    UIBarButtonItem * configure = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(pressedConfig:)];
    [[self.navigationController.viewControllers.lastObject navigationItem] setRightBarButtonItem:configure];
    
    UIBarButtonItem * back = [[UIBarButtonItem alloc]initWithTitle:@"Info" style:UIBarButtonItemStylePlain target:self action:@selector(pressedInfo:)];
    [[self.navigationController.viewControllers.lastObject navigationItem] setLeftBarButtonItem:back];

    [self configureMode:0];
}


#pragma mark - IBActions
- (IBAction)pressedInfo:(id)sender {

    [self setInfo];
    _informationVC = [[InformationViewController alloc]init];
    [_informationVC setInfoTitle:@"Subdivision Load Information"];
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
    
    [_calulationTotal setText:[NSString stringWithFormat:@"Full Load : %i",0]];
    [_xfrmrTVC reloadData];
}

- (IBAction)addSizeAction:(id)sender {
    XFRMR *temp = [[XFRMR alloc]init];
    [subDivLoadVar addXFRMR:temp];
    [_xfrmrTVC reloadData];
}
- (IBAction)pressedClear:(id)sender {
    for (int x = 0 ; x < subDivLoadVar.xfrmr.count; x++) {
        XFRMR * temp = subDivLoadVar.xfrmr[x];
        [temp setQtyl:0];
        [subDivLoadVar updateXFRMRSize:temp andIndex:x];
    }
    [_calulationTotal setText:@""];
    [_recommendedFuse setText:@""];
    [_xfrmrTVC reloadData];
}

- (IBAction)resetDefaults:(id)sender {
    
    if (_config) {
        
        NSData* myDataXFRMR = [NSKeyedArchiver archivedDataWithRootObject:[subDivLoadVar xfrmr]];
        [UICKeyChainStore setData:myDataXFRMR forKey:@"SystemDefaultsXFRMR"];
        
        NSData* myDataVolts = [NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:(int)[_voltTxt.text integerValue]]];
        [UICKeyChainStore setData:myDataVolts forKey:@"SystemDefaultsVolts"];
        
        NSData* myDataKilovolt_Amps = [NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:(int)[_voltAmpsTxt.text integerValue]]];
        [UICKeyChainStore setData:myDataKilovolt_Amps forKey:@"SystemDefaultsKilovolt_Amps"];
        
        [TSMessage showNotificationInViewController:self.navigationController.viewControllers.lastObject title:@"SubdivisionLoadFormula" subtitle:@"Defaults has been set." type:TSMessageNotificationTypeSuccess duration:1.5];
        
        
    }else {
        NSData* myDataXFRMR = [UICKeyChainStore dataForKey:@"SystemDefaultsXFRMR"];
        NSMutableArray* defaultSize = [NSKeyedUnarchiver unarchiveObjectWithData:myDataXFRMR];
        
        NSData* myDataVolts = [UICKeyChainStore dataForKey:@"SystemDefaultsVolts"];
        NSNumber* volts = [NSKeyedUnarchiver unarchiveObjectWithData:myDataVolts];
        
        NSData* myDataKilovolt_Amps = [UICKeyChainStore dataForKey:@"SystemDefaultsKilovolt_Amps"];
        NSNumber* kilovolt_Amps = [NSKeyedUnarchiver unarchiveObjectWithData:myDataKilovolt_Amps];
        
        [subDivLoadVar setDefaultVolts:volts];
        [subDivLoadVar setDefaultVoltAmps:kilovolt_Amps];
        [subDivLoadVar setDefaultXFRMR:defaultSize];
        
        [_voltAmpsTxt setText:[NSString stringWithFormat:@"%@",subDivLoadVar.voltAmps]];
        [_voltTxt setText:[NSString stringWithFormat:@"%@",subDivLoadVar.volts]];
        [_xfrmrTVC reloadData];
        
        [TSMessage showNotificationInViewController:self.navigationController.viewControllers.lastObject title:@"SubdivisionLoadFormula" subtitle:@"Defaults has been set." type:TSMessageNotificationTypeSuccess duration:1.5];
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
    if (subDivLoadVar.xfrmr.count>0)
        return subDivLoadVar.xfrmr.count+1;
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Transformer Sizes";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *simpleTableIdentifier = @"SetQuantity";
        XFRMRQtylCell *cell = (XFRMRQtylCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SetQuantity" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [cell.quantityLbl setHidden:_config];
        [cell.sizeLbl setText:@"kVA"];
        [cell.quantityLbl setText:@"Qty"];
        return cell;
    }
    
    if (!_config) {
       
        static NSString *simpleTableIdentifier = @"SetQuantity";
        XFRMRQtylCell *cell = (XFRMRQtylCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SetQuantity" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        XFRMR *temp = subDivLoadVar.xfrmr[indexPath.row-1];
        [cell.sizeLbl setText:[NSString stringWithFormat:@"%i",(int)temp.vKA]];
        [cell.quantityLbl setText:[NSString stringWithFormat:@"%i",(int)temp.qtyl]];
        [cell.quantityLbl setHidden:_config];
        [cell setDelegate:self];
        
        [self calulateXFRMRFULLLOAD];
        
        return cell;
    } else {
        static NSString *simpleTableIdentifier = @"SetSize";
        XFRMRSizeCell *cell = (XFRMRSizeCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        XFRMR *temp = subDivLoadVar.xfrmr[indexPath.row-1];
        
        [cell.sizeTxt setDelegate:cell];
        [cell setDelegate:self];
        [cell setTag:indexPath.row-1];
        [cell.sizeTxt setTag:indexPath.row-1];
        
        if (temp.vKA != 0 ){
            [cell.sizeTxt setText:[NSString stringWithFormat:@"%i",(int)temp.vKA]];}
        else {
            [cell.sizeTxt setText:@""];
            [cell.sizeTxt becomeFirstResponder];
            [cell toggleAddSize];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 0) {
        if (!_config && (_quantityPickerPopover==nil  ||  ![_quantityPickerPopover isPopoverVisible])) {
            XFRMRQtylCell *cell =(XFRMRQtylCell *) [tableView cellForRowAtIndexPath:indexPath];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
                UIViewController *popoverContent=[[UIViewController alloc] init];
                
                UITableView *tableView2=[[UITableView alloc] initWithFrame:CGRectMake(265, 680, 0, 0) style:UITableViewStylePlain];
                
                popoverContent.preferredContentSize=CGSizeMake(200, 420);
                popoverContent.view=tableView2; //Adding tableView to popover
                tableView2.delegate = cell;
                tableView2.dataSource = cell;
                
                _quantityPickerPopover = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
                [_quantityPickerPopover setDelegate:self];
                _quantityPickerPopover.contentViewController.preferredContentSize = CGSizeMake(150, 200);
                [_quantityPickerPopover presentPopoverFromRect:CGRectMake(cell.frame.size.width, cell.frame.size.height/2, 0, 0) inView:cell
                                      permittedArrowDirections:UIPopoverArrowDirectionLeft
                                                      animated:NO];
                
            }else {
                UITableViewController *tableView = [[UITableViewController alloc]init];
                tableView.tableView.delegate = cell;
                tableView.tableView.dataSource = cell;
                
                [self.navigationController pushViewController:tableView animated:YES];
            }

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
        XFRMR *temp = subDivLoadVar.xfrmr[indexPath.row-1];
        [self deleteXFRMR:temp];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationLeft];
        
        if (temp.vKA == 0  && temp.qtyl == 0)
            [self canAddAnother:YES];
        [self.xfrmrTVC reloadData];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 0) {
        [subDivLoadVar setDefaultVoltAmps:[NSNumber numberWithInt:(int)[textField.text integerValue]]];
    }else {
        [subDivLoadVar setDefaultVolts:[NSNumber numberWithInt:(int)[textField.text integerValue]]];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
    
    return (match != nil);
}

#pragma  mark - PopoverControllerDelegate
-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    return YES;
}


#pragma  mark - Calulations and Editting
-(void)calulateXFRMRFULLLOAD{
    _calSubd = [[TFCSUBD alloc]init];
    [_calSubd setCKVAnPhase:[NSString stringWithFormat:@"<%f",[subDivLoadVar calulateXFRMRFullLoad]]];
    [_calulationTotal setText:[NSString stringWithFormat:@"Full Load : %f",[subDivLoadVar calulateXFRMRFullLoad]]];
    
    id temp = [FuseWizardFormula sreachForFuseByTempFuseType:_calSubd];
    
    if ([temp isKindOfClass:[NSString class]])
        [_recommendedFuse setText:temp];
    else if ([temp isKindOfClass:[TFCSUBD class]] && [subDivLoadVar calulateXFRMRFullLoad] != 0){
        _calSubd = temp;
        [_recommendedFuse setText:[NSString stringWithFormat:@"SUBD\nkVA %@\nS&C STD %@",_calSubd.CKVAnPhase,[self roundingUp:_calSubd.SnCSTD andDecimalPlace:0]]];
    } else {
        [_recommendedFuse setText:@""];
    }
}


#pragma  mark - XFRMRQtylCellDelegate

-(void)updateXFRMRQuantity:(XFRMR *)xfrmr{
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
        [[self navigationController] popViewControllerAnimated:NO];
    }else{
        [_quantityPickerPopover dismissPopoverAnimated:NO];
        _quantityPickerPopover = nil;
    }
    for (int x = 0; x < subDivLoadVar.xfrmr.count; x++) {
        XFRMR *temp = subDivLoadVar.xfrmr[x];
        if (temp.vKA == xfrmr.vKA){
            subDivLoadVar.xfrmr[x] = xfrmr;
        }
    }
    [_xfrmrTVC reloadData];
    [self calulateXFRMRFULLLOAD];
}

-(void)updateXFRMR:(XFRMR *)xfrmr andIndexPath:(int)row{
    if (xfrmr.vKA == 0) {
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
        if (temp.vKA == xfrmr.vKA){
            [subDivLoadVar.xfrmr removeObjectAtIndex: x];
        }
    }
}

#pragma mark - Private Mark

-(void)initView{
    
    if (subDivLoadVar == nil) {
        
        subDivLoadVar = [[ SubdivisionLoadVariables alloc ]init];
        [_xfrmrTVC setDataSource:self];
        [_xfrmrTVC setDelegate:self];
        
        NSData* myDataXFRMR = [UICKeyChainStore dataForKey:@"SystemDefaultsXFRMR"];
        NSMutableArray* defaultSize = [NSKeyedUnarchiver unarchiveObjectWithData:myDataXFRMR];
        
        NSData* myDataVolts = [UICKeyChainStore dataForKey:@"SystemDefaultsVolts"];
        NSNumber* volts = [NSKeyedUnarchiver unarchiveObjectWithData:myDataVolts];
        
        NSData* myDataKilovolt_Amps = [UICKeyChainStore dataForKey:@"SystemDefaultsKilovolt_Amps"];
        NSNumber* kilovolt_Amps = [NSKeyedUnarchiver unarchiveObjectWithData:myDataKilovolt_Amps];
        
        [subDivLoadVar setDefaultVolts:volts];
        [subDivLoadVar setDefaultVoltAmps:kilovolt_Amps];
        [subDivLoadVar setDefaultXFRMR:defaultSize];
        
    }
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
        UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        tapper.cancelsTouchesInView = NO;
        [self.view addGestureRecognizer:tapper];
    }
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
        [self.navigationController.viewControllers.lastObject setTitle:@"Subdivision Load"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Configure"];
        [_voltTxt setTextColor:[UIColor grayColor]];
        _voltTxt.layer.borderColor=[[UIColor clearColor]CGColor];
        _voltTxt.layer.borderWidth=1.0;
        [_voltAmpsTxt setTextColor:[UIColor grayColor]];
        _voltAmpsTxt.layer.borderColor=[[UIColor clearColor]CGColor];
        _voltAmpsTxt.layer.borderWidth=1.0;
    }else {
        _config = YES;
        [UICKeyChainStore setString:@"YES" forKey:@"FormulaConfiguration"];
        [_defaultBtn setTitle:@"Set Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [self.navigationController.viewControllers.lastObject setTitle:@"Subdivision Load Configuration"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Done"];
        [_voltTxt setTextColor:[UIColor blackColor]];
        _voltTxt.layer.borderColor=[[UIColor blackColor]CGColor];
        _voltTxt.layer.borderWidth=1.0;
        [_voltAmpsTxt setTextColor:[UIColor blackColor]];
        _voltAmpsTxt.layer.borderColor=[[UIColor blackColor]CGColor];
        _voltAmpsTxt.layer.borderWidth=1.0;
    }
    [_addSizeBtn setHidden:!_config];
    [_addSizeBtn setEnabled:_config];
    [_voltTxt setEnabled:_config];
    [_voltAmpsTxt setEnabled:_config];
    
    
    [_xfrmrTVC deselectRowAtIndexPath:[_xfrmrTVC indexPathForSelectedRow] animated:YES];
    [_xfrmrTVC reloadData];

}
-(void)setInfo{
    _info = @"Subdivision Load Calculates the available full load amps on a phase conductor.  Select the quantity of the appropriate size transformer kVA sizes and the total full load amps will be calculated.\n\nTo add or modify the Transformer Sizes, Volt Amps, or Volts select the “Configure” button.  To negate the modifications select the “Default” button.\n\nTo share the results select the “E-mail” button.";
}

-(void)getEmail{
    NSString *emailBody = [[NSString alloc]initWithFormat:@"<table style=\"width:100\"><tr><td>Transformer Size</td><td>Quality</td></tr>"];
    
    for (XFRMR *temp in subDivLoadVar.xfrmr) {
        NSString *appendString;
        appendString = [NSString stringWithFormat: @"<tr><td>%f</td><td>%i</td></tr>",temp.vKA,temp.qtyl];
        emailBody = [emailBody stringByAppendingString:appendString];
    }
    
    emailBody = [emailBody stringByAppendingString:[NSString stringWithFormat: @"<tr><td>Full Amp Load</td><td>%f</td></tr></table>",subDivLoadVar.calulateXFRMRFullLoad]];
    
    emailBody = [emailBody stringByAppendingString:
                 [NSString stringWithFormat: @"</br><table>Recommended Fuse<tr><td>Subd</td></tr><tr><td>kVA</td><td>%@</td></tr><tr><td>S&C STD</td><td>%@</td></tr></table>",_calSubd.CKVAnPhase,[self roundingUp:_calSubd.SnCSTD andDecimalPlace:2]]];
    
    [[self delegate]giveFormlaDetails:emailBody];
    [[self delegate]giveFormlaInformation:@"Subdivision Load Calculates the available full load amps on a phase conductor."];
    [[self delegate]giveFormlaTitle:@"Subdivision Load"];
}

-(NSString *)roundingUp:(float)num andDecimalPlace:(int)place{
             
             NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
             
             [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
             [formatter setMaximumFractionDigits:place];
             [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
             
             return [formatter stringFromNumber:[NSNumber numberWithFloat:num]];
         }
@end

#pragma mark - Implementation XFRMRSizeCell
@implementation XFRMRSizeCell
@synthesize sizeTxt;

#pragma mark - UITextField
- (void)textFieldDidEndEditing:(UITextField *)textField{
    XFRMR * updated = [[ XFRMR alloc]init];
    [updated setQtyl:0];
    [updated setVKA:[textField.text floatValue]];
    [[self delegate]updateXFRMR:updated andIndexPath:(int)self.tag];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
    BOOL x = (match != nil);
    [[self delegate]canAddAnother:(x && string.length>0)];
    return x;
}

#pragma mark - Private Method
-(void)toggleAddSize{
    [[self delegate]canAddAnother:NO];
}



@end

#pragma mark - Implementation XFRMRQtylCell
@implementation XFRMRQtylCell
@synthesize quantityLbl;

#pragma mark - UITableView Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 21;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    [cell.textLabel setText:[NSString stringWithFormat:@"%i",(int)indexPath.row]];
    if (indexPath.row == [quantityLbl.text integerValue] )
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    else
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XFRMR * updated = [[ XFRMR alloc]init];
    [updated setVKA:[_sizeLbl.text floatValue]];
    [updated setQtyl:(int)indexPath.row];
    [[self delegate] updateXFRMRQuantity:updated];
}

@end
