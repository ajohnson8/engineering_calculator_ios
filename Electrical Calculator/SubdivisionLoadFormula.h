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
#import <TSMessages/TSMessage.h>
#import "SubdivisionLoadVariables.h"

@protocol SubdivisionLoadFormulaDelegate <NSObject>
-(void)giveFormlaDetails:(NSString *)details;
-(void)giveFormlaInformation:(NSString *)information;
-(void)giveFormlaTitle:(NSString *)title;

@end

@protocol XFRMRQtylCellDelegate <NSObject>

@required
-(void)updateXFRMRQuantity:(XFRMR *)xfrmr;

@end

@protocol XFRMRSizeCellDelegate <NSObject>

@required
-(void)updateXFRMR:(XFRMR *)xfrmr andIndexPath:(int)row;
-(void)canAddAnother:(BOOL)check;

@end
@interface SubdivisionLoadFormula : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPopoverControllerDelegate,XFRMRQtylCellDelegate,XFRMRSizeCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *xfrmrTVC;

@property (strong, nonatomic) IBOutlet UITextField *voltAmpsTxt;
@property (strong, nonatomic) IBOutlet UITextField *voltTxt;

@property (strong, nonatomic) IBOutlet UILabel *calulationTotal;

@property (strong, nonatomic) IBOutlet UIButton *configBtn;
@property (weak  , nonatomic) IBOutlet UIButton *addSizeBtn;
@property (strong, nonatomic) IBOutlet UIButton *defaultBtn;

@property (nonatomic, strong) UIPopoverController *quantityPickerPopover;

@property (strong,nonatomic) SubdivisionLoadVariables *subDivLoadVar;

@property (weak, nonatomic)id <SubdivisionLoadFormulaDelegate> delegate;

-(void)getEmail;
@end


@interface XFRMRQtylCell : UITableViewCell <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *quantityLbl;
@property (strong, nonatomic) IBOutlet UILabel *sizeLbl;
@property (weak, nonatomic)id <XFRMRQtylCellDelegate> delegate;

@end


@interface XFRMRSizeCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *sizeTxt;
@property (weak, nonatomic)id <XFRMRSizeCellDelegate> delegate;

-(void)toggleAddSize;
@end

