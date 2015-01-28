//
//  MasterViewController.h
//  test
//
//  Created by Paul Marney on 1/26/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransformerCalcVariables.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) TransformerCalcVariables *tranfor;


@end

