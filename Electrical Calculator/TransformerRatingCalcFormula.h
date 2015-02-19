//
//  TransformerRatingCalcFormula.h
//  Electrical Calculator
//
//  Created by Paul Marney on 2/3/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TSMessages/TSMessage.h>
#import <UICKeyChainStore/UICKeyChainStore.h>
#import "TransformerRatingCalcVariables.h"

@protocol TransformerRatingCalcFormulaDelegate <NSObject>
-(void)giveFormlaDetails:(NSString *)details;
-(void)giveFormlaInformation:(NSString *)information;
-(void)giveFormlaTitle:(NSString *)title;

@end

@protocol TransformerRatingEditImpedanceCellDelegate <NSObject>

@required
-(void)updateTransformerImpedance:(TRCImpedance *)impedance andIndexPath:(int)row;
-(void)canAddAnotherImpedance:(BOOL)check;

@end

@interface TransformerRatingCalcFormula : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,TransformerRatingEditImpedanceCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *impedanceTV;
@property (strong, nonatomic) IBOutlet UITextField *secVoltTxt;
@property (strong, nonatomic) IBOutlet UITextField *priVoltTxt;
@property (strong, nonatomic) IBOutlet UITextField *kilaVoltAmpsTxt;


@property (weak, nonatomic) IBOutlet UILabel *impedancePerLbl;
@property (weak, nonatomic) IBOutlet UILabel *priFLALbl;
@property (weak, nonatomic) IBOutlet UILabel *secFLALbl;
@property (weak, nonatomic) IBOutlet UILabel *priMaxLbl;
@property (weak, nonatomic) IBOutlet UILabel *priMinLbl;
@property (weak, nonatomic) IBOutlet UILabel *secBreakerLbl;
@property (weak, nonatomic) IBOutlet UILabel *faultPriLbl;
@property (weak, nonatomic) IBOutlet UILabel *faultSecLbl;

@property (weak, nonatomic) IBOutlet UIButton *addImpedanceBtn;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;


@property (strong, nonatomic) TransformerRatingCalcVariables* transformerRateCalcV;
@property (weak, nonatomic)id <TransformerRatingCalcFormulaDelegate> delegate;

-(void)getEmail;
@end

@interface TransformerRatingImpedanceCell: UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *KVALbl;
@property (strong, nonatomic) IBOutlet UILabel *V208Lbl;
@property (strong, nonatomic) IBOutlet UILabel *V480Lbl;

@end

@interface TransformerRatingEditImpedanceCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *KVATxt;
@property (strong, nonatomic) IBOutlet UITextField *V208Txt;
@property (strong, nonatomic) IBOutlet UITextField *V480Txt;
@property (weak, nonatomic)id <TransformerRatingEditImpedanceCellDelegate> delegate;

@end