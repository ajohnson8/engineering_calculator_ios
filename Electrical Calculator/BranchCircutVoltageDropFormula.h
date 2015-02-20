//
//  WireSizeVoltageDropFormula.h
//  Electrical Calculator
//
//  Created by Paul Marney on 2/11/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TSMessages/TSMessageView.h>
#import <UICKeyChainStore/UICKeyChainStore.h>
#import "BranchCircutVoltageDropVariables.h"

@protocol BranchCircutVoltageDropFormulaDelegate <NSObject>
-(void)giveFormlaDetails:(NSString *)details;
-(void)giveFormlaInformation:(NSString *)information;
-(void)giveFormlaTitle:(NSString *)title;

@end

@protocol BranchCircutVoltageDropEditCellDelegate <NSObject>

@required
-(void)updateWire:(WSVDWire *)wire andIndexPath:(int)row;
-(void)canAddAnotherWire:(BOOL)check;

@end

@protocol BranchCircutVoltageDropButtonDelegate <NSObject>

@required
-(void)updateVoltage:(int)volts;

@end

@interface BranchCircutVoltageDropButton: UIButton <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic)id <BranchCircutVoltageDropButtonDelegate> delegate;
@end

@interface BranchCircutVoltageDropFormula : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate,BranchCircutVoltageDropEditCellDelegate,BranchCircutVoltageDropButtonDelegate>

@property (strong, nonatomic) IBOutlet UITableView *wireTV;

@property (weak, nonatomic) IBOutlet UILabel *attribute1Lbl;
@property (weak, nonatomic) IBOutlet UILabel *attribute2Lbl;
@property (weak, nonatomic) IBOutlet UILabel *attribute3Lbl;
@property (weak, nonatomic) IBOutlet UILabel *attribute4Lbl;
@property (weak, nonatomic) IBOutlet UILabel *attribute5Lbl;
@property (weak, nonatomic) IBOutlet UILabel *attribute6Lbl;
@property (weak, nonatomic) IBOutlet UILabel *attribute7Lbl;
@property (weak, nonatomic) IBOutlet UILabel *attribute8Lbl;
@property (weak, nonatomic) IBOutlet UILabel *voltSizeLbl;
@property (weak, nonatomic) IBOutlet UILabel *wireSizeLbl;

@property (strong, nonatomic) IBOutlet UITextField *lengthTxt;
@property (strong, nonatomic) IBOutlet UITextField *cirtCurrentTxt;

@property (weak, nonatomic) IBOutlet UIButton *addFuseBtn;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (nonatomic, strong) UIPopoverController *quantityPickerPopover;

@property (strong, nonatomic) IBOutlet BranchCircutVoltageDropButton *voltage;

@property (strong, nonatomic) BranchCircutVoltageDropVariables* wireSizeVoltageDropV;
@property (weak, nonatomic)id <BranchCircutVoltageDropFormulaDelegate> delegate;

-(void)getEmail;

@end



@interface BranchCircutVoltageDropLabelCell: UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *wireSize;
@property (strong, nonatomic) IBOutlet UILabel *ampacity;
@property (strong, nonatomic) IBOutlet UILabel *ohms;

@end

@interface BranchCircutVoltageDropEditCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *wireSize;
@property (strong, nonatomic) IBOutlet UITextField *ampacity;
@property (strong, nonatomic) IBOutlet UITextField *ohms;
@property (weak, nonatomic)id <BranchCircutVoltageDropEditCellDelegate> delegate;

@end
