//
//  InformationViewController.m
//  Electrical Calculator
//
//  Created by Paul Marney on 2/19/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "InformationViewController.h"

@interface InformationViewController (){
    UITextView *_textView;
    UITapGestureRecognizer *_recognizer;
}
@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0,self.navigationController.toolbar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.toolbar.frame.size.height)];
    [_textView setFont:[UIFont boldSystemFontOfSize:15]];
    [_textView setText:_information];
    [_textView setUserInteractionEnabled:NO];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalViewControllerAnimated:)];
    [self.navigationItem setLeftBarButtonItem:backBtn animated:NO];
    
    [self.view addSubview:_textView];
    [self setTitle:_infoTitle];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
