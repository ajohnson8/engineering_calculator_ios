//
//  DetailViewController.h
//  test
//
//  Created by Paul Marney on 1/26/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubdivisionLoadFormula.h"
#import "TransformerLoadFormula.h"
#import "TransformerRatingCalcFormula.h"
#import "FuseWizardFormula.h"
#import "BranchCircutVoltageDropFormula.h"
#import "MainServiceVoltageDropFormula.h"

@interface DetailViewController : UIViewController<SubdivisionLoadFormulaDelegate,TransformerLoadFormulaDelegate,TransformerRatingCalcFormulaDelegate,FuseWizardFormulaDelegate,BranchCircutVoltageDropFormulaDelegate,MainServiceVoltageDropFormulaDelegate>

@property (strong, nonatomic) id detailItem;
@property int transition;

@property (strong,nonatomic) NSString *  emailTitle;
@property (strong,nonatomic) NSString *  emailInfromation;
@property (strong,nonatomic) NSString *  emailDetails;

-(void)setupEmail;
@end

