//
//  MasterViewController.h
//  test
//
//  Created by Paul Marney on 1/26/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import "TransformerCalcVariables.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <UIGestureRecognizerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIToolbarDelegate,MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) TransformerCalcVariables *tranfor;
@property (strong, nonatomic) IBOutlet UITableView *table;

@end

@interface Forumal : NSObject
@property (strong, nonatomic) NSString *storyboardName;
@property (strong, nonatomic) NSString *name;
@end

@interface ForumalCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *name;

@end