//
//  AluminumACVoltDropFormula.h
//  Electrical Calculator
//
//  Created by Paul Marney on 2/10/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TSMessages/TSMessageView.h>
#import <UICKeyChainStore/UICKeyChainStore.h>
#import "AluminumACVoltDropVariables.h"

@protocol AluminumACVoltageDropEditCellDelegate <NSObject>

@required
-(void)updateWire:(WSVDWire *)wire andIndexPath:(int)row;
-(void)canAddAnotherWire:(BOOL)check;

@end
@interface AluminumACVoltDropFormula : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,AluminumACVoltageDropEditCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *wireTV;
@property (strong, nonatomic) IBOutlet UITableView *phaseTV;

@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *attributeLbl;

@property (strong, nonatomic) IBOutlet UITextField *lengthTxt;
@property (strong, nonatomic) IBOutlet UITextField *cirtCurrentTxt;
@property (strong, nonatomic) IBOutlet UITextField *cirtVoltTxt;
@property (strong, nonatomic) IBOutlet UITextField *wireResistivityTxt;

@property (weak, nonatomic) IBOutlet UIButton *addFuseBtn;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;

@property (strong, nonatomic) AluminumACVoltDropVariables*  aluminumACVoltDropV;

@end

@interface AluminumACVoltageDropLabelCell: UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *wireSizeLbl;
@property (strong, nonatomic) IBOutlet UILabel * conductorSectionLbl;

@end

@interface AluminumACVoltageDropEditCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *wireSizeTxt;
@property (strong, nonatomic) IBOutlet UITextField *ampacityTxt;
@property (weak, nonatomic)id <AluminumACVoltageDropEditCellDelegate> delegate;

@end