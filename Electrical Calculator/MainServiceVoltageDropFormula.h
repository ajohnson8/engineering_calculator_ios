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
#import "MainServiceVoltageDropVariables.h"

@protocol MainServiceVoltageDropFormulaDelegate <NSObject>
-(void)giveFormlaDetails:(NSString *)details;
-(void)giveFormlaInformation:(NSString *)information;
-(void)giveFormlaTitle:(NSString *)title;

@end

@protocol MainServiceVoltageDropEditCellDelegate <NSObject>

@required
-(void)updateWire:(WSVDWire *)wire andIndexPath:(int)row;
-(void)canAddAnotherWire:(BOOL)check;

@end
@interface MainServiceVoltageDropFormula : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,MainServiceVoltageDropEditCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *wireTV;
@property (strong, nonatomic) IBOutlet UITableView *phaseTV;

@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *attributeLbl;
@property (weak, nonatomic) IBOutlet UILabel *type2Lbl;
@property (weak, nonatomic) IBOutlet UILabel *attribute2Lbl;

@property (strong, nonatomic) IBOutlet UITextField *lengthTxt;
@property (strong, nonatomic) IBOutlet UITextField *cirtCurrentTxt;
@property (strong, nonatomic) IBOutlet UITextField *cirtVoltTxt;
@property (strong, nonatomic) IBOutlet UITextField *wireResistivityTxt;

@property (weak, nonatomic) IBOutlet UIButton *addFuseBtn;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;

@property (strong, nonatomic) MainServiceVoltageDropVariables*  aluminumACVoltDropV;
@property (weak, nonatomic)id <MainServiceVoltageDropFormulaDelegate> delegate;

-(void)getEmail;
@end

@interface MainServiceVoltageDropLabelCell: UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *wireSizeLbl;
@property (strong, nonatomic) IBOutlet UILabel * conductorSectionLbl;

@end

@interface MainServiceVoltageDropEditCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *wireSizeTxt;
@property (strong, nonatomic) IBOutlet UITextField *ampacityTxt;
@property (weak, nonatomic)id <MainServiceVoltageDropEditCellDelegate> delegate;

@end