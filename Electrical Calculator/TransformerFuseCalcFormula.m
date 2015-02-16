//
//  TransformerFuseCalcFormula.m
//  Electrical Calculator
//
//  Created by Paul Marney on 2/5/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "TransformerFuseCalcFormula.h"

@interface TransformerFuseCalcFormula () {
    BOOL _config;
}

@end

@implementation TransformerFuseCalcFormula

#pragma mark - Life Cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [_typeLbl setText:@"UG"];
    UIBarButtonItem * configure = [[UIBarButtonItem alloc]initWithTitle:@"Configure" style:UIBarButtonItemStylePlain target:self action:@selector(pressedConfig:)];
    
    BOOL boolValue = [[UICKeyChainStore stringForKey:@"FormulaConfiguration"] boolValue];
    
    if (!boolValue) {
        _config = NO;
        [_defaultBtn setTitle:@"Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addFuseBtn setHidden:YES];
        [_addFuseBtn setEnabled:NO];
        [configure setTitle:@"Configure"];
        [[self.navigationController.viewControllers.lastObject navigationItem] setRightBarButtonItem:configure];
        [self.navigationController.viewControllers.lastObject setTitle:@"Transformer Rating"];
    }else {
        _config = YES;
        [_defaultBtn setTitle:@"Set Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addFuseBtn setHidden:NO];
        [_addFuseBtn setEnabled:YES];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_typeSmc.selectedSegmentIndex) {
        case 0:
            return _transformerFuseCalcV.ugs.count+1;
            break;
        case 1:
            return _transformerFuseCalcV.ohs.count+1;
            break;
        case 2:
            return _transformerFuseCalcV.subds.count+1;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0 && !_config){
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        switch (_typeSmc.selectedSegmentIndex) {
            case 0:
            case 1:
                [cell.textLabel setText:@"kVA"];
                break;
            case 2:
                [cell.textLabel setText:@"kVA/Phase"];
                break;
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    } else if (indexPath.row == 0){
        
        static NSString *simpleTableIdentifier = @"Celllabels";
        TransformerFuseLabelCell *cell = (TransformerFuseLabelCell *)[_fuseTV dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Celllabels" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        
        if (_typeSmc.selectedSegmentIndex == 0) {
            [cell.attribute1Lbl setText:@"KVA"];
            [cell.attribute2Lbl setText:@"BAYONET"];
            [cell.attribute3Lbl setText:@"NX"];
            [cell.attribute4Lbl setText:@"S&C SM"];
        } else if (_typeSmc.selectedSegmentIndex == 1) {
            [cell.attribute1Lbl setText:@"KVA"];
            [cell.attribute2Lbl setText:@"NX Comp II"];
            [cell.attribute2Lbl setAdjustsFontSizeToFitWidth:YES];
            [cell.attribute3Lbl setText:@"S&C"];
            [cell.attribute4Lbl setText:@"S&C Mult"];
        }else if (_typeSmc.selectedSegmentIndex == 2) {
            [cell.attribute1Lbl setText:@"KVA/Phase"];
            [cell.attribute1Lbl setAdjustsFontSizeToFitWidth:YES];
            [cell.attribute2Lbl setText:@"S&C STD"];
            [cell.attribute3Lbl setText:@""];
            [cell.attribute4Lbl setText:@""];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    }else {
        if (_config) {
            static NSString *simpleTableIdentifier = @"Celltexts";
            TransformerFuseEditCell *cell = (TransformerFuseEditCell *)[_fuseTV dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Celltexts" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            if (_typeSmc.selectedSegmentIndex == 0) {
                TFCUG *temp = _transformerFuseCalcV.ugs[indexPath.row-1];
                [cell.attribute1Txt setText:temp.KVA];
                [cell.attribute2Txt setText:[self roundingUp:temp.Bayonet andDecimalPlace:2]];
                [cell.attribute3Txt setText:temp.NX];
                [cell.attribute4Txt setText:temp.SnCSM];
            } else if (_typeSmc.selectedSegmentIndex == 1) {
                TFCOH *temp = _transformerFuseCalcV.ohs[indexPath.row-1];
                [cell.attribute1Txt setText:[self roundingUp:temp.KVA andDecimalPlace:2]];
                [cell.attribute2Txt setText:temp.NXCompII];
                [cell.attribute2Txt setAdjustsFontSizeToFitWidth:YES];
                [cell.attribute3Txt setText:[self roundingUp:temp.SnC andDecimalPlace:2]];
                [cell.attribute4Txt setText:[self roundingUp:temp.MultSnC andDecimalPlace:2]];
            }else if (_typeSmc.selectedSegmentIndex == 2) {
                TFCSUBD *temp = _transformerFuseCalcV.subds[indexPath.row-1];
                [cell.attribute1Txt setText:temp.CKVAnPhase];
                [cell.attribute1Txt setAdjustsFontSizeToFitWidth:YES];
                [cell.attribute2Txt setText:[self roundingUp:temp.SnCSTD andDecimalPlace:2]];
                [cell.attribute3Txt setText:@""];
                [cell.attribute4Txt setText:@""];
            }
            
            [cell.attribute1Txt setDelegate:cell];
            [cell.attribute2Txt setDelegate:cell];
            [cell.attribute3Txt setDelegate:cell];
            [cell.attribute4Txt setDelegate:cell];
            [cell setDelegate:self];
            [cell setTag:indexPath.row-1];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            
            
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            
            if (_typeSmc.selectedSegmentIndex == 0) {
                TFCUG *temp = _transformerFuseCalcV.ugs[indexPath.row-1];
                [cell.textLabel setText:[NSString stringWithFormat:@"%@",temp.KVA]];
            } else if (_typeSmc.selectedSegmentIndex == 1) {
                TFCOH *temp = _transformerFuseCalcV.ohs[indexPath.row-1];
                [cell.textLabel setText:[self roundingUp:temp.KVA andDecimalPlace:1]];
            }else if (_typeSmc.selectedSegmentIndex == 2) {
                TFCSUBD *temp = _transformerFuseCalcV.subds[indexPath.row-1];
                [cell.textLabel setText:temp.CKVAnPhase];
            }
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
        id temp;
        switch (_typeSmc.selectedSegmentIndex) {
            case 0:
                //UG
                temp  = _transformerFuseCalcV.ugs[indexPath.row-1];
                [_transformerFuseCalcV deleteTFCUGs:temp];
                break;
            case 1:
                //OH
                temp = _transformerFuseCalcV.ohs[indexPath.row-1];
                [_transformerFuseCalcV deleteTFCOHs:temp];
                break;
            case 2:
                //SUBD
                temp  = _transformerFuseCalcV.subds[indexPath.row-1];
                [_transformerFuseCalcV deleteTFCSUBD:temp];
                break;
        }
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationLeft];
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!_config && indexPath.row != 0) {
        if (_typeSmc.selectedSegmentIndex == 0) {
            TFCUG *temp = _transformerFuseCalcV.ugs[indexPath.row-1];
            [self calulateTotal:temp];
        } else if (_typeSmc.selectedSegmentIndex == 1) {
            TFCOH *temp = _transformerFuseCalcV.ohs[indexPath.row-1];
            [self calulateTotal:temp];
        }else if (_typeSmc.selectedSegmentIndex == 2) {
            TFCSUBD *temp = _transformerFuseCalcV.subds[indexPath.row-1];
            [self calulateTotal:temp];
        }
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
    [self.view endEditing:YES];
    
    if (boolValue) {
        _config = NO;
        [UICKeyChainStore setString:@"NO" forKey:@"FormulaConfiguration"];
        [_defaultBtn setTitle:@"Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addFuseBtn setHidden:YES];
        [_addFuseBtn setEnabled:NO];
        [self.navigationController.viewControllers.lastObject setTitle:@"Transformer Rating"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Configure"];
    }else {
        _config = YES;
        [UICKeyChainStore setString:@"YES" forKey:@"FormulaConfiguration"];
        [_defaultBtn setTitle:@"Set Default" forState:UIControlStateNormal];[_defaultBtn setNeedsLayout];
        [_addFuseBtn setHidden:NO];
        [_addFuseBtn setEnabled:YES];
        [self.navigationController.viewControllers.lastObject setTitle:@"Transformer Rating Configuration"];
        [[[self.navigationController.viewControllers.lastObject navigationItem] rightBarButtonItem]setTitle:@"Done"];
    }
    [_fuseTV deselectRowAtIndexPath:[_fuseTV indexPathForSelectedRow] animated:YES];
    [_fuseTV reloadData];
}

- (IBAction)addFuseAction:(id)sender {
    [_fuseTV endEditing:YES];
    id temp;
    switch (_typeSmc.selectedSegmentIndex) {
        case 0:
            //UG
            temp  = [[TFCUG alloc]init];
            [_transformerFuseCalcV addTFCUG:temp];
            break;
        case 1:
            //OH
            temp  = [[TFCOH alloc]init];
            [_transformerFuseCalcV addTFCOHs:temp];
            break;
        case 2:
            //SUBD
            temp  = [[TFCSUBD alloc]init];
            [_transformerFuseCalcV addTFCSUBD:temp];
            break;
    }
    [_fuseTV reloadData];
    [_addFuseBtn setEnabled:NO];
}

- (IBAction)resetDefaults:(id)sender {
    
    if (_config) {
        
        NSData* myDataArrayUG = [NSKeyedArchiver archivedDataWithRootObject:[_transformerFuseCalcV ugs]];;
        NSData* myDataArrayOH = [NSKeyedArchiver archivedDataWithRootObject:[_transformerFuseCalcV ohs]];
        NSData* myDataArraySUBD = [NSKeyedArchiver archivedDataWithRootObject:[_transformerFuseCalcV subds]];
        
        [UICKeyChainStore setData:myDataArrayUG forKey:@"SystemDefaultsArrayUG"];
        [UICKeyChainStore setData:myDataArrayOH forKey:@"SystemDefaultsArrayOH"];
        [UICKeyChainStore setData:myDataArraySUBD forKey:@"SystemDefaultsArraySUBD"];
        
        [TSMessage showNotificationInViewController:self.navigationController.viewControllers.lastObject title:@"Transformer Fuse" subtitle:@"Defaults has been save." type:TSMessageNotificationTypeSuccess duration:1.5];
        
        [_addFuseBtn setHidden:_config];
        [_addFuseBtn setEnabled:!_config];
        
    }else {
        NSData* myDataArrayUG = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayUG"];
        NSData* myDataArrayOH = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayOH"];
        NSData* myDataArraySUBD = [UICKeyChainStore dataForKey:@"SystemDefaultsArraySUBD"];
        NSMutableArray* defaultUG = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayUG];
        NSMutableArray* defaultOH = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayOH];
        NSMutableArray* defaultSUBD = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArraySUBD];
        
        [_transformerFuseCalcV setDefaultsTFCOH:defaultOH];
        [_transformerFuseCalcV setDefaultsTFCUG:defaultUG];
        [_transformerFuseCalcV setDefaultsTFCSUBD:defaultSUBD];
        
        [_fuseTV setDataSource:self];
        [_fuseTV setDelegate:self];
        
        [_fuseTV deselectRowAtIndexPath:[_fuseTV indexPathForSelectedRow] animated:YES];
        
        [_addFuseBtn setHidden:_config];
        [_addFuseBtn setEnabled:!_config];
        
        [_addFuseBtn setHidden:YES];
        [_addFuseBtn setEnabled:NO];
        
        [_title1Lbl setText:@""];
        [_title2Lbl setText:@""];
        [_title3Lbl setText:@""];
        [_title4Lbl setText:@""];
        [_attribute1Lbl setText:@""];
        [_attribute2Lbl setText:@""];
        [_attribute3Lbl setText:@""];
        [_attribute4Lbl setText:@""];
        
        [TSMessage showNotificationInViewController:self.navigationController.viewControllers.lastObject title:@"TransformerCalcFormula" subtitle:@"Defaults has been set." type:TSMessageNotificationTypeSuccess duration:1.5];
        
    }
    
    [_fuseTV reloadData];
}

#pragma mark -  TransformerRatingEditImpedanceCellDelegate

-(void)updateTransformerFuse:(id)fuse andIndexPath:(int)row{
    switch (_typeSmc.selectedSegmentIndex) {
        case 0:
            [_transformerFuseCalcV updateTFCUGs:fuse andIndex:row];
            break;
        case 1:
            [_transformerFuseCalcV updateTFCOH:fuse andIndex:row];
            break;
        case 2:
            [_transformerFuseCalcV updateTFCSUBD:fuse andIndex:row];
            break;
    }
}

-(void)canAddAnotherFuse:(BOOL)check{
    [_addFuseBtn setEnabled:check];
}

#pragma mark - Private Methods

-(void)initView{
    if (_transformerFuseCalcV == nil) {
        
        _transformerFuseCalcV = [[ TransformerFuseCalcVariables alloc ]init];
        
        [_fuseTV setDataSource:self];
        [_fuseTV setDelegate:self];
        [_fuseTV deselectRowAtIndexPath:[_fuseTV indexPathForSelectedRow] animated:YES];
        NSData* myDataArrayUG = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayUG"];
        NSData* myDataArrayOH = [UICKeyChainStore dataForKey:@"SystemDefaultsArrayOH"];
        NSData* myDataArraySUBD = [UICKeyChainStore dataForKey:@"SystemDefaultsArraySUBD"];
        NSMutableArray* defaultUG = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayUG];
        NSMutableArray* defaultOH = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArrayOH];
        NSMutableArray* defaultSUBD = [NSKeyedUnarchiver unarchiveObjectWithData:myDataArraySUBD];
        
        [_transformerFuseCalcV setUgs:defaultUG];
        [_transformerFuseCalcV setOhs:defaultOH];
        [_transformerFuseCalcV setSubds:defaultSUBD];
        
        
        [_typeSmc setSelectedSegmentIndex:0];
    }
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
        UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        tapper.cancelsTouchesInView = NO;
        [self.view addGestureRecognizer:tapper];
    }
    [_typeSmc addTarget:self
                 action:@selector(typeChanged:)
       forControlEvents:UIControlEventValueChanged];
    
    [_typeLbl setText:@""];
    [_title1Lbl setText:@""];
    [_title2Lbl setText:@""];
    [_title3Lbl setText:@""];
    [_title4Lbl setText:@""];
    [_attribute1Lbl setText:@""];
    [_attribute2Lbl setText:@""];
    [_attribute3Lbl setText:@""];
    [_attribute4Lbl setText:@""];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

- (void)typeChanged:(id)sender{
    
    switch (_typeSmc.selectedSegmentIndex) {
        case 0:
            [_typeLbl setText:@"UG"];
            break;
        case 1:
            [_typeLbl setText:@"OH"];
            break;
        case 2:
            [_typeLbl setText:@"SUBD"];
            break;
    }
    [_title1Lbl setText:@""];
    [_title2Lbl setText:@""];
    [_title3Lbl setText:@""];
    [_title4Lbl setText:@""];
    [_attribute1Lbl setText:@""];
    [_attribute2Lbl setText:@""];
    [_attribute3Lbl setText:@""];
    [_attribute4Lbl setText:@""];
    
    [_fuseTV reloadData];
}

-(void)calulateTotal:(id)fuse{
    
    if ([fuse isKindOfClass:[TFCUG class]]) {
        TFCUG *temp = [[TFCUG alloc]init];
        temp = fuse;
        [_title2Lbl setText:@"BAYONET"];
        [_title3Lbl setText:@"NX"];
        [_title4Lbl setText:@"S&C SM"];
        [_title1Lbl setText:@"KVA"];
        [_attribute2Lbl setText:[self roundingUp:temp.Bayonet andDecimalPlace:2]];
        [_attribute3Lbl setText:[NSString stringWithFormat:@"%@",temp.NX]];
        [_attribute4Lbl setText:[NSString stringWithFormat:@"%@",temp.SnCSM]];
        [_attribute1Lbl setText:temp.KVA];
    }
    if ([fuse isKindOfClass:[TFCOH class]]) {
        TFCOH *temp = [[TFCOH alloc]init];
        temp = fuse;
        [_title1Lbl setText:@"KVA"];
        [_title2Lbl setText:@"NX Comp II"];
        [_title3Lbl setText:@"S&C"];
        [_title4Lbl setText:@"S&C Mult."];
        [_attribute1Lbl setText:[self roundingUp:temp.KVA andDecimalPlace:2]];
        [_attribute2Lbl setText:[NSString stringWithFormat:@"%@",temp.NXCompII]];
        [_attribute3Lbl setText:[self roundingUp:temp.SnC andDecimalPlace:2]];
        [_attribute4Lbl setText:[self roundingUp:temp.MultSnC andDecimalPlace:2]];
    }
    if ([fuse isKindOfClass:[TFCSUBD class]]) {
        TFCSUBD *temp = [[TFCSUBD alloc]init];
        temp = fuse;
        [_title1Lbl setText:@"KVA/Phase"];
        [_title2Lbl setText:@"S&C STD"];
        [_title3Lbl setText:@""];
        [_title4Lbl setText:@""];
        [_attribute1Lbl setText:[NSString stringWithFormat:@"%@",temp.CKVAnPhase]];
        [_attribute2Lbl setText:[self roundingUp:temp.SnCSTD andDecimalPlace:2]];
        [_attribute3Lbl setText:@""];
        [_attribute4Lbl setText:@""];
    }
    
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

@implementation TransformerFuseLabelCell

@end

#pragma mark - TransformerRatingEditImpedanceCell

@implementation TransformerFuseEditCell
- (void)textFieldDidEndEditing:(UITextField *)textField{
    TransformerFuseCalcFormula *trans = (TransformerFuseCalcFormula *)self.delegate;
    
    switch (trans.typeSmc.selectedSegmentIndex) {
        case 0:
            [self updateUG:textField];
            break;
        case 1:
            [self updateOH:textField];
            break;
        case 2:
            [self updateSUBD:textField];
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    TransformerFuseCalcFormula *trans = (TransformerFuseCalcFormula *)self.delegate;
    NSRegularExpression *regex;
    switch (trans.typeSmc.selectedSegmentIndex) {
        case 0:
            regex = [self editUG:textField];
            break;
        case 1:
            regex = [self editOH:textField];
            break;
        case 2:
            regex = [self editSUBD:textField];
            break;
    }
    
    NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSTextCheckingResult *match = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
    BOOL x = (match != nil);
    [[self delegate]canAddAnotherFuse:(x && s.length>0)];
    return x;
}

-(void)OneAtATime{
    [[self delegate]canAddAnotherFuse:NO];
}

-(void)updateUG:(UITextField *)textField{
    TFCUG * fuse = [[ TFCUG alloc]init];
    if (textField == self.attribute1Txt)
        [fuse setKVA:textField.text];
    else
        [fuse setKVA:self.attribute1Txt.text];
    
    if (textField == self.attribute2Txt)
        [fuse setBayonet:[textField.text floatValue]];
    else
        [fuse setBayonet:[self.attribute2Txt.text floatValue]];
    if (textField == self.attribute3Txt)
        [fuse setNX:textField.text];
    else
        [fuse setNX:self.attribute3Txt.text];
    if (textField == self.attribute4Txt)
        [fuse setSnCSM:textField.text];
    else
        [fuse setSnCSM:self.attribute4Txt.text];
    
    [[self delegate] updateTransformerFuse:fuse andIndexPath:self.tag];
    
}

-(void)updateOH:(UITextField *)textField{
    TFCOH * fuse = [[ TFCOH alloc]init];
    if (textField == self.attribute1Txt)
        [fuse setKVA:[textField.text floatValue]];
    else
        [fuse setKVA:[self.attribute1Txt.text floatValue]];
    
    if (textField == self.attribute2Txt)
        [fuse setNXCompII:textField.text];
    else
        [fuse setNXCompII:self.attribute2Txt.text];
    if (textField == self.attribute3Txt)
        [fuse setSnC:[textField.text floatValue]];
    else
        [fuse setSnC:[self.attribute3Txt.text floatValue]];
    if (textField == self.attribute4Txt)
        [fuse setMultSnC:[textField.text floatValue]];
    else
        [fuse setMultSnC:[self.attribute4Txt.text floatValue]];
    
    [[self delegate] updateTransformerFuse:fuse andIndexPath:self.tag];
}

-(void)updateSUBD:(UITextField *)textField{
    TFCSUBD * fuse = [[ TFCSUBD alloc]init];
    if (textField == self.attribute2Txt)
        [fuse setSnCSTD:[textField.text floatValue]];
    else
        [fuse setSnCSTD:[self.attribute2Txt.text floatValue]];
    
    if (textField == self.attribute1Txt)
        [fuse setCKVAnPhase:textField.text];
    else
        [fuse setCKVAnPhase:self.attribute1Txt.text];
    
    [[self delegate] updateTransformerFuse:fuse andIndexPath:self.tag];
}


-(NSRegularExpression *)editUG:(UITextField *)textField{
    if (textField == self.attribute1Txt)//floatValue
        return [NSRegularExpression regularExpressionWithPattern:@"^(\\d{0,1})?(\\-)?\\d{0,9}$" options:0 error:nil];
    if (textField == self.attribute2Txt)//floatValue
        return [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
    if (textField == self.attribute3Txt)
        return [NSRegularExpression regularExpressionWithPattern:@"^(\\d{0,1})?(\\-)?\\d{0,9}(\\A)?(\\a)?$" options:0 error:nil];
    if (textField == self.attribute4Txt)
        return [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}(\\E)?(\\e)?$" options:0 error:nil];
    return [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
}

-(NSRegularExpression *)editOH:(UITextField *)textField{
    if (textField == self.attribute1Txt)//floatValue
        return [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
    if (textField == self.attribute2Txt)
        return [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}(\\A)?$" options:0 error:nil];
    if (textField == self.attribute3Txt)//floatValue
        return [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
    if (textField == self.attribute4Txt)//floatValue
        return [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
    return [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
}

-(NSRegularExpression *)editSUBD:(UITextField *)textField{
    if (textField == self.attribute2Txt)//floatValue
        return [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
    if (textField == self.attribute1Txt)
        return [NSRegularExpression regularExpressionWithPattern:@"^(\\<)?\\d{0,9}$" options:0 error:nil];
    return [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,9}$" options:0 error:nil];
}
@end