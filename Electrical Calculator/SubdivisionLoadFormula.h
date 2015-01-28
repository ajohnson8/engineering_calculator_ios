//
//  SubdivisionLoadFormula.h
//  Electrical Calculator
//
//  Created by Paul Marney on 1/21/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UICKeyChainStore/UICKeyChainStore.h>
#import "SubdivisionLoadVariables.h"
#import "NumberPadDoneBtn.h"

@protocol XFRMRQtylCellDelegate <NSObject>

@required
-(void)updateXFRMRQuantity:(XFRMR *)xfrmr;

@end

@protocol XFRMRSizeCellDelegate <NSObject>

@required
-(void)updateXFRMR:(XFRMR *)xfrmr andIndexPath:(int)row;
-(void)canAddAnother:(BOOL)check;

@end
@interface SubdivisionLoadFormula : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,XFRMRQtylCellDelegate,XFRMRSizeCellDelegate>

@property (strong, nonatomic) IBOutlet UILabel *calulationTotal;
@property (strong, nonatomic) IBOutlet UITextField *kilaVoltAmpsTxt;
@property (strong, nonatomic) IBOutlet UITextField *voltTxt;
@property (strong, nonatomic) IBOutlet UITableView *xfrmrTVC;
@property (strong, nonatomic) IBOutlet UIButton *configBtn;
@property (weak, nonatomic) IBOutlet UIButton *addSizeBtn;

@property (strong, nonatomic) IBOutlet UIButton *defaultBtn;

@property (strong,nonatomic) SubdivisionLoadVariables *subDivLoadVar;

@end


@interface XFRMRQtylCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *quantityTxt;
@property (strong, nonatomic) IBOutlet UILabel *sizeLbl;
@property (weak, nonatomic)id <XFRMRQtylCellDelegate> delegate;

@end


@interface XFRMRSizeCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *SizeTxt;
@property (weak, nonatomic)id <XFRMRSizeCellDelegate> delegate;

-(void)OneAtATime;
@end

