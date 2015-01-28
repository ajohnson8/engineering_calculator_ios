//
//  DetailViewController.m
//  test
//
//  Created by Paul Marney on 1/26/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "DetailViewController.h"
#import "SubdivisionLoadFormula.h"

@interface DetailViewController ()

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
    SubdivisionLoadFormula *myCtrl = (SubdivisionLoadFormula *)[storyboard instantiateViewControllerWithIdentifier:view];
    
    CGRect rect = CGRectMake(self.view.frame.origin.x, 0 , self.view.frame.size.width, self.view.frame.size.height );
    myCtrl.view.frame = rect;
    [self removeChildViewControllers];
    [self addChildViewController:myCtrl];
    
    [UIView transitionWithView:self.view
                      duration:.75
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [self.view addSubview:myCtrl.view];
                        [myCtrl didMoveToParentViewController:self];
                    }
                    completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self configureView];
    

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

@end
