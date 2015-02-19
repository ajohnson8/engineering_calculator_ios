//
//  TransformerCalcVariablesFormula.h
//  Electrical Calculator
//
//  Created by Paul Marney on 1/26/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UICKeyChainStore/UICKeyChainStore.h>
#import <TSMessages/TSMessage.h>
#import "TransformerCalcVariables.h"

@protocol TransformerLoadFormulaDelegate <NSObject>
-(void)giveFormlaDetails:(NSString *)details;
-(void)giveFormlaInformation:(NSString *)information;
-(void)giveFormlaTitle:(NSString *)title;

@end

@protocol TransformerPhaseCellDelegate <NSObject>
@required
-(void)updateTransformerPhase:(TCPhase *)phase andIndexPath:(int)row;
@end

@protocol TransformerLLCellDelegate <NSObject>
@required
-(void)updateTransformerLL:(TCLLSec *)LLSec andIndexPath:(int)row;
-(void)canAddAnotherLLSec:(BOOL)check;
@end

@interface TransformerLoadFormula : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,TransformerLLCellDelegate,TransformerPhaseCellDelegate>

@property (strong, nonatomic) IBOutlet UITextField *kilaVoltAmpsTxt;
@property (strong, nonatomic) IBOutlet UITextField *ampsTxt;

@property (strong, nonatomic) IBOutlet UITableView *phaseTV;
@property (strong, nonatomic) IBOutlet UITableView *secLLVoltTV;

@property (strong, nonatomic) IBOutlet UILabel *FLAPLlb;
@property (strong, nonatomic) IBOutlet UILabel *FLASLlb;
@property (strong, nonatomic) IBOutlet UILabel *AFCPLlb;
@property (strong, nonatomic) IBOutlet UILabel *AFCSLlb;

@property (weak, nonatomic) IBOutlet UIButton *addLLVoltsBtn;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (weak, nonatomic) IBOutlet UIButton *configBtn;

@property (strong, nonatomic) TransformerCalcVariables* transformerCalcV;
@property (weak, nonatomic)id <TransformerLoadFormulaDelegate> delegate;
-(void)getEmail;

@end

@interface TransformerPhaseCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *phaseIDTxt;
@property (strong, nonatomic) IBOutlet UITextField *phaseVauleTxt;
@property (strong, nonatomic) IBOutlet UITextField *phaseLLTxt;

@property (weak, nonatomic)id <TransformerPhaseCellDelegate> delegate;

@end

@interface TransformerLLCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *LLSecVauleTxt;

@property (weak, nonatomic)id <TransformerLLCellDelegate> delegate;

-(void)OneAtATime;
@end