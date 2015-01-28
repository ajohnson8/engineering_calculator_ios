//
//  TransformerCalcVariablesFormula.h
//  Electrical Calculator
//
//  Created by Paul Marney on 1/26/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UICKeyChainStore/UICKeyChainStore.h>
#import "TransformerCalcVariables.h"
#import "NumberPadDoneBtn.h"

@protocol TransformerPhaseCellDelegate <NSObject>

@required
-(void)updateTransformerPhase:(TCPhase *)phase andIndexPath:(int)row;

@end

@protocol TransformerLLCellDelegate <NSObject>

@required
-(void)updateTransformerLL:(TCLLSec *)LLSec andIndexPath:(int)row;
-(void)canAddAnotherLLSec:(BOOL)check;

@end

@interface TransformerCalcFormula : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,TransformerLLCellDelegate,TransformerPhaseCellDelegate>

@property (strong, nonatomic) IBOutlet UITextField *kilaVoltTxt;
@property (strong, nonatomic) IBOutlet UITextField *ampsTxt;
@property (strong, nonatomic) IBOutlet UITableView *tcPhaseTVC;
@property (strong, nonatomic) IBOutlet UITableView *tcLLSecTVC;
@property (strong, nonatomic) IBOutlet UILabel *tcFLAPLlb;
@property (strong, nonatomic) IBOutlet UILabel *tcFLASLlb;
@property (strong, nonatomic) IBOutlet UILabel *tcAFCPLlb;
@property (strong, nonatomic) IBOutlet UILabel *tcAFCSLlb;
@property (weak, nonatomic) IBOutlet UIButton *addLLVoltsBtn;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (weak, nonatomic) IBOutlet UIButton *configBtn;

@property (strong, nonatomic) TransformerCalcVariables* transformerCalcV;

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