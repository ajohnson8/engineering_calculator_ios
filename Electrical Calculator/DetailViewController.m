//
//  DetailViewController.m
//  test
//
//  Created by Paul Marney on 1/26/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "DetailViewController.h"


@interface DetailViewController (){
    UIViewController *_currentCtrl;
}

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        // Update the view.
        [self configureView:newDetailItem];
    }
}

- (void)configureView:(NSString *)view {
    // Update the user interface for the detail item.
    [super viewDidLoad];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _currentCtrl = (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:view];
    
    CGRect rect = CGRectMake(self.view.frame.origin.x, 0 , self.view.frame.size.width, self.view.frame.size.height );
    _currentCtrl.view.frame = rect;
    [self removeChildViewControllers];
    [self addChildViewController:_currentCtrl];
    
    if (_transition == 0)
        [UIView transitionWithView:self.view
                          duration:.75
                           options:UIViewAnimationOptionTransitionCurlUp
                        animations:^{
                            [self.view addSubview:_currentCtrl.view];
                            [_currentCtrl didMoveToParentViewController:self];
                        }
                        completion:nil];
    else
        [UIView transitionWithView:self.view
                          duration:.75
                           options:UIViewAnimationOptionTransitionCurlDown
                        animations:^{
                            [self.view addSubview:_currentCtrl.view];
                            [_currentCtrl didMoveToParentViewController:self];
                        }
                        completion:nil];
}
-(id)init{
    self = [ super init];
    if (self) {
        [UICKeyChainStore setString:@"NO" forKey:@"SubdivisionLoadFormulaConfig"];
        [self configureView:@"SubdivisionLoadFormula"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - private
- (void) removeChildViewControllers {
    
    for ( __strong UIViewController * obj in [self childViewControllers]){
        [obj willMoveToParentViewController:nil];  // 1
        [obj.view removeFromSuperview];            // 2
        [obj removeFromParentViewController];
        obj = nil;
    }
    
}


-(void)setupEmail{
    
    if([_currentCtrl isKindOfClass:[SubdivisionLoadFormula class]]){
        SubdivisionLoadFormula *temp = (SubdivisionLoadFormula *)_currentCtrl;
        [temp setDelegate:self];
        [temp getEmail];
    } else if([_currentCtrl isKindOfClass:[TransformerLoadFormula class]]){
        TransformerLoadFormula *temp = (TransformerLoadFormula *)_currentCtrl;
        [temp setDelegate:self];
        [temp getEmail];
    } else if([_currentCtrl isKindOfClass:[TransformerRatingCalcFormula class]]){
        TransformerRatingCalcFormula *temp = (TransformerRatingCalcFormula *)_currentCtrl;
        [temp setDelegate:self];
        [temp getEmail];
    }
    else if([_currentCtrl isKindOfClass:[FuseWizardFormula class]]){
        FuseWizardFormula *temp = (FuseWizardFormula *)_currentCtrl;
        [temp setDelegate:self];
        [temp getEmail];
    }else if([_currentCtrl isKindOfClass:[BranchCircutVoltageDropFormula class]]){
        BranchCircutVoltageDropFormula *temp = (BranchCircutVoltageDropFormula *)_currentCtrl;
        [temp setDelegate:self];
        [temp getEmail];
    }else if([_currentCtrl isKindOfClass:[MainServiceVoltageDropFormula class]]){
        MainServiceVoltageDropFormula *temp = (MainServiceVoltageDropFormula *)_currentCtrl;
        [temp setDelegate:self];
        [temp getEmail];
    }
}

-(void)giveFormlaDetails:(NSString *)details{
    _emailDetails =details;
}
-(void)giveFormlaInformation:(NSString *)information{
    _emailInfromation = information;
}
-(void)giveFormlaTitle:(NSString *)title{
    _emailTitle =title;
}

@end
