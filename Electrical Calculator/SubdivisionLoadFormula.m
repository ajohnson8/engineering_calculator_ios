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
@synthesize subDivLoadVar,quantityPickerPopover = _quantityPickerPopover;

#pragma mark - Life cycle



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
    
    UIBarButtonItem * configure = [[UIBarButtonItem alloc]initWithTitle:@"Configure" style:UIBarButtonItemStylePlain target:self action:@selector(pressedConfig:)];
    
    BOOL boolValue = [[UICKeyChainStore stringForKey:@"FormulaConfiguration"] boolValue];
    if (!boolValue) {
        _config = NO;
        [_kilaVoltAmpsTxt setEnabled:NO];
        [_voltTxt setEnabled:NO];
        [_defaultBtn setTitle:@"Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addSizeBtn setHidden:YES];
        [configure setTitle:@"Configure"];
        [[self.navigationController.viewControllers.lastObject navigationItem] setRightBarButtonItem:configure];
        [self.navigationController.viewControllers.lastObject setTitle:@"Subdivision Load"];
    }else {
        _config = YES;
        [_kilaVoltAmpsTxt setEnabled:YES];
        [_voltTxt setEnabled:YES];
        [_defaultBtn setTitle:@"Set Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addSizeBtn setHidden:NO];
        [configure setTitle:@"Done"];
        [[self.navigationController.viewControllers.lastObject navigationItem] setRightBarButtonItem:configure];
        [self.navigationController.viewControllers.lastObject  setTitle:@"Subdivision Load Configuration"];
        
    }
}


#pragma mark - IBActions

- (IBAction)pressedConfig:(id)sender {
    
    [UIView transitionWithView:self.view
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{ }
                    completion:NULL];
    
    BOOL boolValue = [[UICKeyChainStore stringForKey:@"FormulaConfiguration"] boolValue];
    [self resignFirstResponder];
    if (boolValue) {
        _config = NO;
        [_kilaVoltAmpsTxt setEnabled:NO];
        [_voltTxt setEnabled:NO];
        [_defaultBtn setTitle:@"Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [UICKeyChainStore setString:@"NO" forKey:@"FormulaConfiguration"];
        [_addSizeBtn setHidden:YES];
        [self.navigationController.viewControllers.lastObject  setTitle:@"Subdivision Load"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Configure"];
    }else {
        _config = YES;
        [_kilaVoltAmpsTxt setEnabled:YES];
        [_voltTxt setEnabled:YES];
        [_defaultBtn setTitle:@"Set Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [UICKeyChainStore setString:@"YES" forKey:@"FormulaConfiguration"];
        [_addSizeBtn setHidden:NO];
        [self.navigationController.viewControllers.lastObject  setTitle:@"Subdivision Load Configuration"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Done"];
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
        
        NSData* myDataVolts = [NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:(int)[_voltTxt.text integerValue]]];
        [UICKeyChainStore setData:myDataVolts forKey:@"SystemDefaultsVolts"];
        
        NSData* myDataKilovolt_Amps = [NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:(int)[_kilaVoltAmpsTxt.text integerValue]]];
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
        [subDivLoadVar setDefaultKilovolt_Amps:kilovolt_Amps];
        [subDivLoadVar setDefaultXFRMR:defaultSize];
        
        [_kilaVoltAmpsTxt setText:[NSString stringWithFormat:@"%@",subDivLoadVar.kilovolt_amps]];
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
        [cell.sizeLbl setText:@"Size"];
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
        [cell.sizeLbl setText:[NSString stringWithFormat:@"%i",(int)temp.size]];
        [cell.quantityLbl setText:[NSString stringWithFormat:@"%i",(int)temp.qtyl]];
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
        
        if (temp.size != 0 ){
            [cell.sizeTxt setText:[NSString stringWithFormat:@"%i",(int)temp.size]];}
        else {
            [cell.sizeTxt setText:@""];
            [cell.sizeTxt becomeFirstResponder];
            [cell toggleAddSize];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _xfrmrTVC && indexPath.row != 0) {
        if (!_config && (_quantityPickerPopover==nil  ||  ![_quantityPickerPopover isPopoverVisible])) {
            _quantityPickerPopover = nil;
            XFRMRQtylCell *cell =(XFRMRQtylCell *) [tableView cellForRowAtIndexPath:indexPath];
            [self createQuantityPopoverListWithCell:cell];
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
        [self.xfrmrTVC reloadData];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 0) {
        [subDivLoadVar setDefaultKilovolt_Amps:[NSNumber numberWithInt:(int)[textField.text integerValue]]];
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
    [_calulationTotal setText:[NSString stringWithFormat:@"Full Load is : %f",[subDivLoadVar calulateXFRMRFullLoad]]];
}

#pragma  mark - XFRMRQtylCellDelegate

-(void)updateXFRMRQuantity:(XFRMR *)xfrmr{
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
        [[self navigationController] popViewControllerAnimated:YES];
    }else{
        [_quantityPickerPopover dismissPopoverAnimated:NO];
        _quantityPickerPopover = nil;
    }
    for (int x = 0; x < subDivLoadVar.xfrmr.count; x++) {
        XFRMR *temp = subDivLoadVar.xfrmr[x];
        if (temp.size == xfrmr.size){
            subDivLoadVar.xfrmr[x] = xfrmr;
        }
    }
    [_xfrmrTVC reloadData];
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
        [subDivLoadVar setDefaultKilovolt_Amps:kilovolt_Amps];
        [subDivLoadVar setDefaultXFRMR:defaultSize];
        
    }
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
        UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        tapper.cancelsTouchesInView = NO;
        [self.view addGestureRecognizer:tapper];
    }
}

-(void)createQuantityPopoverListWithCell:(XFRMRQtylCell *)cell{
    
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
                                              animated:YES];
        
    }else {
        UITableViewController *tableView = [[UITableViewController alloc]init];
        tableView.tableView.delegate = cell;
        tableView.tableView.dataSource = cell;
        
        [self.navigationController pushViewController:tableView animated:YES];
    }
    
}

@end

#pragma mark - Implementation XFRMRSizeCell
@implementation XFRMRSizeCell
@synthesize sizeTxt;

#pragma mark - UITextField
- (void)textFieldDidEndEditing:(UITextField *)textField{
    XFRMR * updated = [[ XFRMR alloc]init];
    [updated setQtyl:0];
    [updated setSize:[textField.text floatValue]];
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
    [updated setSize:[_sizeLbl.text floatValue]];
    [updated setQtyl:(int)indexPath.row];
    [[self delegate] updateXFRMRQuantity:updated];
}

@end
