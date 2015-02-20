//
//  InformationViewController.h
//  Electrical Calculator
//
//  Created by Paul Marney on 2/19/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol InformationViewControllerDelegate <NSObject>

@end

@interface InformationViewController : UIViewController

@property (weak, nonatomic) id<InformationViewControllerDelegate> delegate;
@property (strong, nonatomic)NSString *information;
@property (strong, nonatomic)NSString *infoTitle;

@end