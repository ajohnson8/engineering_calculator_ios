//
//  TransformerFuseCalcFormula.h
//  Electrical Calculator
//
//  Created by Paul Marney on 2/5/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UICKeyChainStore/UICKeyChainStore.h>
#import <TSMessages/TSMessage.h>
#import "FuseWizardVariables.h"

@protocol FuseWizardFormulaDelegate <NSObject>
-(void)giveFormlaDetails:(NSString *)details;
-(void)giveFormlaInformation:(NSString *)information;
-(void)giveFormlaTitle:(NSString *)title;

@end


@protocol FuseWizardEditCellDelegate <NSObject>

@required
-(void)updateTransformerFuse:(id)fuse andIndexPath:(int)row;
-(void)reloadList;
-(void)canAddAnotherFuse:(BOOL)check;

@end


@interface FuseWizardFormula : UIViewController <UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,FuseWizardEditCellDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSmc;

@property (strong, nonatomic) IBOutlet UITableView *fuseTV;


@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *title1Lbl;
@property (weak, nonatomic) IBOutlet UILabel *title2Lbl;
@property (weak, nonatomic) IBOutlet UILabel *title3Lbl;
@property (weak, nonatomic) IBOutlet UILabel *title4Lbl;

@property (weak, nonatomic) IBOutlet UILabel *attribute1Lbl;
@property (weak, nonatomic) IBOutlet UILabel *attribute2Lbl;
@property (weak, nonatomic) IBOutlet UILabel *attribute3Lbl;
@property (weak, nonatomic) IBOutlet UILabel *attribute4Lbl;

@property (weak, nonatomic) IBOutlet UIButton *addFuseBtn;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;

@property (strong, nonatomic) FuseWizardVariables* transformerFuseCalcV;
@property (weak, nonatomic)id <FuseWizardFormulaDelegate> delegate;

-(void)getEmail;

+(id)sreachForFuseByTempFuseType:(id)type;

@end

@interface FuseWizardLabelCell: UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *attribute1Lbl;
@property (strong, nonatomic) IBOutlet UILabel *attribute2Lbl;
@property (strong, nonatomic) IBOutlet UILabel *attribute3Lbl;
@property (strong, nonatomic) IBOutlet UILabel *attribute4Lbl;

@end

@interface TransformerFuseEditCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *attribute1Txt;
@property (strong, nonatomic) IBOutlet UITextField *attribute2Txt;
@property (strong, nonatomic) IBOutlet UITextField *attribute3Txt;
@property (strong, nonatomic) IBOutlet UITextField *attribute4Txt;
@property (weak, nonatomic)id <FuseWizardEditCellDelegate> delegate;

@end