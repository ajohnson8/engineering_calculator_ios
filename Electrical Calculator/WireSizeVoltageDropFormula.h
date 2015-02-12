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
#import "WireSizeVoltageDropVariables.h"

@protocol WireSizeVoltageDropEditCellDelegate <NSObject>

@required
-(void)updateWire:(WSVDWire *)wire andIndexPath:(int)row;
-(void)canAddAnotherWire:(BOOL)check;

@end

@protocol WireSizeVoltageDropButtonDelegate <NSObject>

@required
-(void)updateVoltage:(int)volts;

@end


@interface WireSizeVoltageDropButton: UIButton <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic)id <WireSizeVoltageDropButtonDelegate> delegate;
@end

@interface WireSizeVoltageDropFormula : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate,WireSizeVoltageDropEditCellDelegate,WireSizeVoltageDropButtonDelegate>

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

@property (strong, nonatomic) IBOutlet WireSizeVoltageDropButton *voltage;

@property (strong, nonatomic) WireSizeVoltageDropVariables* wireSizeVoltageDropV;

@end

@interface WireSizeVoltageDropLabelCell: UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *wireSize;
@property (strong, nonatomic) IBOutlet UILabel *ampacity;
@property (strong, nonatomic) IBOutlet UILabel *ohms;

@end

@interface WireSizeVoltageDropEditCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *wireSize;
@property (strong, nonatomic) IBOutlet UITextField *ampacity;
@property (strong, nonatomic) IBOutlet UITextField *ohms;
@property (weak, nonatomic)id <WireSizeVoltageDropEditCellDelegate> delegate;

@end
